/etc/init.d/ntp stop;
/usr/sbin/ntpdate ntp.sjtu.edu.cn 0.asia.pool.ntp.org 1.asia.pool.ntp.org 2.asia.pool.ntp.org 3.asia.pool.ntp.org
/etc/init.d/ntp start;
hwclock --systohc
