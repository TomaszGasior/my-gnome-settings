#!/bin/bash
set -euo pipefail

____() { echo -e "\e[1m### \e[7m$1\e[0m"; }
is_ubuntu_session() { [[ "${GNOME_SHELL_SESSION_MODE:-}" = "ubuntu" ]] || return 1; }
download_cmd() { ([[ `command -v curl` ]] && echo "curl -s") || echo "wget -q -O -"; }
schema_exists() { gsettings list-children $1 &> /dev/null || return 1; }

dconf_backup_file="$HOME/.config/dconf/dconf-dump-`date -Iseconds`"
dconf dump / > $dconf_backup_file
gio trash $dconf_backup_file 2> /dev/null || true


____ "Shell"

gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true || true
gsettings set org.gnome.desktop.interface enable-hot-corners true || true
gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher app-icon-mode 'both'

if is_ubuntu_session; then
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'

    gsettings set org.gnome.shell.extensions.desktop-icons show-home false || true
    gsettings set org.gnome.shell.extensions.desktop-icons show-trash false || true

    gsettings set org.gnome.shell.extensions.ding show-home false || true
    gsettings set org.gnome.shell.extensions.ding show-trash false || true
fi


____ "Window manager"

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Super>'
gsettings set org.gnome.mutter center-new-windows false


____ "File manager"

gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard' \
    || gsettings set org.gnome.nautilus.icon-view default-zoom-level 'medium'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.window-state initial-size '(1100, 650)' || true

if [[ `command -v xdg-user-dir` ]]; then
    templates_dir=`xdg-user-dir TEMPLATES`
    mkdir -p $templates_dir
    if [[ $LANG = "pl_PL.UTF-8" ]]; then
        touch $templates_dir/Nowy\ pusty\ plik
    else
        touch $templates_dir/New\ empty\ file
    fi
fi

if is_ubuntu_session; then
    echo "snap" >> $HOME/.hidden
fi


____ "Mouse and touchpad"

gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click false
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true


____ "Power and screensaver"

gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'


____ "Keyboard shortcuts"

gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"


____ "Custom keyboard shortcuts"

custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
custom_schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['$custom_path/custom0/', '$custom_path/custom1/', '$custom_path/custom2/']"

gsettings set $custom_schema:$custom_path/custom0/ binding '<Super>t'
gsettings set $custom_schema:$custom_path/custom0/ command 'gnome-terminal'
gsettings set $custom_schema:$custom_path/custom0/ name 'Terminal'

gsettings set $custom_schema:$custom_path/custom1/ binding '<Super>e'
gsettings set $custom_schema:$custom_path/custom1/ command 'nautilus --new-window'
gsettings set $custom_schema:$custom_path/custom1/ name 'Nautilus'

gsettings set $custom_schema:$custom_path/custom2/ binding '<Primary><Shift>Escape'
gsettings set $custom_schema:$custom_path/custom2/ command 'gnome-system-monitor --show-processes-tab'
gsettings set $custom_schema:$custom_path/custom2/ name 'System Monitor'

if is_ubuntu_session; then
    gsettings set org.gnome.settings-daemon.plugins.media-keys logout '[]'

    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['$custom_path/custom0/', '$custom_path/custom1/', '$custom_path/custom2/', '$custom_path/custom9/']"

    gsettings set $custom_schema:$custom_path/custom9/ binding '<Primary><Alt>Delete'
    gsettings set $custom_schema:$custom_path/custom9/ command 'gnome-session-quit --power-off'
    gsettings set $custom_schema:$custom_path/custom9/ name 'Shutdown dialog'
fi

____ "Terminal"

