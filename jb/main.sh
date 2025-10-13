# note: a shell doesnt need a shebang line
VERSION="not done 0.3"

clear
cd ~/Documents/wormJB
echo "wormJB version $VERSION."
echo "wormJB is free software, if you paid for this software then you have been scammed."

sleep 1

VERFILE=~/Documents/wormjbver

rm $VERFILE

# change version
if [ -f "$VERFILE" ]; then
    echo "wormJB is already installed but i dont feel like figuring out how to see if its a higher or same version, thats too much work. so its just gonna auto reinstall so you should close a-shell ASAP if you dont want it to overwrite the existing wormJB"
    echo "$VERSION" > "$VERFILE"
else
    echo "wormJB has not been installed yet. that means it's time to install"
    echo "$VERSION" > "$VERFILE"
    echo "wormJB version data put into $VERFILE."
fi

sleep 1

echo "worming it to set up the wormJB..."

# install neofetch
cd tools
mkdir -p ~/Documents/bin
cp ashellfetch.sh ~/Documents/bin/neofetch
chmod +x ~/Documents/bin/neofetch

sleep 1

# set up directories
cd ~/Documents/wormJB/jb
sh pissra1n.sh

# remove existing wormjb installed tools
cd ~/Documents/bin
rm apt
rm wormjb
rm worm

# install the tools
echo Installing wormJB tools
cp ~/Documents/wormJB/tools/apt.sh apt
chmod +x apt
cp ~/Documents/wormJB/tools/worm.sh worm
chmod +x worm
cp ~/Documents/wormJB/tools/wormjb.sh wormjb
chmod +x wormjb

# when done
neofetch
echo
echo wormJB is done installing!
echo scroll up for the neofetch
echo "--------------------------"
echo if you want to uninstall wormJB later, run: wormjb revert
cd ~/Documents
ls
