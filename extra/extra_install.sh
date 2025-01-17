#/bin/bash

apt install -f -y
apt install -y bash-completion
apt install -y sudo
apt install -y usbutils 
apt install -y net-tools 
apt install -y iputils-ping 
apt install -y network-manager
apt install -y vim
apt install -y gawk
apt install -y openssh-server 
apt install -y kmod
apt install -y bluez-tools 
apt install -y bluez
apt install -y locales
apt install -y curl wget
apt install -y i2c-tools 
apt install -y parted
apt install -y dosfstools 
apt install -y neofetch
apt install -y binutils
apt install -y zstd
apt install -y xz-utils

if [ -f /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf ]; then
    cp 10-globally-managed-devices.conf /usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf
fi

if [ -d /lib/firmware ]; then
    cp -a firmware-coolpi/* /lib/firmware/
    chown root:root /lib/firmware/ -R
fi

SYS_VER=`cat /etc/issue | awk '{print $1}'`
ARCH_MAC=`uname -m`
if [ "x$SYS_VER" = "xUbuntu" -a "x$ARCH_MAC" = "xaarch64" ]; then
    echo "Ubuntu OS ARM64"
    if [ -f linux-headers-5.10.110*.deb ]; then
        dpkg -i linux-headers-5.10.110*.deb
    fi

    if [ -f linux-image-5.10.110*.deb ]; then
        dpkg -i linux-image-5.10.110*.deb
    fi

    apt install -y software-properties-common

    echo -e '\n' | add-apt-repository ppa:george-coolpi/mali-g610
    echo -e '\n' | add-apt-repository ppa:george-coolpi/multimedia
    echo -e '\n' | add-apt-repository ppa:george-coolpi/rknpu

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y language-pack-en-base
    apt install -y landscape-common
    apt install -y mpv
    apt install -y qv4l2
    apt install -y camera-engine-rkaiq
    apt install -y gstreamer1.0-plugins-good
    apt install -y gstreamer1.0-plugins-bad
    apt install -y gstreamer1.0-plugins-ugly
    apt install -y gstreamer1.0-rockchip
    apt install -y rknpu2

    apt install -y iperf iperf3

    if [ -f part_resize ]; then
        cp part_resize /usr/sbin/
    fi

    if [ ! -f /etc/rc.local ]; then
        cp rc.local-ubuntu /etc/rc.local
        sudo chown root:root /etc/rc.local
        sudo systemctl enable rc-local
    fi

    apt install -y apt-transport-https ca-certificates gnupg-agent
    apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi

if [ "x$SYS_VER" = "xDebian" -a "x$ARCH_MAC" = "xaarch64" ]; then
    echo "Debian OS ARM64"
    if [ -f linux-headers-5.10.110*.deb ]; then
        ./for_debian11_10_deb.sh /root/extra/ linux-headers-5.10.110*.deb
    fi

    if [ -f linux-image-5.10.110*.deb ]; then
        ./for_debian11_10_deb.sh /root/extra/ linux-image-5.10.110*.deb
    fi
fi

if [ "x$SYS_VER" = "xopenKylin" -a "x$ARCH_MAC" = "xaarch64" ]; then
    echo "openKylin OS ARM64"
fi

if [ "x$SYS_VER" = "xUbuntu" -a "x$ARCH_MAC" = "xx86_64" ]; then
    echo "Ubuntu OS X86_64"
    #for compile u-boot
    apt install -y gcc make device-tree-compiler python2
    apt install -y git file
fi
