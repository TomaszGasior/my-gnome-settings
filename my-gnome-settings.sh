#!/bin/bash

heading() {
    echo -e "\e[1m### \e[7m$1\e[0m";
}
set_gsetting() {
    if [[ $3 != `gsettings get "$1" "$2"` ]]; then
        gsettings set "$1" "$2" "$3"
    fi
}

cp $HOME/.config/dconf/user "$HOME/.config/dconf/dconf--user.bak.`date -Iseconds`"
gio trash "$HOME/.config/dconf/dconf--user.bak.`date -Iseconds`" 2> /dev/null

heading "Shell"
set_gsetting org.gnome.desktop.interface clock-show-date true
set_gsetting org.gnome.desktop.interface clock-show-seconds true
set_gsetting org.gnome.desktop.interface clock-show-weekday true
set_gsetting org.gnome.desktop.interface show-battery-percentage true
set_gsetting org.gnome.shell always-show-log-out true
set_gsetting org.gnome.shell.window-switcher current-workspace-only true
set_gsetting org.gnome.shell.window-switcher app-icon-mode 'both'
if [[ `gnome-shell --version  | grep -o -E '\.[0-9]+\.' | grep -o -E '[0-9]+'` -lt 32 ]]; then
    wm_buttons=`gsettings get org.gnome.desktop.wm.preferences button-layout | grep -o -E "[^']+"`
    if [[ `echo $wm_buttons | grep -v appmenu` ]]; then
        wm_buttons=appmenu,$wm_buttons
        set_gsetting org.gnome.desktop.wm.preferences button-layout "'$wm_buttons'"
    fi
    set_gsetting org.gnome.settings-daemon.plugins.xsettings overrides "{'Gtk/ShellShowsAppMenu': <0>}"
fi

heading "Window manager"
set_gsetting org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize'
set_gsetting org.gnome.desktop.wm.preferences button-layout 'appmenu:close'
set_gsetting org.gnome.desktop.wm.preferences mouse-button-modifier '<Alt>'
set_gsetting org.gnome.mutter auto-maximize false
set_gsetting org.gnome.mutter center-new-windows false

heading "File manager"
set_gsetting org.gnome.desktop.media-handling automount false
set_gsetting org.gnome.nautilus.icon-view default-zoom-level 'standard'
set_gsetting org.gnome.nautilus.list-view default-zoom-level 'small'
set_gsetting org.gnome.nautilus.list-view default-visible-columns "['name', 'size', 'type', 'date_modified']"
set_gsetting org.gnome.nautilus.list-view use-tree-view true
set_gsetting org.gnome.nautilus.preferences executable-text-activation 'ask'
set_gsetting org.gnome.nautilus.preferences show-create-link true
set_gsetting org.gnome.nautilus.window-state initial-size '(920, 550)'
set_gsetting org.gnome.nautilus.window-state sidebar-width 160
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
set_gsetting org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled true
set_gsetting org.gnome.desktop.peripherals.touchpad natural-scroll false
set_gsetting org.gnome.desktop.peripherals.touchpad tap-to-click true
set_gsetting org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled false
set_gsetting org.gnome.desktop.peripherals.mouse speed -0.4437

heading "Power and screensaver"
set_gsetting org.gnome.desktop.session idle-delay 0
set_gsetting org.gnome.settings-daemon.plugins.power idle-dim false
set_gsetting org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
set_gsetting org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
set_gsetting org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

heading "Keyboard shortcuts"
set_gsetting org.gnome.desktop.wm.keybindings begin-resize "['<Alt>F1']"
set_gsetting org.gnome.desktop.wm.keybindings maximize "[]"
set_gsetting org.gnome.desktop.wm.keybindings panel-main-menu "[]"
set_gsetting org.gnome.desktop.wm.keybindings switch-applications "['<Super>Tab']"
set_gsetting org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Super>Tab']"
set_gsetting org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
set_gsetting org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
set_gsetting org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>Up']"
set_gsetting org.gnome.shell.keybindings open-application-menu "[]"
set_gsetting org.gnome.settings-daemon.plugins.media-keys next '<Super>F12'
set_gsetting org.gnome.settings-daemon.plugins.media-keys pause '<Super>F10'
set_gsetting org.gnome.settings-daemon.plugins.media-keys play '<Super>F9'
set_gsetting org.gnome.settings-daemon.plugins.media-keys previous '<Super>F11'
set_gsetting org.gnome.settings-daemon.plugins.media-keys stop ''

