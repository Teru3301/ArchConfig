#!/bin/bash

# Получение текущей загрузки CPU
# Способ 2: Используем /proc/stat (работает везде, где есть /proc)
if [ -f /proc/stat ]; then
    read cpu user nice system idle iowait irq softirq steal guest guest_nice < <(grep '^cpu ' /proc/stat)
    
    # Вычисляем общее время процессора
    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    
    # Вычисляем время простоя
    idle_total=$((idle + iowait))
    
    # Вычисляем использование CPU (в процентах)
    usage=$((100 * (total - idle_total) / total))
    
    echo "${usage}"
    exit 0
fi

echo "Не удалось определить загрузку CPU"
exit 1
