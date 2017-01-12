#!/bin/bash -e

HASH=`wget https://api.github.com/repos/KenT2/python-games/git/refs/heads/master -qO -| grep \"sha\" | cut -f 2 -d ':' | cut -f 2 -d \"`

if [ -f files/python_games.hash ]; then
	HASH_LOCAL=`cat files/python_games.hash`
fi

if [ ! -e files/python_games.tar.gz ] || [ "$HASH" != "$HASH_LOCAL"  ]; then
	wget "https://github.com/KenT2/python-games/tarball/master" -O files/python_games.tar.gz
	echo $HASH > files/python_games.hash
fi
wget "https://sourceforge.net/projects/webiopi/files/WebIOPi-0.7.1.tar.gz" -O files/WebIOPi-0.7.1.tar.gz

ln -sf pip3 ${ROOTFS_DIR}/usr/bin/pip-3.2

install -v -o 1000 -g 1000 -d ${ROOTFS_DIR}/home/pi/python_games
tar xvf files/python_games.tar.gz -C ${ROOTFS_DIR}/home/pi/python_games --strip-components=1
tar xvf files/WebIOPi-0.7.1.tar.gz -C ${ROOTFS_DIR}/home/pi
chown 1000:1000 ${ROOTFS_DIR}/home/pi/python_games -Rv
chown 1000:1000 ${ROOTFS_DIR}/home/pi/webiopi -Rv
chmod +x ${ROOTFS_DIR}/home/pi/python_games/launcher.sh
chmod +x ${ROOTFS_DIR}/home/pi/WebIOPi-0.7.1/setup.sh

on_chroot  sh ${ROOTFS_DIR}/home/pi/WebIOPi-0.7.1/setup.sh


install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/Documents"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/Documents/BlueJ Projects"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/Documents/Greenfoot Projects"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/Documents/Scratch Projects"
rsync -a --chown=1000:1000 ${ROOTFS_DIR}/usr/share/doc/BlueJ/ "${ROOTFS_DIR}/home/pi/Documents/BlueJ Projects"
rsync -a --chown=1000:1000 ${ROOTFS_DIR}/usr/share/doc/Greenfoot/ "${ROOTFS_DIR}/home/pi/Documents/Greenfoot Projects"
rsync -a --chown=1000:1000 ${ROOTFS_DIR}/usr/share/scratch/Projects/Demos/ "${ROOTFS_DIR}/home/pi/Documents/Scratch Projects"

#Alacarte fixes
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/applications"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.local/share/desktop-directories"
