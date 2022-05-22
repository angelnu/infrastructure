#!/bin/bash -ex

err_report() {
    echo "ERROR on line $1"
}

trap 'err_report $LINENO' ERR

ping -c1 192.168.2.1

ping -c1 192.168.63.1

ping -c1 192.168.62.1

ping -c1 192.168.101.1

ping -c1 192.168.103.1

ping -c1 nas-backup.home.angelnu.com

ping -c1 192.168.105.1

ping -c1 ccu

ping -c1 ccu.lan

curl https://google.de

echo "TEST COMPLETE"