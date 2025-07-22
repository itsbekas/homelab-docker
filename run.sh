#!/bin/bash

./setup.sh
cd /opt/docker
docker compose pull
docker compose up -d --build
cd -
