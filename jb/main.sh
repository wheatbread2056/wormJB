# note: a shell doesnt need a shebang line
VERSION="not done 0.2"

clear
cd ~/Documents/wormJB
echo "wormJB version $VERSION."
echo "wormJB is free software, if you paid for this software then you have been scammed."

sleep 1

VERFILE=~/Documents/wormjbver

if [ -f "$VERFILE" ]; then
    echo "wormJB is already installed but i dont feel like figuring out how to see if its a higher or same version, thats too much work. so its just gonna auto reinstall so you should close a-shell ASAP if you dont want it to overwrite the existing wormJB"
else
    echo "wormJB has not been installed yet. that means it's time to install"
    echo "$VERSION" > "$VERFILE"
    echo "wormJB version data put into $VERFILE."
fi

sleep 1

echo "installing neofetch (ashellfetch)"

cd tools
mkdir -p ~/Documents/bin
cp ashellfetch.sh ~/Documents/bin/neofetch
chmod +x ~/Documents/bin/neofetch

sleep 1

# set up directories
cd ~/Documents/wormJB/jb
sh pissra1n.sh

# test neofetch (remove this later)
neofetch
