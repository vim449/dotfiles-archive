 local menu98edb85b00d9527ad5acebe451b3fae6 = {
     {"Archive Manager", "file-roller "},
     {"HP Device Manager", "hp-toolbox", "///usr/share/hplip/data/images/128x128/hp_logo.png" },
     {"Neovim", "xterm -e nvim ", "/usr/share/pixmaps/nvim.png" },
     {"compton", "compton", "/usr/share/icons/hicolor/48x48/apps/compton.png" },
     {"nitrogen", "nitrogen", "/usr/share/icons/hicolor/16x16/apps/nitrogen.png" },
     {"picom", "picom"},
 }

 local menude7a22a0c94aa64ba2449e520aa20c99 = {
     {"LibreOffice Math", "libreoffice --math ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-math.png" },
 }

 local menu251bd8143891238ecedc306508e29017 = {
     {"Lutris", "lutris ", "/usr/share/icons/hicolor/16x16/apps/lutris.png" },
 }

 local menud334dfcea59127bedfcdbe0a3ee7f494 = {
     {"Blender", "blender "},
     {"GNU Image Manipulation Program", "gimp-2.10 ", "/usr/share/icons/hicolor/16x16/apps/gimp.png" },
     {"LibreOffice Draw", "libreoffice --draw ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-draw.png" },
 }

 local menuc8205c7636e728d448c2774e6a4a944b = {
     {"Avahi SSH Server Browser", "/usr/bin/bssh"},
     {"Avahi VNC Server Browser", "/usr/bin/bvnc"},
     {"Brave", "brave ", "/usr/share/pixmaps/brave.png" },
     {"Remmina", "remmina-file-wrapper ", "/usr/share/icons/hicolor/16x16/apps/org.remmina.Remmina.png" },
 }

 local menudf814135652a5a308fea15bff37ea284 = {
     {"LibreOffice", "libreoffice ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-startcenter.png" },
     {"LibreOffice Base", "libreoffice --base ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-base.png" },
     {"LibreOffice Calc", "libreoffice --calc ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-calc.png" },
     {"LibreOffice Draw", "libreoffice --draw ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-draw.png" },
     {"LibreOffice Impress", "libreoffice --impress ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-impress.png" },
     {"LibreOffice Math", "libreoffice --math ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-math.png" },
     {"LibreOffice Writer", "libreoffice --writer ", "/usr/share/icons/hicolor/16x16/apps/libreoffice-writer.png" },
 }

 local menu52dd1c847264a75f400961bfb4d1c849 = {
     {"PulseAudio Volume Control", "pavucontrol"},
     {"Qt V4L2 test Utility", "qv4l2", "/usr/share/icons/hicolor/16x16/apps/qv4l2.png" },
     {"Qt V4L2 video capture utility", "qvidcap", "/usr/share/icons/hicolor/16x16/apps/qvidcap.png" },
     {"VLC media player", "/usr/bin/vlc --started-from-file ", "/usr/share/icons/hicolor/16x16/apps/vlc.png" },
 }

 local menuee69799670a33f75d45c57d1d1cd0ab3 = {
     {"Alacritty", "alacritty", "/usr/share/pixmaps/Alacritty.svg" },
     {"Avahi Zeroconf Browser", "/usr/bin/avahi-discover"},
     {"File Manager PCManFM", "pcmanfm "},
     {"Hardware Locality lstopo", "lstopo"},
     {"Htop", "xterm -e htop", "/usr/share/pixmaps/htop.png" },
     {"Manage Printing", "/usr/bin/xdg-open http://localhost:631/", "/usr/share/icons/hicolor/16x16/apps/cups.png" },
     {"OpenJDK Java 14 Console", "/usr/lib/jvm/java-14-openjdk/bin/jconsole"},
     {"OpenJDK Java 14 Shell", "xterm -e /usr/lib/jvm/java-14-openjdk/bin/jshell"},
     {"Oracle VM VirtualBox", "VirtualBox ", "/usr/share/icons/hicolor/16x16/mimetypes/virtualbox.png" },
 }

xdgmenu = {
    {"Accessories", menu98edb85b00d9527ad5acebe451b3fae6},
    {"Education", menude7a22a0c94aa64ba2449e520aa20c99},
    {"Games", menu251bd8143891238ecedc306508e29017},
    {"Graphics", menud334dfcea59127bedfcdbe0a3ee7f494},
    {"Internet", menuc8205c7636e728d448c2774e6a4a944b},
    {"Office", menudf814135652a5a308fea15bff37ea284},
    {"Sound & Video", menu52dd1c847264a75f400961bfb4d1c849},
    {"System Tools", menuee69799670a33f75d45c57d1d1cd0ab3},
}

