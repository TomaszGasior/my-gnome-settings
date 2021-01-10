#!/bin/bash
set -euo pipefail

____() { echo -e "\e[1m### \e[7m$1\e[0m"; }
is_ubuntu_session() { [[ "${GNOME_SHELL_SESSION_MODE:-}" = "ubuntu" ]] || return 1; }
download_cmd() { ([[ `command -v curl` ]] && echo "curl -s") || echo "wget -q -O -"; }

dconf_backup_file="$HOME/.config/dconf/dconf-dump-`date -Iseconds`"
dconf dump / > $dconf_backup_file
gio trash $dconf_backup_file 2> /dev/null || true


____ "Shell"

gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true || true
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners true || true
gsettings set org.gnome.shell always-show-log-out true
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop', 'org.gnome.gedit.desktop', 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.shell.window-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher app-icon-mode 'both'

if is_ubuntu_session; then
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DEFAULT'

    gsettings set org.gnome.shell.extensions.desktop-icons show-home false || true
    gsettings set org.gnome.shell.extensions.desktop-icons show-trash false || true
fi


____ "Window manager"

gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Super>'
gsettings set org.gnome.mutter auto-maximize false
gsettings set org.gnome.mutter center-new-windows false


____ "File manager"

gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
gsettings set org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"
gsettings set org.gnome.nautilus.list-view use-tree-view true
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.window-state initial-size '(990, 550)' || true
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

if is_ubuntu_session; then
    echo "snap" >> $HOME/.hidden
fi


____ "Mouse and touchpad"

gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
gsettings set org.gnome.desktop.peripherals.mouse speed -0.4437


____ "Power and screensaver"

gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'


____ "Keyboard shortcuts"

gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Primary><Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Primary><Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings panel-main-menu "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Primary><Super>F11']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
gsettings set org.gnome.shell.keybindings open-application-menu "[]"
gsettings set org.gnome.settings-daemon.plugins.media-keys next "['<Super>F12']"
gsettings set org.gnome.settings-daemon.plugins.media-keys pause '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys play "['<Super>F9']"
gsettings set org.gnome.settings-daemon.plugins.media-keys previous "['<Super>F11']"
gsettings set org.gnome.settings-daemon.plugins.media-keys stop "['<Super>F10']"


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

gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
gsettings set org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
gsettings set org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'

profile_schema="org.gnome.Terminal.Legacy.Profile"
profile_path="/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/"

gsettings set $profile_schema:$profile_path bold-is-bright true || true
gsettings set $profile_schema:$profile_path cursor-blink-mode 'on'
gsettings set $profile_schema:$profile_path cursor-shape 'ibeam'
gsettings set $profile_schema:$profile_path default-size-columns 100
gsettings set $profile_schema:$profile_path default-size-rows 30
gsettings set $profile_schema:$profile_path scrollback-unlimited true
gsettings set $profile_schema:$profile_path scrollbar-policy 'never'
gsettings set $profile_schema:$profile_path use-system-font true
gsettings set $profile_schema:$profile_path word-char-exceptions "''"

if is_ubuntu_session; then
    gsettings set $profile_schema:$profile_path background-color 'rgb(33,33,33)'
    gsettings set $profile_schema:$profile_path foreground-color 'rgb(247,247,247)'
    gsettings set $profile_schema:$profile_path use-theme-colors false
fi


____ "Text editor"

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


____ "System monitor"

if [[ `command -v gnome-system-monitor` != '/snap/bin/gnome-system-monitor' ]]; then
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

echo '<fontconfig><match target="font"><edit mode="assign" name="antialias"><bool>true</bool></edit></match><match target="font"><edit mode="assign" name="rgba"><const>rgb</const></edit></match><match target="font"><edit mode="assign" name="hinting"><bool>true</bool></edit></match><match target="font"><edit mode="assign" name="hintstyle"><const>hintfull</const></edit></match></fontconfig>' \
    > $HOME/.config/fontconfig/conf.d/10-antialiasing.conf
echo '<fontconfig><match target="font"><edit mode="assign" name="lcdfilter"><const>lcddefault</const></edit></match></fontconfig>' \
    > $HOME/.config/fontconfig/conf.d/15-cleartype.conf

