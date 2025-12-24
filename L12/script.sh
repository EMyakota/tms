#!/bin/bash
#STDIN 0 - ввод
#STDOUT 1 - вывод
#STDERR 2 - вывод ошибок
# > - перенаправление вывода (перезапись или создание файла)
# >> - добавить в конец файла вывод

set -eou
# Параметры выполнения для интерпретатора
# e - exit
# o - 
# u - unset если есть пустые переменные завершить скрипт

check_status(){
    local service_name=$1
    pgrep -x "{$service_name}" > /dev/null
}