heading "Custom keyboard shortcuts"
set_gsetting org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>t'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>e'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'nautilus --new-window'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Nautilus'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Primary><Shift>Escape'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-system-monitor --show-processes-tab'
set_gsetting org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'System Monitor'

heading "Terminal"
set_gsetting org.gnome.Terminal.Legacy.Settings default-show-menubar false
set_gsetting org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
set_gsetting org.gnome.Terminal.ProfilesList list "['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']"
set_gsetting org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ bold-is-bright true
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ cursor-blink-mode 'on'
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ cursor-shape 'ibeam'
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-columns 100
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ default-size-rows 30
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ scrollback-unlimited true
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ scrollbar-policy 'never'
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-system-font true
set_gsetting org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ word-char-exceptions "''"

heading "Text editor"
set_gsetting org.gnome.gedit.preferences.editor auto-indent true
set_gsetting org.gnome.gedit.preferences.editor bracket-matching true
set_gsetting org.gnome.gedit.preferences.editor display-line-numbers true
set_gsetting org.gnome.gedit.preferences.editor display-overview-map false
set_gsetting org.gnome.gedit.preferences.editor display-right-margin true
set_gsetting org.gnome.gedit.preferences.editor highlight-current-line true
set_gsetting org.gnome.gedit.preferences.editor insert-spaces true
set_gsetting org.gnome.gedit.preferences.editor scheme 'kate'
set_gsetting org.gnome.gedit.preferences.editor tabs-size 4
set_gsetting org.gnome.gedit.preferences.editor use-default-font true
set_gsetting org.gnome.gedit.state.window size '(720, 560)'

heading "Night light and geolocation"
set_gsetting org.gnome.system.location enabled true
set_gsetting org.gnome.settings-daemon.plugins.color night-light-enabled true
set_gsetting org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
set_gsetting org.gnome.settings-daemon.plugins.color night-light-temperature 4000

heading "Fonts"
ui_fonts=("Cantarell" "Droid Sans" "Ubuntu")
monospace_fonts=("Source Code Pro" "Consolas")
if [[ "$GNOME_SHELL_SESSION_MODE" != "ubuntu" ]]; then
    for name in "${ui_fonts[@]}"; do
        if [[ `fc-list "$name"` ]]; then
            set_gsetting org.gnome.desktop.interface font-name "$name 10"
            set_gsetting org.gnome.desktop.interface document-font-name "$name 11"
            break
        fi
    done
fi
for name in "${monospace_fonts[@]}"; do
    if [[ `fc-list "$name"` ]]; then
        set_gsetting org.gnome.desktop.interface monospace-font-name "$name 10"
        break
    fi
done
set_gsetting org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
set_gsetting org.gnome.settings-daemon.plugins.xsettings hinting 'slight'

heading "Desktop background"
bg_images=(
    "/usr/share/backgrounds/gnome/Fabric.jpg"
    "/usr/share/backgrounds/fedora-workstation/dutch_skies.jpg"
)
for bg_file in "${bg_images[@]}"; do
    if [[ -f "$bg_file" ]]; then
        set_gsetting org.gnome.desktop.background picture-uri "file://$bg_file"
        set_gsetting org.gnome.desktop.screensaver picture-uri "file://$bg_file"
        break
    fi
done

