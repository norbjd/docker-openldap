#!/usr/bin/env sh

docker stop ldap-service
docker stop phpldapadmin-service

docker rm ldap-service
docker rm phpldapadmin-service
