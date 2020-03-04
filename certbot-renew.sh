#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )

sudo docker-compose -f $SCRIPTPATH/docker-compose-certbot.yml \
                    --env-file $SCRIPTPATH/conf/.env \
                    run --rm certbot-renew

sudo docker-compose restart nginx-proxy