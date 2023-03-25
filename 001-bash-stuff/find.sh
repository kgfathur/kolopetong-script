#!/bin/bash

ip_is="$1"
mac_is=""
if_is=""


echo "## Ping IP Address: ${ip_is}"
ping -c3 -W3 ${ip_is}

echo -e "\n## Searching MAC (ARP): ${if_is}"
sudo arp -an | grep "${ip_is}"
mac_is=$(sudo arp -an | grep "${ip_is}" | grep -Po "([a-z0-9]{2}:){4,}[a-z0-9]{2}")
echo "Get MAC Address: ${mac_is}"

echo -e "\n## Searching Interface: ${mac_is}"
bridge fdb show | grep "${mac_is}"
if_is=$(bridge fdb show | grep "${mac_is}" | grep -Po "dev (\K\w+)(?=\s[a-zA-Z0-9])")
echo "Get Interface: ${if_is}"

#VNET="${if_is}"; for vm in $(virsh list | grep running | awk '{print $2}'); do virsh dumpxml $vm|grep -qE "$VNET" && echo $vm; done

echo -e "\n## Searching KVM Instance: (${if_is})"
VNET="${if_is}";
for vm in $(virsh list | grep running | awk '{print $2}'); do
  #echo -n "vm: ${vm}";
  virsh dumpxml $vm | grep -qE "$VNET" && echo -e "\nFound: $vm" || echo -n ".";
done
echo