#!/bin/bash

# Получение температуры CPU
# Проверяем доступные датчики температуры (обычно в /sys/class/thermal/thermal_zone*/temp)

temp=0
count=0

# Перебираем все доступные thermal zones
for zone in $(ls -d /sys/class/thermal/thermal_zone*); do
    type=$(cat "${zone}/type")
    # Проверяем, что это датчик CPU (может называться по-разному в разных системах)
    if [[ "$type" == *"cpu"* || "$type" == *"x86"* || "$type" == *"core"* || "$type" == *"Tdie"* ]]; then
        current_temp=$(cat "${zone}/temp")
        current_temp=$((current_temp/1000))
        temp=$((temp + current_temp))
        count=$((count + 1))
    fi
done

if [ $count -gt 0 ]; then
    # Вычисляем среднюю температуру, если найдено несколько датчиков
    average_temp=$((temp/count))
    echo "${average_temp}°C"
else
    # Альтернативный метод через sensors, если thermal zones не работают
    if command -v sensors &> /dev/null; then
        temp=$(sensors | grep -m 1 -E '(Package id|Tdie|CPU)' | grep -oE '+[0-9.]+°C' | head -1)
        echo "${temp#+}"  # Удаляем знак + если он есть
    else
        echo "Не удалось определить температуру CPU"
        exit 1
    fi
fi
