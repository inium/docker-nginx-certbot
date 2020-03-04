#!/bin/bash

SCRIPTPATH=$( cd "$(dirname "$0")" ; pwd -P )

sudo docker-compose -f $SCRIPTPATH/docker-compose-certbot.yml \
                    --env-file $SCRIPTPATH/.env \
                    run --rm certbot-renew

sudo docker-compose -f $SCRIPTPATH/docker-compose.yml restart nginx-proxy