#! /bin/sh
# mount -t cifs //192.168.0.0/hdd1 /mnt/a3004ns -o username=id,password=1234,iocharset=utf8,vers=2.0,uid=1000,gid=1000
mount -t cifs //192.168.0.0/contents1 /mnt/j1900_1 -o username=id,password=1234,iocharset=utf8,vers=2.0,uid=1000,gid=1000
mount -t cifs //192.168.0.0/contents2 /mnt/j1900_2 -o username=id,password=1234,iocharset=utf8,vers=2.0,uid=1000,gid=1000
mount -t cifs //192.168.0.0/contents /mnt/pi44 -o username=id,password=1234,iocharset=utf8,vers=2.0,uid=1000,gid=1000