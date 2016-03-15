#!/bin/bash

echo
echo " CONFIGUPLOAD CC.1.1.x/RM.5.1.x"

echo -e " [-] Initializing.. "
rm -Rf /tmp/configupload
mkdir /tmp/configupload > /dev/null 2>&1

echo -e "CONFIGUPLOAD\nBEGIN - "  $(date) > /tmp/configupload/runtime.txt
uname -a >> /tmp/configupload/runtime.txt
hostid >> /tmp/configupload/runtime.txt

echo -e " [-] Getting Services.."
free -m > /tmp/configupload/free.txt 2>&1
ps aux | sort -rk 3,3 > /tmp/configupload/ps.txt 2>&1
top -n 1 -b -c > /tmp/configupload/top.txt 2>&1
cp /proc/cpuinfo /tmp/configupload > /tmp/configupload/runtime.txt
echo -e "\n== SERVICES\n" >> /tmp/configupload/services.txt 2>&1
systemctl -t service -a >> /tmp/configupload/services.txt 2>&1
echo -e "\n== STATUS\n" >> /tmp/configupload/services.txt 2>&1
systemctl status >> /tmp/configupload/services.txt 2>&1
cat /etc/exports >> /tmp/configupload/services.txt 2>&1
ifconfig > /tmp/configupload/ifconfig.txt

