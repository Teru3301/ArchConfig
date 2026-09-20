// ===== Тёмная тема =====
user_pref("widget.content.allow-gtk-dark-theme", true);
user_pref("browser.theme.toolbar-theme", 2);          // 0=системная, 1=светлая, 2=тёмная
user_pref("browser.theme.content-theme", 2);
user_pref("layout.css.prefers-color-scheme.content-override", 0);
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("widget.non-native-theme.gtk-theme-override", "Adwaita:dark");

// ===== Фикс NVIDIA + Wayland + Hyprland =====
// Окно Firefox не появляется при аппаратном WebRender — принудительно software
user_pref("gfx.webrender.software", true);

