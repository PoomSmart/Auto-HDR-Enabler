Auto HDR Enabler
==========

Enable Auto HDR mode (that capable with iPhone 5s) for non-capable iDevices running iOS 7.1 only.

Currently unusable for iPad because of UI.

How to install `Auto HDR Enabler`
 
wget --no-check-certificate https://github.com/PoomSmart/Auto-HDR-Enabler/archive/master.tar.gz
tar xpvf master
dpkg -i ./Auto-HDR-Enabler-master/org.thebigboss.autohdrenabler_1.0-1_iphoneos-arm.deb
rm -rf master Auto-HDR-Enabler-master
killall -9 SpringBoard
