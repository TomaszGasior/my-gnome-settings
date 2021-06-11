# run these commands from `machinectl shell gdm@.host /bin/sh`

gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true

echo '<fontconfig><match target="font"><edit mode="assign" name="antialias"><bool>true</bool></edit></match><match target="font"><edit mode="assign" name="rgba"><const>rgb</const></edit></match><match target="font"><edit mode="assign" name="hinting"><bool>true</bool></edit></match><match target="font"><edit mode="assign" name="hintstyle"><const>hintfull</const></edit></match></fontconfig>' \
    > $HOME/.config/fontconfig/conf.d/10-antialiasing.conf
echo '<fontconfig><match target="font"><edit mode="assign" name="lcdfilter"><const>lcddefault</const></edit></match></fontconfig>' \
    > $HOME/.config/fontconfig/conf.d/15-cleartype.conf

gsettings set org.gnome.desktop.interface cursor-theme 'DMZ-White'
