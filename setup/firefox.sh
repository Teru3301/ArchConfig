#!/bin/bash

# Проверяем, запущен ли Firefox
if pgrep -x "firefox" > /dev/null; then
    echo "Firefox запущен. Закройте Firefox перед применением настроек."
    exit 1
fi

# Путь к профилю Firefox (обычно ~/.mozilla/firefox/*.default-release)
PROFILE_DIR=$(find ~/.mozilla/firefox -maxdepth 1 -type d -name '*default*' | head -n 1)

if [[ -z "$PROFILE_DIR" ]]; then
    echo "Не найден профиль Firefox!"
    exit 1
fi

# Создаём или изменяем файл user.js
USER_JS="$PROFILE_DIR/user.js"

echo "Настройка тёмной темы в $USER_JS..."

# Записываем настройки
cat > "$USER_JS" <<EOL
// Принудительно тёмная тема
user_pref("widget.content.allow-gtk-dark-theme", true);
user_pref("browser.theme.toolbar-theme", 2); // 0=системная, 1=светлая, 2=тёмная
user_pref("browser.theme.content-theme", 2);
user_pref("layout.css.prefers-color-scheme.content-override", 0); // 0=системная, 1=светлая, 2=тёмная
user_pref("ui.systemUsesDarkTheme", 1); // 1=тёмная тема
user_pref("widget.non-native-theme.gtk-theme-override", "Adwaita:dark"); // или ваша GTK-тема
EOL

echo "Готово! Запустите Firefox."
