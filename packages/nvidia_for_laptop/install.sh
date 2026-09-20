#!/bin/bash
# Настройка гибридной графики Intel (iGPU) + Nvidia (dGPU) на ноутбуке (Optimus).
# Работает как самостоятельный скрипт (bash install.sh), так и внутри
# общей структуры archsetup (packages/nvidia_for_laptop/install.sh).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- common.sh: подхватываем, если есть, иначе минимальный fallback ---
if [ -f "$DIR/../../lib/common.sh" ]; then
    # shellcheck source=/dev/null
    source "$DIR/../../lib/common.sh"
else
    log_info()  { echo -e "\033[1;34m[i]\033[0m $*"; }
    log_ok()    { echo -e "\033[1;32m[✓]\033[0m $*"; }
    log_warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
    log_err()   { echo -e "\033[1;31m[x]\033[0m $*" >&2; }
    is_installed() { pacman -Qi "$1" &>/dev/null; }
    pkg_install() {
        local pkg="$1"
        if is_installed "$pkg"; then log_ok "$pkg уже установлен"; return 0; fi
        log_info "Устанавливаю $pkg..."
        if command -v yay &>/dev/null; then yay -S --noconfirm --needed "$pkg"
        else sudo pacman -S --noconfirm --needed "$pkg"; fi
    }
    pkg_install_many() { local p; for p in "$@"; do pkg_install "$p"; done; }
fi

NEED_INITRD_REGEN=false

# ---------------------------------------------------------------------------
# 1. Проверка что вообще есть гибридная графика Intel + Nvidia
# ---------------------------------------------------------------------------
log_info "Проверка видеокарт (lspci)..."
GPU_INFO="$(lspci -k | grep -A2 -E 'VGA|3D controller' || true)"
echo "$GPU_INFO"

if ! echo "$GPU_INFO" | grep -qi nvidia; then
    log_warn "Nvidia GPU не обнаружена через lspci. Продолжаю на свой страх и риск."
fi
if ! echo "$GPU_INFO" | grep -qi intel; then
    log_warn "Intel GPU не обнаружена через lspci. Этот скрипт рассчитан на гибрид Intel+Nvidia."
fi

# ---------------------------------------------------------------------------
# 2. Выбор варианта драйвера: проприетарный (nvidia) или open-kernel (nvidia-open)
#    nvidia-open поддерживает только Turing и новее (GTX 16xx / RTX 20xx+)
# ---------------------------------------------------------------------------
DRIVER_PKG="nvidia"
DRIVER_UTILS_PKG="nvidia-utils"

if [ -t 0 ]; then
    read -rp "Ваша видеокарта Turing или новее (GTX 16xx / RTX 20xx/30xx/40xx)? [y/N] " is_turing
else
    is_turing="n"
fi
if [[ "$is_turing" =~ ^[Yy]$ ]]; then
    DRIVER_PKG="nvidia-open"
    log_info "Использую открытые kernel-модули: $DRIVER_PKG"
else
    log_info "Использую проприетарный модуль: $DRIVER_PKG"
fi

if ! pacman -Qq linux &>/dev/null; then
    log_warn "Пакет 'linux' (стандартное ядро) не найден. Если у вас другое ядро" \
             "(linux-lts, linux-zen и т.п.) — используйте dkms-вариант драйвера" \
             "(nvidia-dkms / nvidia-open-dkms) и поставьте соответствующие headers вручную."
fi

# ---------------------------------------------------------------------------
# 3. Установка пакетов
# ---------------------------------------------------------------------------
pkg_install_many \
    "$DRIVER_PKG" \
    "$DRIVER_UTILS_PKG" \
    nvidia-settings \
    linux-headers \
    egl-wayland \
    vulkan-icd-loader \
    libva-nvidia-driver \
    opencl-nvidia \
    nvtop \
    mesa \
    vulkan-intel \
    nvidia-prime

if pacman -Qi multilib-devel &>/dev/null || grep -q '^\[multilib\]' /etc/pacman.conf; then
    pkg_install_many lib32-vulkan-icd-loader lib32-mesa lib32-vulkan-intel
else
    log_warn "[multilib] не включён в /etc/pacman.conf — пропускаю lib32-vulkan-icd-loader/lib32-mesa/lib32-vulkan-intel" \
             "(нужно для 32-битных игр/Steam с offload на Nvidia)"
fi

# bbswitch — полное отключение питания дискретной Nvidia на старых Optimus
# ноутбуках. На современных ядрах/драйверах часто не нужен (за power-management
# отвечает NVreg_DynamicPowerManagement выше) и местами конфликтует —
# ставим best-effort, не валим весь скрипт если сборка модуля не удалась.
if ! pkg_install bbswitch; then
    log_warn "bbswitch не поставился (нередко на новых ядрах) — не критично, пропускаю"
fi

# ---------------------------------------------------------------------------
# 4. Блэклист nouveau (открытый драйвер, конфликтует с проприетарным nvidia)
# ---------------------------------------------------------------------------
BLACKLIST_FILE=/etc/modprobe.d/blacklist-nouveau.conf
BLACKLIST_CONTENT='blacklist nouveau
options nouveau modeset=0'

if [ ! -f "$BLACKLIST_FILE" ] || ! diff -q <(echo "$BLACKLIST_CONTENT") "$BLACKLIST_FILE" &>/dev/null; then
    echo "$BLACKLIST_CONTENT" | sudo tee "$BLACKLIST_FILE" > /dev/null
    log_ok "nouveau заблокирован ($BLACKLIST_FILE)"
    NEED_INITRD_REGEN=true
