#!/bin/sh
VERSION="release candidate 4"

clear
cd ~/Documents/wormJB
echo "wormJB version $VERSION."
echo "wormJB is free software, if you paid for this software then you have been scammed."

sleep 1

VERFILE=~/Documents/.wormjbver

rm -f $VERFILE
rm -f ~/Documents/wormjbver # if the old wormjbver file still exists

# change version
if [ -f "$VERFILE" ]; then
    echo "failed to wipe last version data !"
else
    echo "$VERSION" > "$VERFILE"
    echo "wormJB version data put into $VERFILE."
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

# set up directories
cd ~/Documents/wormJB/jb
sh pissra1n.sh

sleep 0.519571

# remove existing wormjb installed tools
cd ~/Documents/bin
rm -f apt
rm -f wormjb
rm -f worm

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
