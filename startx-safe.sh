#!/bin/sh

rm -f $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/keyboard-layout.xml
(LANG=C LC_ALL=C LANGUAGE=en /usr/bin/xterm -fn 10x20 -maximized -bg black -fg green -e /bin/bash) || true
setsid sh -c "cd /proc/ ; for f in [0-9]* ; do [ \$f = \$\$ ] || kill -9 \$f ; done"

wait

