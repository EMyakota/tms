package main

import (
	"encoding/json"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	requestsTotal = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "hello_requests_total",
			Help: "Total number of handled HTTP requests.",
		},
		[]string{"path", "method", "status"},
	)
	requestDuration = promauto.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "hello_request_duration_seconds",
			Help:    "Duration of HTTP requests in seconds.",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"path", "method"},
	)
)

type appConfig struct {
	AppName string `json:"app_name"`
	Version string `json:"version"`
	Env     string `json:"env"`
	Port    int    `json:"port"`
}

type appServer struct {
	config    appConfig
	startedAt time.Time
}

type statusRecorder struct {
	http.ResponseWriter
	statusCode int
}

func (sr *statusRecorder) WriteHeader(code int) {
	sr.statusCode = code
	sr.ResponseWriter.WriteHeader(code)
}

func main() {
	cfg := loadConfig()
	server := &appServer{
		config:    cfg,
		startedAt: time.Now(),
	}

	srv := &http.Server{
		Handler:      server.router(),
		Addr:         ":" + strconv.Itoa(cfg.Port),
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
		IdleTimeout:  30 * time.Second,
	}

	log.Printf("starting %s on port %d in %s mode", cfg.AppName, cfg.Port, cfg.Env)
	log.Fatal(srv.ListenAndServe())
}

func loadConfig() appConfig {
	return appConfig{
		AppName: getEnv("APP_NAME", "tms-diploma-service"),
		Version: getEnv("APP_VERSION", "1.0.0"),
		Env:     getEnv("APP_ENV", "dev"),
		Port:    getEnvInt("PORT", 8080),
	}
}

func (s *appServer) router() *mux.Router {
	r := mux.NewRouter()
	r.Use(metricsMiddleware)
	r.HandleFunc("/", s.handleRoot).Methods(http.MethodGet)
	r.HandleFunc("/api/v1/hello", s.handleHello).Methods(http.MethodGet)
	r.HandleFunc("/healthz", s.handleHealth).Methods(http.MethodGet)
	r.HandleFunc("/readyz", s.handleReady).Methods(http.MethodGet)
	r.Handle("/metrics", promhttp.Handler()).Methods(http.MethodGet)
	return r
}

func (s *appServer) handleRoot(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"message": "TMS diploma service is running",
		"service": s.config.AppName,
		"version": s.config.Version,
		"env":     s.config.Env,
	})
}

func (s *appServer) handleHello(w http.ResponseWriter, r *http.Request) {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "world"
	}

	writeJSON(w, http.StatusOK, map[string]any{
		"message": "Hello, " + name + "!",
		"service": s.config.AppName,
		"version": s.config.Version,
		"env":     s.config.Env,
	})
}

func (s *appServer) handleHealth(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"status": "ok",
		"uptime": time.Since(s.startedAt).String(),
	})
}

func (s *appServer) handleReady(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]any{
		"status":  "ready",
		"service": s.config.AppName,
	})
}

func metricsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		recorder := &statusRecorder{
			ResponseWriter: w,
			statusCode:     http.StatusOK,
		}
		start := time.Now()
		next.ServeHTTP(recorder, r)

		route := "unknown"
		if currentRoute := mux.CurrentRoute(r); currentRoute != nil {
			if template, err := currentRoute.GetPathTemplate(); err == nil {
				route = template
			}
		}

		requestsTotal.WithLabelValues(route, r.Method, strconv.Itoa(recorder.statusCode)).Inc()
		requestDuration.WithLabelValues(route, r.Method).Observe(time.Since(start).Seconds())
	})
}

func writeJSON(w http.ResponseWriter, status int, payload any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(payload)
}

func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

func getEnvInt(key string, fallback int) int {
	value := os.Getenv(key)
	if value == "" {
		return fallback
	}

	parsed, err := strconv.Atoi(value)
	if err != nil {
		return fallback
	}

	return parsed
}
