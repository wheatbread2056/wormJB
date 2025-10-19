#!/bin/sh
wormjb_version=$(cat ~/Documents/.wormjbver 2>/dev/null)

case "$1" in
  credits)
    echo "wormJB version $wormjb_version"
    echo "made by: wheatbread2056"
    echo "pissra1n 2 by the pissra1n team (wheatbread2056)"
    echo "pissra1n 2 is NOT associated with pissra1n by bomberfish."
    echo "liqu1dass by Apple, Inc."
    echo "ashellfetch originally by GrandDiJay"
    echo "wormJB github: https://github.com/wheatbread2056/wormJB"
    echo "ashellfetch github: https://github.com/GrandDiJay/aShellFetch"
    ;;
  help)
    echo "credits: show credits"
    echo "help: show help"
    echo "cydia: install Cydia Gold Edition (CLI, ported to Semi-Rootless)"
    echo "revert: revert all wormJB changes and uninstall wormJB."
    echo "(note that revert doesn't uninstall git)"
    ;;
  cydia)
    echo "Installing Cydia Gold Edition..."
    sleep 5
    echo "failed: couldn't find cydiagold-semirootless-0.1.15.wormjbextension2"
    ;;
  revert)
    ~/Documents/wormJB/jb/pissra1n.sh uninstall

    sleep 0.5

    echo "[wormJB] uninstalling wormJB tools"
    # remove wormjb tools
    cd ~/Documents/bin
    rm apt
    rm worm
    rm wormjb
    rm neofetch

    sleep 0.8

    echo "[wormJB] uninstalling wormJB"
    cd ~/Documents
    rm -rf wormJB
    echo "done uninstalling."

    ;;
  *)
    echo "use it like: wormjb {credits|help|cydia|revert}"
    exit 1
    ;;
esac
