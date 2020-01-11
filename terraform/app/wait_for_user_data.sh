#!/bin/bash

# ssh uses exit status 255 to mean can't connect
ex=255
while [ $ex -eq 255 ]; do
  sleep 10
  ssh -i ../../rea -o StrictHostKeyChecking=no ec2-user@${1} -- \
    'timeout 360 sed -u /finished-user-data/q <(tail -n 1000 -f /var/log/cloud-init-output.log)'
  ex=$?
done
exit $ex

echo $1
