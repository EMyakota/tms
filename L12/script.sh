#!/bin/bash
#STDIN 0 - ввод
#STDOUT 1 - вывод
#STDERR 2 - вывод ошибок
# > - перенаправление вывода (перезапись или создание файла)
# >> - добавить в конец файла вывод
# < - перенаправление ввода
# | 

set -xeou pipefail
# Параметры выполнения для интерпретатора
# pipefail - если одна из команд пайпа с ошибкой, то весь конвейер завершится с ошибкой
# echo "hello" | grep hello
# set - опции для bash
# x - bebag
# e - exit
# o pipefail 
# u - unset если есть пустые переменные завершить скрипт
# snake_case

#SERVICE_NAME="bash"
declare -a SERVICES=("sshd" "httpd" "mysql" "app")
$SERVICES[0]="myservice"; echo ${SERVICES[0]}
# associative array
declare -A SERVICE_STATUSES["http"]="running" 
echo ${SERVICE_STATUSES["http"]}
echo ${SERVICE_STATUSES[@]} #all values
echo ${!SERVICE_STATUSES[@]} #all keys

check_status(){
    local service_name=$1
    pgrep -x "{$service_name}" > /dev/null
    return $?
}

for service in "{$SERVICES[@]}"; do
    check_status "$service"
    SERVISE_STATUS=$?
# exit code 0 - success
# exit code 1 - fail
    if [[ $SERVICE_STATUS -eq 0 ]]; then
        REPORT_MSG="RUNNING"
    elif [[ $SERVICE_STATUS -eq 1 ]]; then
        REPORT_MSG="STOPPED"
    else 
        REPORT_MSG="UNKNOWN STATUS"
    fi

case $service in 
    sshd)
        SERVICE_TYPE="critical"
    ;;
    httpd | mysql)
        SERVICE_TYPE="high"
    ;;
    *)
        SERVICE_TYPE="non_critical"
    ;;
esac

echo "Service: $service is $REPORT_MSG. type: $SERVICE_TYPE"

    if [[ $SERVICE_TYPE == critical && $REPORT_MSG == STOPPED ]]; then
        echo "ERROR: critical service failure detected: $service" >&2
    else 
        echo "success"
    fi
    done

    echo "CHECK complete"