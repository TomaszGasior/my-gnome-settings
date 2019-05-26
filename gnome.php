<?php

header('Content-type: application/x-shellscript; charset=UTF-8');
header('X-Robots-Tag: noindex');

echo file_get_contents('https://raw.githubusercontent.com/TomaszGasior/my-gnome-settings/master/gnome-basic-settings.sh');

