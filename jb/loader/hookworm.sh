#!/bin/sh
# hookworm the tweak loader
VERSION="0.0.1"
INSTALLDIR="$HOME/Documents/wormJB/hookworm"
install() {
    echo "[hookworm] installing hookworm $VERSION"
    echo "[hookworm] setting up"
    mkdir -p "$INSTALLDIR/modules"
    cd $INSTALLDIR
    cp ~/Documents/wormJB/jb/loader/hookworm.sh hookworm
    chmod +x hookworm
    for f in "$HOME/Documents/wormJB/jb/loader/modules/"*.sh; do
        base=$(basename "$f" .sh)
        cp "$f" "$INSTALLDIR/modules/$base"
        chmod +x "$INSTALLDIR/modules/$base"
    done
}
hookworm() {
    echo working
}
case "$1" in
    install)
        install
        ;;
    hookworm)
        hookworm
        ;;
esac
