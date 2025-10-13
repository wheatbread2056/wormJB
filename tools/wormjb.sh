#!/bin/sh
wormjb_version=$(cat ~/Documents/.wormjbver 2>/dev/null)

case "$1" in
  credits)
    echo "wormJB version $wormjb_version"
    echo "made by: wheatbread2056"
    echo "pissra1n 2 by the pissra1n team"
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
    echo "######################"
    echo "pissra1n version 2.0.0"
    echo "######################"
    echo
    echo pissra1n, by the pissra1n team.
    echo thanks to Apple, Inc. for the liqu1dass exploit
    echo
    echo STARTING REVERT PROCESS!!!
    echo
    sleep 1
    echo enabling P1SS
    sleep 1.0
    echo enabling Windows Defender
    sleep 0.9
    echo enabling MacOS defender
    sleep 0.8
    echo enabling Apple defender
    sleep 0.7
    echo enabling avast antivirus
    sleep 0.6
    echo enabling anti-jb features in ios
    sleep 0.5
    echo enabling SystemSecurityDaemon
    sleep 2.5
    echo disabling pissdaem0n
    sleep 0.8
    echo "done with all that."
    sleep 0.4

    echo "Removing semi-rootless environment (stage 2)"
    cd ~/Documents/
    cd var
    rm -r jb
    rm -r pissra1n
    rm -r apple

    sleep 3.1

    echo "Removing semi-rootless environment (stage 1)"

    cd ~/Documents/
    rm -r var
    rm -r usr
    rm -r dev
    rm -r cores
    rm -r System
    rm -r Library
    rm -r Developer
    rm -r Applications
    rm -r etc
    rm -r private
    rm -r sbin
    rm -r tmp

    sleep 2.17381

    echo pissra1n is done.

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