if schema_exists org.gnome.Terminal.Legacy.Settings; then
    gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'system'
    gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
    gsettings set org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'

    profile_schema="org.gnome.Terminal.Legacy.Profile"
    profile_path="/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/"

    gsettings set $profile_schema:$profile_path bold-is-bright true || true
    gsettings set $profile_schema:$profile_path cursor-blink-mode 'on'
    gsettings set $profile_schema:$profile_path default-size-columns 100
    gsettings set $profile_schema:$profile_path default-size-rows 30
    gsettings set $profile_schema:$profile_path scrollback-unlimited true
    gsettings set $profile_schema:$profile_path scrollbar-policy 'always'
    gsettings set $profile_schema:$profile_path use-system-font true
    gsettings set $profile_schema:$profile_path word-char-exceptions "''"

    keybindings_schema="org.gnome.Terminal.Legacy.Keybindings"
    keybindings_path="/org/gnome/terminal/legacy/keybindings/"

    gsettings set $keybindings_schema:$keybindings_path set-terminal-title '<Control><Shift>a' || true

    if is_ubuntu_session; then
        gsettings set $profile_schema:$profile_path foreground-color 'rgb(33,33,33)'
        gsettings set $profile_schema:$profile_path background-color 'rgb(247,247,247)'
        gsettings set $profile_schema:$profile_path use-theme-colors false
    fi
fi

if schema_exists org.gnome.Console; then
    gsettings set org.gnome.Console last-window-size '(802, 595)'
    gsettings set org.gnome.Console scrollback-lines 999999999999999999
    gsettings set org.gnome.Console theme 'auto'
fi


____ "Text editor"

if schema_exists org.gnome.gedit; then
    gsettings set org.gnome.gedit.preferences.editor auto-indent true
    gsettings set org.gnome.gedit.preferences.editor bracket-matching true
    gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
    gsettings set org.gnome.gedit.preferences.editor display-right-margin true
    gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
    gsettings set org.gnome.gedit.preferences.editor insert-spaces true
    gsettings set org.gnome.gedit.preferences.editor scheme 'kate'
    gsettings set org.gnome.gedit.preferences.editor tabs-size 4
    gsettings set org.gnome.gedit.preferences.editor use-default-font true
    gsettings set org.gnome.gedit.state.window size '(720, 560)'
fi

if schema_exists org.gnome.TextEditor; then
    gsettings set org.gnome.TextEditor highlight-current-line true
    gsettings set org.gnome.TextEditor indent-style 'space'
    gsettings set org.gnome.TextEditor restore-session false
    gsettings set org.gnome.TextEditor show-line-numbers true
    gsettings set org.gnome.TextEditor show-right-margin true
    gsettings set org.gnome.TextEditor spellcheck false
    gsettings set org.gnome.TextEditor tab-width 4
fi


____ "System monitor"

if schema_exists org.gnome.gnome-system-monitor; then
    gsettings set org.gnome.gnome-system-monitor window-state '(750, 650, 0, 0)'
    gsettings set org.gnome.gnome-system-monitor show-dependencies false
    gsettings set org.gnome.gnome-system-monitor show-whose-processes 'all'
    gsettings set org.gnome.gnome-system-monitor.disktreenew col-4-visible true
    gsettings set org.gnome.gnome-system-monitor.proctree sort-col 8
    gsettings set org.gnome.gnome-system-monitor.proctree sort-order 0
fi


____ "Night light and geolocation"

gsettings set org.gnome.system.location enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000


____ "Fonts"

gio trash $HOME/.config/fontconfig/conf.d 2> /dev/null || true
mkdir -p $HOME/.config/fontconfig/conf.d/

if ! is_ubuntu_session; then
    if [[ `fc-list "Cantarell"` ]]; then
        echo '<fontconfig><alias><family>sans-serif</family><prefer><family>Cantarell</family></prefer></alias></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/20-sans-cantarell.conf
        echo '<fontconfig><alias><family>-apple-system</family><prefer><family>Cantarell</family></prefer></alias></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/21-system-ui.conf
        echo '<fontconfig><match target="font"><test qual="any" name="family"><string>Cantarell</string></test><edit name="fontfeatures" mode="append"><string>tnum</string></edit></match></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/25-cantarell-tnum.conf
    fi

    if [[ `fc-list "Source Code Pro"` ]]; then
        echo '<fontconfig><alias><family>monospace</family><prefer><family>Source Code Pro</family></prefer></alias></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/20-monospace-source-code.conf

        gsettings set org.gnome.desktop.interface monospace-font-name "Source Code Pro 10"
    fi
fi

if is_ubuntu_session; then
    echo '<fontconfig><alias><family>-apple-system</family><prefer><family>Ubuntu</family></prefer></alias></fontconfig>' \
        > $HOME/.config/fontconfig/conf.d/21-system-ui.conf
