#! /bin/sh
# sudo mount -t cifs //192.168.0.0/hdd1 /mnt/hdd1 -o username=id,password=1234,sec=ntlmssp,vers=2.0,uid=1000,gid=1000
sudo mount -t cifs //192.168.0.0/contents /mnt/contents -o username=id,password=1234,sec=ntlmssp,vers=2.0,uid=1000,gid=1000
