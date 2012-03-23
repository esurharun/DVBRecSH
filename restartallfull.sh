killall    buffer
kldunload  cxm_iic
kldunload  cxm
kldload    cxm_iic
kldload    cxm
sleep 1
/root/cleansp.sh
rm -f /var/log/log*
sleep 0.3
/usr/local/etc/rc.d/zzzchannel.sh 