fi


____ "Desktop background"

bg_images=(
    "/usr/share/backgrounds/gnome/adwaita-l.webp"
    "/usr/share/backgrounds/fedora-workstation/dutch_skies.jpg"
    "/usr/share/backgrounds/ubuntu-default-greyscale-wallpaper.png"
    "/usr/share/images/desktop-base/desktop-background"
    "/usr/share/backgrounds/gnome/Symbolics-1.jpg"
)
for bg_file in "${bg_images[@]}"; do
    if [[ -f "$bg_file" ]]; then
        gsettings set org.gnome.desktop.background picture-uri "file://$bg_file"
        gsettings set org.gnome.desktop.screensaver picture-uri "file://$bg_file"
        break
    fi
done


____ "GTK"

gsettings set org.gtk.Settings.FileChooser date-format 'with-time'
gsettings set org.gtk.Settings.FileChooser show-size-column true
gsettings set org.gtk.Settings.FileChooser sidebar-width 180
gsettings set org.gtk.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-order 'ascending'
gsettings set org.gtk.Settings.FileChooser startup-mode 'cwd'
gsettings set org.gtk.Settings.FileChooser window-position '(0, 0)'
gsettings set org.gtk.Settings.FileChooser window-size '(750, 550)'

if schema_exists org.gtk.gtk4.Settings.FileChooser; then
    gsettings set org.gtk.gtk4.Settings.FileChooser date-format 'with-time'
    gsettings set org.gtk.gtk4.Settings.FileChooser show-size-column true
    gsettings set org.gtk.gtk4.Settings.FileChooser sidebar-width 195
    gsettings set org.gtk.gtk4.Settings.FileChooser sort-column 'name'
    gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
    gsettings set org.gtk.gtk4.Settings.FileChooser sort-order 'ascending'
    gsettings set org.gtk.gtk4.Settings.FileChooser startup-mode 'cwd'
    gsettings set org.gtk.gtk4.Settings.FileChooser window-position '(0, 0)'
    gsettings set org.gtk.gtk4.Settings.FileChooser window-size '(750, 550)'
fi

____ "Various desktop settings"

gsettings set org.gnome.desktop.a11y always-show-text-caret true
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0 || true


if is_ubuntu_session; then
    exit
fi


____ "GTK custom stylesheet"

gtk3_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gtk-3.css"
gtk4_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gtk-4.css"

mkdir -p $HOME/.config/gtk-3.0
gio trash $HOME/.config/gtk-3.0/gtk.css 2> /dev/null || true
`download_cmd` $gtk3_stylesheet_url > $HOME/.config/gtk-3.0/gtk.css

mkdir -p $HOME/.config/gtk-4.0
gio trash $HOME/.config/gtk-4.0/gtk.css 2> /dev/null || true
`download_cmd` $gtk4_stylesheet_url > $HOME/.config/gtk-4.0/gtk.css


____ "Shell custom stylesheet"

shell_extension_url="https://codeload.github.com/TomaszGasior/gnome-shell-user-stylesheet/tar.gz/9b7b4904b6"
shell_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gnome-shell.css"
shell_extension_name="user-stylesheet@tomaszgasior.pl"

gio trash $HOME/.config/gnome-shell/gnome-shell.css 2> /dev/null || true
gio trash $HOME/.local/share/gnome-shell/extensions/$shell_extension_name 2> /dev/null || true
gnome-shell-extension-tool -d $shell_extension_name 2> /dev/null || true

mkdir -p $HOME/.config/gnome-shell
`download_cmd` $shell_stylesheet_url > $HOME/.config/gnome-shell/gnome-shell.css

mkdir -p $HOME/.local/share/gnome-shell/extensions/$shell_extension_name
`download_cmd` $shell_extension_url | tar --strip-components=1 -xzf - -C \
    $HOME/.local/share/gnome-shell/extensions/$shell_extension_name gnome-shell-user-stylesheet-9b7b4904b6/

gnome-shell-extension-tool -e $shell_extension_name 2> /dev/null || true

dbus-send --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval \
    string:"Main.setThemeStylesheet('$HOME/.config/gnome-shell/gnome-shell.css'); Main.loadTheme()"
