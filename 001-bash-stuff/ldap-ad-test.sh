#!/bin/bash

host=your.ldap.host.or.domain # your LDAP/AD host or domain,
                              # optionally add protocol ldap/ldaps
port=389                      # your LDAP/AD port
user="ldap_user"              # your LDAP/AD User
suffix_dn="OU=ou,DC=and,DC=ldap,DC=domain"
bind_dn="CN=${user},${suffix_dn}"
user_base_dn="OU=ou,DC=and,DC=ldap,DC=domain"

echo -e "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo -e "                   Testing LDAP/AD Authentication"
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n"
echo -e "Host \t\t\t= $host"
echo -e "Port \t\t\t= $port"
echo -e "User \t\t\t= $user"
echo -e "DN \t\t\t= $suffix_dn"
echo -e "Bind DN  \t\t= $bind_dn"
echo -e "User Tree DN \t\t= $user_base_dn"
echo -e "\n- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n"

# LDAP/AD Credentials
# Interactively input password (recommended)
read -p "LDAP Password (${user}): " -s -r passwd
# Hardcode password here (be carefull)
#passwd='YourSecretPasswordHere'

ldapsearch -x -h $host -p $port -D  $bind_dn \
-w "$passwd" -b $user_base_dn