if ! is_ubuntu_session; then
    if [[ `fc-list "Cantarell"` ]]; then
        echo '<fontconfig><alias><family>sans-serif</family><prefer><family>Cantarell</family></prefer></alias></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/20-sans-cantarell.conf
        echo '<fontconfig><alias><family>-apple-system</family><prefer><family>Cantarell</family></prefer></alias></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/21-system-ui.conf
        echo '<fontconfig><match target="font"><test qual="any" name="family"><string>Cantarell</string></test><edit name="fontfeatures" mode="append"><string>tnum</string></edit></match></fontconfig>' \
            > $HOME/.config/fontconfig/conf.d/25-cantarell-tnum.conf

        gsettings set org.gnome.desktop.interface font-name "Cantarell 10"
        gsettings set org.gnome.desktop.interface document-font-name "Cantarell 11"
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
    "/usr/share/backgrounds/f31/default/standard/f31.png"
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
gsettings set org.gtk.Settings.FileChooser sidebar-width 160
gsettings set org.gtk.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-order 'ascending'
gsettings set org.gtk.Settings.FileChooser startup-mode 'cwd'
gsettings set org.gtk.Settings.FileChooser window-position '(0, 0)'
gsettings set org.gtk.Settings.FileChooser window-size '(750, 550)'

dconf write /org/gtk/settings/debug/inspector-warning false


____ "Various desktop settings"

gsettings set org.gnome.desktop.a11y always-show-text-caret true
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0

if [[ -d '/usr/share/icons/Vanilla-DMZ' ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'Vanilla-DMZ'
elif [[ -d '/usr/share/icons/DMZ-White' ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
elif [[ -d '/usr/share/icons/dmz' ]]; then
    gsettings set org.gnome.desktop.interface cursor-theme 'dmz'
fi


____ "Optional applications"

dconf write /ca/desrt/dconf-editor/behaviour "'safe'"
dconf write /ca/desrt/dconf-editor/show-warning false
dconf write /ca/desrt/dconf-editor/use-shortpaths true
dconf write /ca/desrt/dconf-editor/window-height 600
dconf write /ca/desrt/dconf-editor/window-width 800

dconf write /org/gnome/gitg/preferences/commit/diff/context-lines 6
dconf write /org/gnome/gitg/preferences/commit/message/enable-spell-checking true
dconf write /org/gnome/gitg/preferences/commit/message/spell-checking-language "'en_US'"
dconf write /org/gnome/gitg/preferences/interface/orientation "'horizontal'"
dconf write /org/gnome/gitg/preferences/interface/style-scheme "'kate'"

dconf write /org/flozz/nautilus-terminal/custom-command "'/bin/bash'"
dconf write /org/flozz/nautilus-terminal/default-show-terminal false
dconf write /org/flozz/nautilus-terminal/min-terminal-height 6
dconf write /org/flozz/nautilus-terminal/use-custom-command true


if is_ubuntu_session; then
    exit
fi


____ "Sounds"

gio trash $HOME/.local/share/sounds/__custom 2> /dev/null || true
mkdir -p $HOME/.local/share/sounds/__custom

echo -e "[Sound Theme]\nName=N\nInherits=freedesktop\nDirectories=." > $HOME/.local/share/sounds/__custom/index.theme
ln -s /usr/share/sounds/gnome/default/alerts/sonar.ogg $HOME/.local/share/sounds/__custom/bell-terminal.ogg || true
ln -s /usr/share/sounds/gnome/default/alerts/sonar.ogg $HOME/.local/share/sounds/__custom/bell-window-system.ogg || true

gsettings set org.gnome.desktop.sound event-sounds true
gsettings set org.gnome.desktop.sound input-feedback-sounds true
gsettings set org.gnome.desktop.sound theme-name '__custom'


____ "GTK custom stylesheet"

gtk_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gtk.css"

mkdir -p $HOME/.config/gtk-3.0
gio trash $HOME/.config/gtk-3.0/gtk.css 2> /dev/null || true
`download_cmd` $gtk_stylesheet_url > $HOME/.config/gtk-3.0/gtk.css


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
dbus-send --type=method_call --dest=org.gnome.Shell /org/gnome/Shell org.gnome.Shell.Eval \
    string:"global.stage.get_child_at_index(0).set_style('font-size: 10pt')"
