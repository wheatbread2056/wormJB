#!/bin/sh
VERSION="2.0.2"
# note VERSION has to be 5 letters
echo "######################"
echo "liquidra1n version $VERSION"
echo "######################"
echo liquidra1n, by the liquidra1n team.
echo thanks to Apple, Inc. for the liqu1dass exploit

case "$1" in
    uninstall)
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
        rm -r liquidra1n
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

        echo liquidra1n is done.

        ;;
    *)
        sleep 1
        echo disabling P1SS
        sleep 1.0
        echo disabling Windows Defender
        sleep 0.9
        echo disabling MacOS defender
        sleep 0.8
        echo disabling Apple defender
        sleep 0.7
        echo disabling avast antivirus
        sleep 0.6
        echo disabling anti-jb features in ios
        sleep 0.5
        echo disabling SystemSecurityDaemon
        sleep 2.5
        echo enabling pissdaem0n
        sleep 0.8
        echo "done with all that."
        sleep 0.4

        echo "Setting up semi-rootless environment (stage 1)"
        cd ~/Documents/
        mkdir -p var
        mkdir -p usr
        mkdir -p dev
        mkdir -p cores
        mkdir -p System
        mkdir -p Library
        mkdir -p Developer
        mkdir -p Applications
        mkdir -p etc
        mkdir -p private
        mkdir -p sbin
        mkdir -p tmp

        sleep 3.1

        echo "Setting up semi-rootless environment (stage 2)"
        cd var
        mkdir -p jb
        mkdir -p liquidra1n
        mkdir -p apple
        cd apple
        mkdir -p piss

        sleep 2.17381

        echo liquidra1n is done.

        ;;
esac
