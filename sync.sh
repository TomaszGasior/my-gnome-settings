#!/bin/bash

function sync_files() {
    if [[ `git status --short | grep $1` ]]; then
        echo $1 "modified not commited"
    elif [[ `diff $1 $2` ]]; then
        gio trash $1
        cp --verbose $2 $1
    fi
}

sync_files gtk-3.css ~/.config/gtk-3.0/gtk.css
sync_files gnome-shell.css ~/.config/gnome-shell/gnome-shell.css
