#!/bin/sh

rsync -azvh --delete /mnt/hdd1/__files/ /srv/dev-disk-by-label-hdd/contents/a3004ns_bk/;

exit 0