heading "GTK"
set_gsetting org.gtk.Settings.FileChooser date-format 'with-time'
set_gsetting org.gtk.Settings.FileChooser show-size-column true
set_gsetting org.gtk.Settings.FileChooser sidebar-width 160
set_gsetting org.gtk.Settings.FileChooser sort-column 'name'
set_gsetting org.gtk.Settings.FileChooser sort-directories-first true
set_gsetting org.gtk.Settings.FileChooser sort-order 'ascending'
set_gsetting org.gtk.Settings.FileChooser startup-mode 'cwd'
set_gsetting org.gtk.Settings.FileChooser window-position '(0, 0)'
set_gsetting org.gtk.Settings.FileChooser window-size '(750, 550)'
dconf write /org/gtk/settings/debug/enable-inspector-keybinding true
dconf write /org/gtk/settings/debug/inspector-warning false
if [[ -z `cat .profile 2> /dev/null | grep GTK_OVERLAY_SCROLLING` ]]; then
    echo "export GTK_OVERLAY_SCROLLING=0" >> "$HOME/.profile"
    if [[ `command -v systemctl` ]]; then
        systemctl --user set-environment GTK_OVERLAY_SCROLLING=0
    fi
fi

heading "Various"
set_gsetting org.gnome.desktop.a11y always-show-text-caret false
set_gsetting org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
if [[ -d '/usr/share/icons/Vanilla-DMZ' ]]; then
    set_gsetting org.gnome.desktop.interface cursor-theme 'Vanilla-DMZ'
elif [[ -d '/usr/share/icons/DMZ-White' ]]; then
    set_gsetting org.gnome.desktop.interface cursor-theme 'DMZ-White'
elif [[ -d '/usr/share/icons/dmz' ]]; then
    set_gsetting org.gnome.desktop.interface cursor-theme 'dmz'
fi
dconf write /ca/desrt/dconf-editor/behaviour "'safe'"
dconf write /ca/desrt/dconf-editor/show-warning false
dconf write /ca/desrt/dconf-editor/use-shortpaths true
dconf write /ca/desrt/dconf-editor/window-height 600
dconf write /ca/desrt/dconf-editor/window-width 800
if [[ `gsettings writable org.flozz.nautilus-terminal default-show-terminal 2> /dev/null` ]]; then
    set_gsetting org.flozz.nautilus-terminal custom-command '/bin/bash'
    set_gsetting org.flozz.nautilus-terminal default-show-terminal false
    set_gsetting org.flozz.nautilus-terminal min-terminal-height 6
    set_gsetting org.flozz.nautilus-terminal use-custom-command true
fi

if [[ "$GNOME_SHELL_SESSION_MODE" = "ubuntu" ]]; then
    heading "Ubuntu detected — custom stylesheets skipped"
    exit
fi

if [[ `command -v curl` ]]; then
    download_cmd="curl -s"
else
    download_cmd="wget -q -O -"
fi

shell_extension_url="https://codeload.github.com/TomaszGasior/gnome-shell-user-stylesheet/tar.gz/master"
shell_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gnome-shell.css"
gtk_stylesheet_url="https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gtk.css"

heading "GTK custom stylesheet"
mkdir -p $HOME/.config/gtk-3.0
gio trash $HOME/.config/gtk-3.0/gtk.css 2> /dev/null
$download_cmd $gtk_stylesheet_url > $HOME/.config/gtk-3.0/gtk.css

heading "Shell custom stylesheet"
mkdir -p $HOME/.config/gnome-shell
gio trash $HOME/.config/gnome-shell/gnome-shell.css 2> /dev/null
$download_cmd $shell_stylesheet_url > $HOME/.config/gnome-shell/gnome-shell.css
mkdir -p $HOME/.local/share/gnome-shell/extensions
gio trash $HOME/.local/share/gnome-shell/extensions/user-stylesheet@tomaszgasior.pl 2> /dev/null && gnome-shell-extension-tool -d user-stylesheet@tomaszgasior.pl 2> /dev/null
$download_cmd $shell_extension_url | tar --strip-components=1 -xzf - -C $HOME/.local/share/gnome-shell/extensions gnome-shell-user-stylesheet-master/user-stylesheet@tomaszgasior.pl/
result=`gnome-shell-extension-tool -e user-stylesheet@tomaszgasior.pl 2>&1`
if [[ $? != 0 ]]; then echo $result; fi
