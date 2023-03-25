#!/bin/bash

echo "# WARNING!!!"
echo "# This is a collection of random bash script with no correlation"
echo "# and NOT intended to be executed as all-in-one script."
echo "# exit!"
exit 1

# ######### BASH
### Cleanup (kill) orphaned ssh session
### Watch you user session
w
### insert 'TTY' of the orphan session here:
USER_TTY="pts/4"
echo "Thic proccess will be killed:"
ps -ef | grep ${USER_TTY} | head -n1
ps -ef | grep ${USER_TTY} | head -n1 | awk '{print $2}' | xargs kill -15


# ######### OPENSTACK
### reference: https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/13/html-single/undercloud_and_control_plane_back_up_and_restore/index
## OPENSTACK DEPLOYMENT OPS

### show baremetal node ALL
openstack baremetal node list -f value -c UUID | xargs -I {} openstack baremetal node show {} -f json >> baremetal-node-show-all.json
### delete baremetal node ALL
openstack baremetal node list -c UUID -f value | xargs -I {} openstack baremetal node delete {}

## OPENSTACK HEALTHCHECK
openstack stack failures list $STACKNAME
openstack stack list --nested | grep -v "_COMPLETE"

openstack network agent list
openstack flavor list -f csv

## OPENSTACK CEPH HEALTHCHECK
sudo podman exec -it ${CEPH_HOST} /bin/bash
ceph status
ceph osd df
ceph mon stat
ceph osd pool autoscale-status
ceph osd pool ls detail

## CHECK WEB/HTTP - CURL
SERVER="127.0.0.1"
while 1;
do
echo -e "\n# $(date +'%F %T')";
curl ${SERVER};
sleep 0.5;
done

# ######### NETWORKING
INTERFACE="eth0"
tcpdump -nn -v -i ${INTERFACES} -s 1500 -c 1 'ether[20:2] == 0x2000'