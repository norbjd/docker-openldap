# OpenLDAP on Docker

Based on [osixia:openldap](https://github.com/osixia/docker-openldap), thanks for its work.

Initialize an OpenLDAP Docker container with test data.

## LDAP STARTUP

Launch OpenLDAP container :

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

Credentials for administration (phpLDAPadmin) :

| user                       | password |
|----------------------------|----------|
| cn=admin,dc=example,dc=org | admin    |

## BASH COMMANDS

Aliases :

    # -x : simple authentication
    # -H : host
    # -w : password for simple authentication
    # -D : bind DN
    alias ldapsearch='docker exec ldap-service ldapsearch -x -H ldap://localhost -D "cn=admin,dc=example,dc=org" -w admin'
    alias ldapadd='docker exec ldap-service ldapadd -x -H ldap://localhost -D "cn=admin,dc=example,dc=org" -w admin'
    alias ldapmodify='docker exec ldap-service ldapmodify -x -H ldap://localhost -D "cn=admin,dc=example,dc=org" -w admin'

Init OpenLDAP with test data :

    ldapadd -f /resources/init.ldif

Execute `/bin/bash` in container `ldap-service` :

    docker exec -it ldap-service /bin/bash

Search in OpenLDAP :

    # -b : base DN for search
    ldapsearch -b dc=example,dc=org

## LDAP SHUTDOWN

Stop and remove containers :

    ldap stop ldap-service
    ldap stop phpldapadmin-service

    ldap rm ldap-service
    ldap rm phpldapadmin-service
