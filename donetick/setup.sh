#!/bin/bash

donetick_jwt_secret=$(grep '^DONETICK_JWT_SECRET=' /opt/docker/donetick/.env | cut -d'=' -f2-)
sed -i "s|DONETICK_JWT_SECRET|$donetick_jwt_secret|g" /opt/docker/donetick/config/selfhosted.yml