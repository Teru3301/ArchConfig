#!/bin/bash
# DNS через systemd-resolved (1.1.1.1 / 8.8.8.8) + интеграция с NetworkManager.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -f "$DIR/../../lib/common.sh" ]; then
    # shellcheck source=/dev/null
    source "$DIR/../../lib/common.sh"
else
    log_info()  { echo -e "\033[1;34m[i]\033[0m $*"; }
    log_ok()    { echo -e "\033[1;32m[✓]\033[0m $*"; }
    log_warn()  { echo -e "\033[1;33m[!]\033[0m $*"; }
    log_err()   { echo -e "\033[1;31m[x]\033[0m $*" >&2; }
fi

# ---------------------------------------------------------------------------
# 1. /etc/systemd/resolved.conf.d/dns_servers.conf
# ---------------------------------------------------------------------------
RESOLVED_DIR=/etc/systemd/resolved.conf.d
RESOLVED_CONF="$RESOLVED_DIR/dns_servers.conf"
RESOLVED_CONTENT='[Resolve]
DNS=1.1.1.1 8.8.8.8
Domains=~.'

sudo mkdir -p "$RESOLVED_DIR"

if [ ! -f "$RESOLVED_CONF" ] || ! diff -q <(echo "$RESOLVED_CONTENT") "$RESOLVED_CONF" &>/dev/null; then
    echo "$RESOLVED_CONTENT" | sudo tee "$RESOLVED_CONF" > /dev/null
    log_ok "$RESOLVED_CONF записан"
    RESOLVED_CHANGED=true
else
    log_ok "$RESOLVED_CONF уже настроен"
    RESOLVED_CHANGED=false
fi

# ---------------------------------------------------------------------------
# 2. /etc/resolv.conf -> симлинк на stub-resolv.conf от systemd-resolved
# ---------------------------------------------------------------------------
STUB_TARGET=/run/systemd/resolve/stub-resolv.conf

current_target=""
if [ -L /etc/resolv.conf ]; then
    current_target="$(readlink -f /etc/resolv.conf 2>/dev/null || true)"
fi

if [ "$current_target" != "$(readlink -f "$STUB_TARGET" 2>/dev/null || echo "$STUB_TARGET")" ]; then
    if [ -e /etc/resolv.conf ] && [ ! -L /etc/resolv.conf ]; then
        backup="/etc/resolv.conf.bak.$(date +%s)"
        sudo cp /etc/resolv.conf "$backup"
        log_warn "Старый /etc/resolv.conf (не симлинк) сохранён в $backup"
    fi
    sudo ln -sf "$STUB_TARGET" /etc/resolv.conf
    log_ok "/etc/resolv.conf -> $STUB_TARGET"
else
    log_ok "/etc/resolv.conf уже указывает на stub-resolv.conf"
fi

# ---------------------------------------------------------------------------
# 3. Включаем systemd-resolved
# ---------------------------------------------------------------------------
sudo systemctl enable systemd-resolved &>/dev/null || true
if [ "$RESOLVED_CHANGED" = true ] || ! systemctl is-active --quiet systemd-resolved; then
    sudo systemctl restart systemd-resolved
    log_ok "systemd-resolved перезапущен"
else
    log_ok "systemd-resolved уже активен, перезапуск не требуется"
fi

# ---------------------------------------------------------------------------
# 4. NetworkManager: dns=systemd-resolved
# ---------------------------------------------------------------------------
if ! command -v nmcli &>/dev/null && ! systemctl list-unit-files NetworkManager.service &>/dev/null; then
    log_warn "NetworkManager не найден в системе — пропускаю интеграцию с ним." \
             "Если у вас другой сетевой менеджер (iwd/dhcpcd/systemd-networkd)," \
             "настройте DNS для него отдельно."
else
    NM_CONF_DIR=/etc/NetworkManager/conf.d
    NM_CONF="$NM_CONF_DIR/dns.conf"
    NM_CONTENT='[main]
dns=systemd-resolved'

    sudo mkdir -p "$NM_CONF_DIR"

    if [ ! -f "$NM_CONF" ] || ! diff -q <(echo "$NM_CONTENT") "$NM_CONF" &>/dev/null; then
        echo "$NM_CONTENT" | sudo tee "$NM_CONF" > /dev/null
        log_ok "$NM_CONF записан"
        if systemctl is-active --quiet NetworkManager; then
            sudo systemctl restart NetworkManager
            log_ok "NetworkManager перезапущен"
        fi
    else
        log_ok "$NM_CONF уже настроен"
    fi
fi

log_ok "DNS настроен: 1.1.1.1, 8.8.8.8 через systemd-resolved"
echo "Проверить: resolvectl status  /  resolvectl query example.com"