else
    log_ok "nouveau уже заблокирован"
fi

# ---------------------------------------------------------------------------
# 5. modprobe-опции nvidia: modeset для Wayland/KMS + энергосбережение
# ---------------------------------------------------------------------------
MODPROBE_FILE=/etc/modprobe.d/nvidia.conf
MODPROBE_CONTENT='options nvidia_drm modeset=1 fbdev=1
options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_DynamicPowerManagement=0x02'

if [ ! -f "$MODPROBE_FILE" ] || ! diff -q <(echo "$MODPROBE_CONTENT") "$MODPROBE_FILE" &>/dev/null; then
    echo "$MODPROBE_CONTENT" | sudo tee "$MODPROBE_FILE" > /dev/null
    log_ok "modprobe.d/nvidia.conf записан (modeset=1, runtime PM)"
    NEED_INITRD_REGEN=true
else
    log_ok "modprobe.d/nvidia.conf уже настроен"
fi

# ---------------------------------------------------------------------------
# 6. mkinitcpio: ранняя загрузка nvidia-модулей (обязательно для Wayland KMS)
# ---------------------------------------------------------------------------
MKINITCPIO_CONF=/etc/mkinitcpio.conf
NEEDED_MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

current_modules="$(grep -E '^MODULES=' "$MKINITCPIO_CONF" | sed -E 's/^MODULES=\(([^)]*)\)/\1/')"
new_modules="$current_modules"
changed=false
for m in "${NEEDED_MODULES[@]}"; do
    if ! grep -qw "$m" <<< "$current_modules"; then
        new_modules="$new_modules $m"
        changed=true
    fi
done

if [ "$changed" = true ]; then
    new_modules="$(echo "$new_modules" | xargs)"
    sudo sed -i -E "s/^MODULES=\([^)]*\)/MODULES=($new_modules)/" "$MKINITCPIO_CONF"
    log_ok "mkinitcpio.conf: MODULES обновлены -> ($new_modules)"
    NEED_INITRD_REGEN=true
else
    log_ok "mkinitcpio.conf: nvidia-модули уже добавлены"
fi

# ---------------------------------------------------------------------------
# 7. Пересборка initramfs, если что-то поменяли
# ---------------------------------------------------------------------------
if [ "$NEED_INITRD_REGEN" = true ]; then
    log_info "Пересобираю initramfs (mkinitcpio -P)..."
    sudo mkinitcpio -P
else
    log_ok "initramfs пересборка не требуется, изменений нет"
fi

# ---------------------------------------------------------------------------
# 8. systemd-сервисы для корректного suspend/hibernate/resume с Nvidia
# ---------------------------------------------------------------------------
for svc in nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service; do
    if systemctl list-unit-files "$svc" &>/dev/null; then
        sudo systemctl enable "$svc" &>/dev/null || true
        log_ok "$svc включён"
    fi
done
# nvidia-powerd — Dynamic Boost на некоторых ноутбуках, есть не у всех моделей
if systemctl list-unit-files nvidia-powerd.service &>/dev/null; then
    sudo systemctl enable --now nvidia-powerd.service &>/dev/null || \
        log_warn "nvidia-powerd есть, но не запустился — не критично, не все ноутбуки его поддерживают"
fi

# ---------------------------------------------------------------------------
# 9. Скрипт offload-запуска приложений на Nvidia (аналог prime-run)
# ---------------------------------------------------------------------------
OFFLOAD_SCRIPT=/usr/local/bin/nvidia-offload
sudo tee "$OFFLOAD_SCRIPT" > /dev/null << 'EOF'
#!/bin/bash
# Запуск приложения на дискретной Nvidia через PRIME render offload,
# остальное по умолчанию идёт через встроенную Intel-графику (экономия батареи).
# Использование: nvidia-offload glxgears
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
exec "$@"
EOF
sudo chmod +x "$OFFLOAD_SCRIPT"
log_ok "Создан $OFFLOAD_SCRIPT — используйте: nvidia-offload <команда>"

# ---------------------------------------------------------------------------
# 10. Env-переменные для Hyprland (wlroots + Nvidia требует явных костылей)
# ---------------------------------------------------------------------------
if [ -f "$DIR/config/nvidia-env.conf" ]; then
    mkdir -p "$HOME/.config/hypr/configs"
    cp "$DIR/config/nvidia-env.conf" "$HOME/.config/hypr/configs/nvidia-env.conf"
    log_ok "Скопирован ~/.config/hypr/configs/nvidia-env.conf"
    log_warn "Добавьте в hyprland.conf строку:  source = ~/.config/hypr/configs/nvidia-env.conf"
fi

# ---------------------------------------------------------------------------
# Итог
# ---------------------------------------------------------------------------
echo ""
log_ok "Настройка Nvidia Optimus завершена."
log_warn "ОБЯЗАТЕЛЬНО перезагрузитесь, чтобы initramfs/modeset применились."
echo ""
echo "После перезагрузки проверьте:"
echo "  nvidia-smi                          # видит ли систему карту"
echo "  cat /sys/module/nvidia_drm/parameters/modeset   # должно быть Y"
echo "  nvidia-offload glxgears             # запуск на dGPU offload'ом"
echo "  journalctl -b | grep -i nvidia       # ошибки загрузки модуля, если что-то не так"
