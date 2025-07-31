#!/bin/bash


# Установка и настройка пакетов
script_dirs=(*/)
for dir in "${script_dirs[@]}"; do
    echo ${dir}
    cd ${dir}
    scripts=(*)
    for script in "${scripts[@]}"; do
        if [[ ${script} == *.sh ]]; then
            echo " "
            echo "${script}"
            echo " "
            ./${script}
        fi
    done
    cd ..
done

echo "need uncomment [multilib]"
echo "/ect/pacman.conf"

# Обновление системы
sudo pacman -Syu

sudo mkinitcpio -P

