#!/bin/bash

echo 
echo " CONFIGUPLOAD "
echo 
echo "" > configupload.txt

echo -e " [-] Initializing.. "
rm -Rf /tmp/configupload
mkdir /tmp/configupload > /dev/null 2>&1

echo -e " [-] Getting Services.."
free -m > /tmp/configupload/free.txt 2>&1
ps auxc | sort -rk 3,3 > /tmp/configupload/ps.txt 2>&1
top -n 1 > /tmp/configupload/top.txt 2>&1
systemctl -t service -a > /tmp/configupload/services.txt 2>&1
ifconfig > /tmp/configupload/ifconfig.txt

echo -e " [-] Getting Config Files.."
cp /etc/sysconfig/docker /tmp/configupload
cp /lib/systemd/system/docker.service /tmp/configupload
cp /etc/default/serviced /tmp/configupload
cp /etc/selinux/config /tmp/configupload/selinux
cp /etc/fstab /tmp/configupload
cp /var/log/messages /tmp/configupload
cp /etc/redhat-release /tmp/configupload

echo -e " [-] Getting Disk Info.."
du -shx /opt/serviced/var/isvcs/* > /tmp/configupload/isvcs.txt 2>&1
df -h > /tmp/configupload/df.txt 2>&1
fdisk -l > /tmp/configupload/fdisk.txt 2>&1
lsblk > /tmp/configupload/lsblk.txt 2>&1
btrfs filesystem show /opt/serviced/var/volumes >> /tmp/configupload/btrfs.txt 2>&1
btrfs filesystem df  /opt/serviced/var/volumes > /tmp/configupload/btrfs.txt 2>&1

echo -e " [-] Getting Docker Info.."
echo -e "\n== DOCKER VERSION\n" > /tmp/configupload/docker.txt
docker version >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER INFO\n" >> /tmp/configupload/docker.txt
docker info >> /tmp/configupload/docker.txt 2>&1
echo -e "\n== DOCKER IMAGES\n" >> /tmp/configupload/docker.txt
docker images >> /tmp/configupload/docker.txt 2>&1

echo -e " [-] Getting Serviced Status.."
echo -e "\n== STATUS\n" > /tmp/configupload/status.txt 2>&1
serviced service status >> /tmp/configupload/status.txt 2>&1
echo -e "\n== HEALTHCHECK\n" >> /tmp/configupload/status.txt 2>&1
serviced healthcheck >> /tmp/configupload/status.txt 2>&1
echo -e "\n== HOSTS\n" >> /tmp/configupload/status.txt 2>&1
serviced host list status >> /tmp/configupload/status.txt 2>&1
echo -e "\n== POOLS\n" >> /tmp/configupload/status.txt 2>&1
serviced pool list status >> /tmp/configupload/status.txt 2>&1

echo -e " [-] Getting Serviced Journal.."
journalctl -u serviced > /tmp/configupload/serviced.log 2>&1

echo -e " [-] Getting Firewalld Journal.."
journalctl -u firewalld > /tmp/configupload/firewalld.log 2>&1

echo -e " [-] Getting Zenpacks.."
serviced service run zope zenpack list >> /tmp/configupload/zenpacks.txt 2>&1

echo -e " [-] Getting RabbitMQ Queues.."
docker exec $(serviced service status | grep RabbitMQ | awk '{print $7}') bash -c "rabbitmqctl list_queues -p /zenoss" > /tmp/configupload/rabbitmq.txt 2>&1

echo -e " [-] Getting MariaDB Info.."
echo -e "\n== PROCESSLIST\n" > /tmp/configupload/mariadb.txt
docker exec $(serviced service status | grep mariadb-model | awk '{print $7}') bash -c "mysql -uroot -e 'SHOW FULL PROCESSLIST;'" >> /tmp/configupload/mariadb.txt 2>&1
echo -e "== DB SIZE\n" >> /tmp/configupload/mariadb.txt
docker exec $(serviced service status | grep mariadb-model | awk '{print $7}') bash -c "mysql -uroot -e 'SELECT table_schema \"DB Name\", Round(Sum(data_length + index_length) / 1024 / 1024, 1) \"DB Size in MB\" FROM information_schema.tables GROUP BY table_schema;'" >> /tmp/configupload/mariadb.txt 2>&1

echo -e " [-] Exporitng Container Logs.."
serviced log export > /dev/null 2>&1
mv serviced-log-export-* /tmp/configupload

echo -e " [-] Creating upload file.."
tar -zcf configupload.tar.gz /tmp/configupload > /dev/null 2>&1

echo -e " [-] Cleaning up..\n"
# rm -Rf /tmp/configupload

echo -e " Please upload the following file to https://zenoss.leapfile.net/fts/drop/custom/Index.jsp\n "
ls -lh $PWD/configupload.tar.gz | awk '{print " " $9 " [" $5 "]"}'
echo 



