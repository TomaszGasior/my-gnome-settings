#!/bin/bash

heading() { echo -e "\e[1m### \e[7m$1\e[0m"; }

is_adwaita=
current_theme=`gsettings get org.gnome.desktop.interface gtk-theme`
if [[ $current_theme = "'Adwaita'" || $current_theme = "'Adwaita-dark'" ]]; then
    is_adwaita=yes
fi

cp $HOME/.config/dconf/user $HOME/.config/dconf/user.bak

heading "Shell"
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher app-icon-mode 'both'

heading "Window manager"
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Alt>'
gsettings set org.gnome.mutter center-new-windows false

heading "File manager"
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.window-state initial-size '(920, 550)'
gsettings set org.gnome.nautilus.window-state sidebar-width 160
if [[ `command -v xdg-user-dir` ]]; then
    templates_dir=`xdg-user-dir TEMPLATES`
    mkdir -p $templates_dir
    if [[ $LANG = "pl_PL.UTF-8" ]]; then
        touch $templates_dir/Nowy\ pusty\ plik
    else
        touch $templates_dir/New\ empty\ file
    fi
fi

heading "Mouse and touchpad"
gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false
gsettings set org.gnome.desktop.peripherals.mouse speed -0.4437

heading "Power and screensaver"
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

heading "Keyboard shortcuts"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['<Alt>F1']"
gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
gsettings set org.gnome.shell.keybindings open-application-menu "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys next '<Super>F12'
gsettings set org.gnome.settings-daemon.plugins.media-keys pause '<Super>F10'
gsettings set org.gnome.settings-daemon.plugins.media-keys play '<Super>F9'
gsettings set org.gnome.settings-daemon.plugins.media-keys previous '<Super>F11'
gsettings set org.gnome.settings-daemon.plugins.media-keys stop ''

heading "Custom keyboard shortcuts"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'nautilus --new-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Nautilus'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Primary><Shift>Escape'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-system-monitor --show-processes-tab'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'System Monitor'

heading "Terminal"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
gsettings set org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ bold-is-bright true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ cursor-blink-mode 'on'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ cursor-shape 'ibeam'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 100
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 30
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ scrollback-unlimited true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ scrollbar-policy 'never'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-system-font true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ word-char-exceptions "''"

heading "Text editor"
gsettings set org.gnome.gedit.preferences.editor auto-indent true
gsettings set org.gnome.gedit.preferences.editor bracket-matching true
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor display-overview-map false
gsettings set org.gnome.gedit.preferences.editor display-right-margin true
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
gsettings set org.gnome.gedit.preferences.editor scheme 'kate'
gsettings set org.gnome.gedit.preferences.editor tabs-size 4
gsettings set org.gnome.gedit.preferences.editor use-default-font true
gsettings set org.gnome.gedit.state.window size '(720, 560)'

heading "Night light and geolocation"
gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000

heading "Fonts"
if [[ "$is_adwaita" ]]; then
    ui_fonts=("Droid Sans" "Cantarell" "Ubuntu")
    for name in "${ui_fonts[@]}"; do
        if [[ $(fc-list "$name") ]]; then
            gsettings set org.gnome.desktop.interface font-name "$name 10"
            break
        fi
    done
fi
monospace_fonts=("Source Code Pro" "Consolas")
for name in "${monospace_fonts[@]}"; do
    if [[ $(fc-list "$name") ]]; then
        gsettings set org.gnome.desktop.interface monospace-font-name "$name 10"
        break
    fi
done
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'medium'

heading "Desktop background"
bg_images=(
    "/usr/share/backgrounds/gnome/Fabric.jpg"
    "/usr/share/backgrounds/fedora-workstation/dutch_skies.jpg"
)
for bg_file in "${bg_images[@]}"; do
    if [[ -f "$bg_file" ]]; then
        gsettings set org.gnome.desktop.background picture-uri "file://$bg_file"
        gsettings set org.gnome.desktop.screensaver picture-uri "file://$bg_file"
        break
    fi
done

heading "Various"
gsettings set org.gnome.desktop.a11y always-show-text-caret false
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
if [[ -d '/usr/share/icons/Vanilla-DMZ' ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Vanilla-DMZ'
fi
dconf write /org/flozz/nautilus-terminal/default-show-terminal false

heading "GTK"
gsettings set org.gtk.Settings.FileChooser date-format 'with-time'
gsettings set org.gtk.Settings.FileChooser show-size-column true
gsettings set org.gtk.Settings.FileChooser sidebar-width 160
gsettings set org.gtk.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-order 'ascending'
gsettings set org.gtk.Settings.FileChooser startup-mode 'cwd'
gsettings set org.gtk.Settings.FileChooser window-position '(0, 0)'
gsettings set org.gtk.Settings.FileChooser window-size '(750, 550)'
dconf write /org/gtk/settings/debug/enable-inspector-keybinding true
dconf write /org/gtk/settings/debug/inspector-warning false
echo "export GTK_OVERLAY_SCROLLING=0" >> "$HOME/.profile"

heading "dconf editor"
dconf write /ca/desrt/dconf-editor/behaviour "'safe'"
dconf write /ca/desrt/dconf-editor/show-warning false
dconf write /ca/desrt/dconf-editor/use-shortpaths true
dconf write /ca/desrt/dconf-editor/window-height 600
dconf write /ca/desrt/dconf-editor/window-width 800

if [[ -z "$is_adwaita" ]]; then
    heading "No Adwaita — custom stylesheets skipped"
    exit
fi

download_cmd="wget -q -O -"
if [[ `command -v curl` ]]; then
    download_cmd="curl -s"
fi

shell_extension_url="https://codeload.github.com/TomaszGasior/gnome-shell-user-stylesheet/tar.gz/master"
shell_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gnome-shell.css"
gtk_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gtk.css"

heading "GTK custom stylesheet"
mkdir -p $HOME/.config/gtk-3.0
$download_cmd $gtk_stylesheet_url >> $HOME/.config/gtk-3.0/gtk.css

heading "Shell custom stylesheet"
mkdir -p $HOME/.config/gnome-shell
$download_cmd $shell_stylesheet_url > $HOME/.config/gnome-shell/gnome-shell.css
mkdir -p $HOME/.local/share/gnome-shell/extensions
$download_cmd $shell_extension_url | tar -xzf - -C $HOME/.local/share/gnome-shell/extensions gnome-shell-user-stylesheet-master/user-stylesheet@tomaszgasior.pl/ --strip-components=1
enable_cmd="gnome-shell-extension-tool -e user-stylesheet@tomaszgasior.pl"
$enable_cmd 2> /dev/null || $enable_cmd
