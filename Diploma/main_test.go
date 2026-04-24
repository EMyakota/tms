package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestRootEndpoint(t *testing.T) {
	server := &appServer{
		config: appConfig{
			AppName: "test-service",
			Version: "test",
			Env:     "test",
			Port:    8080,
		},
	}

	req := httptest.NewRequest(http.MethodGet, "/", nil)
	rr := httptest.NewRecorder()

	server.router().ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", rr.Code)
	}
}

func TestHelloEndpoint(t *testing.T) {
	server := &appServer{
		config: appConfig{
			AppName: "test-service",
			Version: "test",
			Env:     "test",
			Port:    8080,
		},
	}

	req := httptest.NewRequest(http.MethodGet, "/api/v1/hello?name=Alex", nil)
	rr := httptest.NewRecorder()

	server.router().ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", rr.Code)
	}

	var payload map[string]any
	if err := json.Unmarshal(rr.Body.Bytes(), &payload); err != nil {
		t.Fatalf("failed to decode response: %v", err)
	}

	if payload["message"] != "Hello, Alex!" {
		t.Fatalf("unexpected message: %v", payload["message"])
	}
}

func TestHealthEndpoint(t *testing.T) {
	server := &appServer{
		config: appConfig{
			AppName: "test-service",
			Version: "test",
			Env:     "test",
			Port:    8080,
		},
	}

	req := httptest.NewRequest(http.MethodGet, "/healthz", nil)
	rr := httptest.NewRecorder()

	server.router().ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("expected status 200, got %d", rr.Code)
	}
}
