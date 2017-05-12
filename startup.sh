#!/usr/bin/env sh

PATH_TO_RESOURCES=$(pwd)/resources  # change if necessary

docker run -d --name ldap-service \
    --hostname ldap-service \
    -v $PATH_TO_RESOURCES:/resources \
    osixia/openldap:1.1.8

# phpLDAPadmin (not necessary) : Web UI for managing LDAP
docker run -d --name phpldapadmin-service \
    --hostname phpldapadmin-service \
    --link ldap-service:ldap-host \
    --env PHPLDAPADMIN_LDAP_HOSTS=ldap-host \
    osixia/phpldapadmin:0.6.12

PHPLDAP_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" phpldapadmin-service)
echo "phpLDAPadmin available at : https://$PHPLDAP_IP"
