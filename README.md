[![Build Status](https://travis-ci.org/pdtechvn/jf4418_buildroot_ext.svg?branch=master)](https://travis-ci.org/pdtechvn/jf4418_buildroot_ext)

##Buildroot External Files For JF4418##
   
   Using u-boot branch 2015.11.x   
    
##Prerequisite Build Envrionment##

   Host PC Ubuntu 12.04 64-bit or higher
   
   Install the bellow software packages :
   
   $ sudo apt-get install git-core gnupg flex bison gperf build-essential
     zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev
     libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386
     libgl1-mesa-dev g++-multilib mingw32 openjdk-6-jdk tofrodos
     python-markdown libxml2-utils xsltproc zlib1g-dev:i386
     minicom tftpd uboot-mkimage expect libgl1-mesa-dri

##Build Steps##

   $ mkdir jf4418_buildroot
   
   $ cd jf4418_buildroot
   
   $ git clone https://github.com/pdtechvn/jf4418_buildroot_ext.git
   
   $ git clone git://git.buildroot.net/buildroot
   
   $ cd buildroot
   
   $ git checkout 2015.11.x
   
   $ make BR2_EXTERNAL=../jf4418_buildroot_ext jf4418_defconfig    
   
   $ make menuconfig
   
   Navigate the menu and select more software packages if you need to add them into root file system.
   
   $ make 

##Options##

   jf4418_gui_defconfig - For a Qt based application launcher and environment.

   jf4418_defconfig     - For JF4418 Basic configuration.

##Known Issues##

   Using buildroot gcc toolschain can build u-boot successfully, but it doesn't work. 
   
   Work around, using external toolschain to buil u-boot, run build_uboot.sh to build u-boot again.

   To bring up bluetooth after boot Linux run the following command :
   
   $ hciconfig hci0 up
   
##Copy Images into uSD card##

   $ cd output/deploy
   
   We need to build u-boot by using external toolschain :
   
   $ sudo ./build_uboot.sh
   
   Insert uSD card into PC, we'll have device name for example /dev/sdx (x should be b,c, or d...)
   
   $ sudo ./fusing.sh /dev/sdx
   
##Booting Linux##

   Insert uSD into uSD card socket of JF4418, after power on, the board run u-boot with console promt is s5p4418#
   
   Before booting Linux we set up u-boot environtment variables as bellow commands (set only onetime at fist booting Linux) :
   
   s5p4418# setenv bootcmd 'fatload mmc 0:1 0x48000000 uImage; bootm 0x48000000'
   
   s5p4418# setenv bootargs 'console=ttyAMA0,115200n8 root=/dev/mmcblk0p2 rootfstype=ext4 rootwait init=/sbin/init systemd.show_status=false g_ether.host_addr=82:cf:ce:fa:44:18 lcd=HDMI720P60'
   
   s5p4418# save

   Then we can reset the board by the following command :

   s5p4418# reset
   
##Login User Account##

   Welcome to Buildroot

   buildroot login: root
   
   user : root

   pass : no password

   If use SSH console, we need to add password for user account.
   
##Configure WIFI##

   To config WIFI connection, we follow below steps :

   Create WIFI pass phase :

   $ wpa_passphrase ssid

   For example :

   $ wpa_passphrase myssid
   
   $ reading passphrase from stdin
   
   $ mypassword
   
   We have result :
   
   network={
   
        ssid="myssid"
        
        #psk="mypassword"
        
        psk=2f0568b3492812bd56b946dbaf3fd7dd669b9a4602a09aa6462ff057949b025c
        
   }

   Edit file wpa_supplicant.conf as bellow command :
   
   $ vi /etc/wpa_supplicant.conf
   
   Add above network setting into wpa_supplicant.conf, the file containt should be
   
   ctrl_interface=/var/run/wpa_supplicant
   
   ap_scan=1

   network={
   
        ssid="myssid"
        
        #psk="mypassword"
        
        psk=2f0568b3492812bd56b946dbaf3fd7dd669b9a4602a09aa6462ff057949b025c
        
   }

   Restart Linux in oder start WIFI network.

   $ reboot

## Configure ALSA Sound ##

   Create a new ASLA configuration file as the following command :
   
   $ vi $HOME/.asoundrc
   
   Edit as the bellow containt :
   
   pcm.!default {

       type plug

       slave.pcm {

          type dmix

          ipc_key 1024

          slave {

            pcm "hw:0,0"

            rate 44100
            
          }
          
       }
       
   }   
   
   By this way, the default sound card should be ALC5623 intead of HDMI SPDIF


   