echo -e " [-] Getting Configuration.."
cp /etc/sysconfig/docker /tmp/configupload > /tmp/configupload/runtime.txt
cp /lib/systemd/system/docker.service /tmp/configupload > /tmp/configupload/runtime.txt
cp /lib/systemd/system/nfs-server.service /tmp/configupload > /tmp/configupload/runtime.txt
rpm -qa|grep -i nfs-utils > /tmp/configupload/nfs-utils-version.txt
cp /etc/default/serviced /tmp/configupload > /tmp/configupload/runtime.txt
cp /etc/selinux/config /tmp/configupload/selinux > /tmp/configupload/runtime.txt
cp /etc/fstab /tmp/configupload > /tmp/configupload/runtime.txt
cat /etc/*release >> /tmp/configupload/release
rpm -qf /etc/redhat-release  >> /tmp/configupload/release  2>&1
cat /proc/version >> /tmp/configupload/release  2>&1
lvmdump -d /tmp/configupload/lvmdump > /tmp/configupload/runtime.txt 2>&1
cp /etc/hosts /tmp/configupload > /tmp/configupload/runtime.txt
cp /etc/yum.repos.d/docker.repo /tmp/configupload > /tmp/configupload/runtime.txt
cp /etc/group /tmp/configupload > /tmp/configupload/runtime.txt
cp /etc/passwd /tmp/configupload > /tmp/configupload/runtime.txt
cp /opt/serviced/isvcs/resources/logstash/logstash.conf /tmp/configupload > /tmp/configupload/runtime.txt
cut -d: -f 1 /etc/group >> /tmp/configupload/groups.txt
cp /etc/hostname /tmp/configupload > /tmp/configupload/runtime.txt
hostname >> /tmp/configupload/hostname
hostname -i >> /tmp/configupload/hostname
hostid >> /tmp/configupload/hostname
id -u -n >> /tmp/configupload/hostname
dmesg > /tmp/configupload/dmesg  2>&1
dmidecode > /tmp/configupload/dmidecode  2>&1
tail /var/log/messages -n 20000 > /tmp/configupload/messages
yum list installed > /tmp/configupload/installed

echo -e " [-] Getting Disk Info.."
blkid > /tmp/configupload/blkid 2>&1

echo -e "\n/var/lib/docker/devicemapper/metadata/base" >> /tmp/configupload/devicemapper-metadata 2>&1
cat /var/lib/docker/devicemapper/metadata/base >> /tmp/configupload/devicemapper-metadata
echo -e "\n/var/lib/docker/devicemapper/metadata/deviceset-metadata\n" >> /tmp/configupload/devicemapper-metadata 2>&1
cat /var/lib/docker/devicemapper/metadata/deviceset-metadata >> /tmp/configupload/devicemapper-metadata

du -shx /opt/serviced/var/isvcs/* > /tmp/configupload/isvcs.txt 2>&1
for i in $(lsblk | grep disk | echo $(awk '{print $1'})); do parted /dev/$i print free; done > /tmp/configupload/partitions.txt 2>&1
mount > /tmp/configupload/mount.txt 2>&1
echo -e "\n== BLOCK\n" >> /tmp/configupload/df.txt 2>&1
df -h >> /tmp/configupload/df.txt 2>&1
echo -e "\n== INODE\n" >> /tmp/configupload/df.txt 2>&1
df -ih >> /tmp/configupload/df.txt 2>&1
echo -e "\n== MOUNTS\n" >> /tmp/configupload/df.txt 2>&1
df -aTh >> /tmp/configupload/df.txt 2>&1
/usr/sbin/lsof +D /opt/serviced/ > /tmp/configupload/lsof.txt 2>&1
ulimit -n > /tmp/configupload/ulimit.txt 2>&1

pvs > /tmp/configupload/pvs.txt 2>&1
pvdisplay > /tmp/configupload/pvdisplay.txt 2>&1
vgs > /tmp/configupload/vgs.txt 2>&1
vgdisplay > /tmp/configupload/vgdisplay.txt 2>&1
lvs > /tmp/configupload/lvs.txt 2>&1
lvdisplay > /tmp/configupload/lvdisplay.txt 2>&1

fdisk -l > /tmp/configupload/fdisk.txt 2>&1
lsblk --output=NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT > /tmp/configupload/lsblk.txt 2>&1

echo -e " [-] Getting Docker Info.."
echo -e "\n== DOCKER VERSION\n" > /tmp/configupload/docker.txt
docker version >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER INFO\n" >> /tmp/configupload/docker.txt
docker info >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER IMAGES\n" >> /tmp/configupload/docker.txt
docker images >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER CONFIG\n" >> /tmp/configupload/docker.txt
cat /root/.docker/config.json >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER CONTAINERS\n" >> /tmp/configupload/docker.txt 2>&1
du -shx /var/lib/docker/containers/* >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER INSPECT IMAGES\n" >> /tmp/configupload/docker.txt
docker inspect $(docker images -q) >> /tmp/configupload/docker.txt 2>&1

echo -e " [-] Getting Serviced Status.."
echo -e "\n== VERSION\n" > /tmp/configupload/status.txt 2>&1
serviced version >> /tmp/configupload/status.txt 2>&1
echo -e "\n== STATUS\n" > /tmp/configupload/status.txt 2>&1
serviced service status >> /tmp/configupload/status.txt 2>&1
echo -e "\n== HEALTHCHECK\n" >> /tmp/configupload/status.txt 2>&1
serviced healthcheck >> /tmp/configupload/status.txt 2>&1
echo -e "\n== HOSTS\n" >> /tmp/configupload/status.txt 2>&1
serviced host list >> /tmp/configupload/status.txt 2>&1
echo -e "\n== POOLS\n" >> /tmp/configupload/status.txt 2>&1
serviced pool list >> /tmp/configupload/status.txt 2>&1
echo -e "\n== CONFIG\n" >> /tmp/configupload/status.txt 2>&1
serviced config >> /tmp/configupload/status.txt 2>&1
echo -e "\n== VOLUME\n" >> /tmp/configupload/status.txt 2>&1
serviced volume status >> /tmp/configupload/status.txt 2>&1
echo -e "\n== PERMISIONS\n" >> /tmp/configupload/status.txt 2>&1
find /etc /opt -name serviced -type f | xargs ls -l >> /tmp/configupload/status.txt 2>&1

echo -e " [-] Getting Docker Journal.."
journalctl -u docker --since "7 days ago" | tail -n 20000 > /tmp/configupload/docker.log 2>&1

echo -e " [-] Getting Serviced Journal.."
cat /etc/systemd/journald.conf > /tmp/configupload/serviced.log 2>&1
journalctl -u serviced --since "7 days ago" | tail -n 20000 >> /tmp/configupload/serviced.log 2>&1

echo -e " [-] Getting Firewalld Journal.."
journalctl -u firewalld --since "7 days ago" | tail -n 20000 > /tmp/configupload/firewalld.log 2>&1

echo -e " [-] Getting Zenpack List.."
timeout 60 serviced service run zope zenpack list >> /tmp/configupload/zenpacks.txt 2>&1

echo -e " [-] Getting Devices List.."
docker exec $(serviced service status | grep -i zope/0 | awk '{print $NF}') bash -c "su - zenoss -c 'zenbatchdump'" > /tmp/configupload/zenbatchdump.txt 2>&1

echo -e " [-] Getting MariaDB Info.."
echo -e "\n== PROCESSLIST\n" > /tmp/configupload/mariadb.txt
docker exec $(serviced service status | grep mariadb-model | awk '{print $NF}') bash -c "mysql -uroot -e 'SHOW FULL PROCESSLIST;'" >> /tmp/configupload/mariadb.txt 2>&1
echo -e "== DB SIZE\n" >> /tmp/configupload/mariadb.txt
docker exec $(serviced service status | grep mariadb-model | awk '{print $NF}') bash -c "mysql -uroot -e 'SELECT table_schema \"DB Name\", Round(Sum(data_length + index_length) / 1024 / 1024, 1) \"DB Size in MB\" FROM information_schema.tables GROUP BY table_schema;'" >> /tmp/configupload/mariadb.txt 2>&1

echo -e " [-] Getting RabbitMQ Info.."
echo -e "\n== rabbitmqctl list_queues -p /zenoss\n" > /tmp/configupload/rabbitmq.txt 2>&1
docker exec $(serviced service status | grep RabbitMQ | awk '{print $NF}') bash -c "rabbitmqctl list_queues -p /zenoss" >> /tmp/configupload/rabbitmq.txt 2>&1
echo -e "\n== rabbitmqctl list_queues -p /zenoss messages consumers name\n" >> /tmp/configupload/rabbitmq.txt 2>&1
docker exec $(serviced service status | grep RabbitMQ | awk '{print $NF}') bash -c "rabbitmqctl list_queues -p /zenoss messages consumers name" >> /tmp/configupload/rabbitmq.txt 2>&1
echo -e "\n== cat /opt/zenoss/etc/global.conf" >> /tmp/configupload/rabbitmq.txt 2>&1
docker exec $(serviced service status | grep RabbitMQ | awk '{print $NF}') bash -c "cat /opt/zenoss/etc/global.conf" >> /tmp/configupload/rabbitmq.txt 2>&1

echo -e " [-] Exporiting MariaDB..  (This may take several minutes)"
docker exec $(serviced service status | grep mariadb-model | awk '{print $NF}') bash -c "su - zenoss -c 'mysqldump -uroot --all-databases'" > /tmp/configupload/mysqldump.txt 2>&1

echo -e " [-] Exporitng Container Logs..  (This may take several minutes)"
serviced log export >> /tmp/configupload/runtime.txt 2>&1
mv serviced-log-export-* /tmp/configupload > /dev/null 2>&1

echo -e " [-] Running Inspector.."
curl -s https://raw.githubusercontent.com/zenoss/inspector/master/bootstrap.sh | sudo sh >> /tmp/configupload/inspector.txt 2>&1
mv inspected-*.tar.gz /tmp/configupload

echo -e "END - " $(date) >> /tmp/configupload/runtime.txt 2>&1

echo -e " [-] Creating upload file.."
tar -zcf configupload.tar.gz /tmp/configupload >> /dev/null 2>&1

echo -e " [-] Cleaning up..\n"
rm -Rf /tmp/configupload

echo -e " Please upload the following file to https://zenoss.leapfile.net/fts/drop/custom/upload/Start.jsp\n"
ls -lh $PWD/configupload.tar.gz | awk '{print " " $9 " [" $5 "]"}'
echo -e " \n Please use support@zenoss.com as the recipient email\n "

echo
