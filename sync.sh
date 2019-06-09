#!/bin/bash

function sync_two_files()
{
    changes_from_first=`diff $1 $2 | grep -E "^<"`
    changes_from_second=`diff $1 $2 | grep -E "^>"`

    if [[ "$changes_from_first" && "$changes_from_second" ]]; then
        echo "BOTH CHANGED: $1 <-> $2"
    elif [[ "$changes_from_first" ]]; then
        gio trash $2
        cp --verbose $1 $2
    elif [[ "$changes_from_second" ]]; then
        gio trash $1
        cp --verbose $2 $1
    fi
}

sync_two_files ./gtk.css ~/.config/gtk-3.0/gtk.css
sync_two_files ./gnome-shell.css ~/.config/gnome-shell/gnome-shell.css
