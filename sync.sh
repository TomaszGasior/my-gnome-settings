#!/bin/bash

if [[ $(diff gtk.css ~/.config/gtk-3.0/gtk.css) ]]; then
    gio trash ~/.config/gtk-3.0/gtk.css
    cp --verbose gtk.css ~/.config/gtk-3.0/
fi

if [[ $(diff gnome-shell.css ~/.config/gnome-shell/gnome-shell.css) ]]; then
    gio trash ~/.config/gnome-shell/gnome-shell.css
    cp --verbose gnome-shell.css ~/.config/gnome-shell/
fi