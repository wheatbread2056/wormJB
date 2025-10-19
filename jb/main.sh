#!/bin/sh
VERSION="1.1.0-beta1"

clear
cd ~/Documents/wormJB
echo "wormJB version $VERSION."
echo "wormJB is free software and is open source: https://github.com/wheatbread2056/wormJB"

sleep 1

rm -f ~/Documents/wormjbver # if the old wormjbver file still exists

VERFILE=~/Documents/.wormjbver
INSTALLEDVER=$(cat "$VERFILE")

# change version
if [ -f "$VERFILE" ]; then
    echo "wormJB is already installed (version $INSTALLEDVER)."
    echo "reinstalling / updating wormJB."
    echo "###############################"
    sleep 0.5
    rm -f $VERFILE
    echo "$VERSION" > "$VERFILE"
    echo "wormJB version data put into $VERFILE."
    sleep 1
    echo "finished reinitializing wormhook-loader"
    sleep 1.8
    echo "finished reinitializing wormhook"
    sleep 0.1
    echo "worming the hook"
    sleep 0.21
    echo "injecting wormstrap-$VERSION"
    sleep 0.31
    echo "successfully wormstrapped into A-Shell. ready for wormJB"
    sleep 0.1
else
    echo "$VERSION" > "$VERFILE"
    echo "wormJB version data put into $VERFILE."
    sleep 1
    echo "initializing wormhook-loader"
    sleep 2.4
    echo "finished initializing wormhook"
    sleep 0.1
    echo "worming the hook"
    sleep 0.31
    echo "injecting wormstrap-$VERSION"
    sleep 0.44
    echo "successfully wormstrapped into A-Shell. ready for wormJB"
    sleep 0.15
fi

sleep 1

echo "worming it to set up the wormJB..."

# install neofetch
cd tools
mkdir -p ~/Documents/bin
rm -f neofetch
cp ashellfetch.sh ~/Documents/bin/neofetch
chmod +x ~/Documents/bin/neofetch

sleep 1

echo installing pissra1n...
chmod +x ~/Documents/wormJB/jb/pissra1n.sh
sleep 1.111

# set up directories
cd ~/Documents/wormJB/jb
sh pissra1n.sh

sleep 0.519571

# remove existing wormjb installed tools
cd ~/Documents/bin
rm -f apt
rm -f wormjb
rm -f worm

# install hookworm
echo Installing the hookworm tweak loader
sh loader/hookworm.sh install
sleep 1.1231

# install the tools
echo Installing wormJB tools
cp ~/Documents/wormJB/tools/apt.sh apt
cp ~/Documents/wormJB/tools/worm.sh worm
cp ~/Documents/wormJB/tools/wormjb.sh wormjb

sleep 2.14

# when done
neofetch
echo
echo wormJB is done installing!
echo scroll up for the neofetch
echo "--------------------------"
echo if you want to uninstall wormJB later, run:
echo wormjb revert
cd ~/Documents
ls
