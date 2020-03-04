#!/bin/bash

# 1. Get dhparam.
sudo curl https://ssl-config.mozilla.org/ffdhe2048.txt > ./conf.d/nginx/dhparam.pem
# openssl dhparam -out ./conf.d/nginx/dhparam.pem 2048

# 2. Run server.
sudo docker-compose up -d

# 3. Get certificates.
sudo docker-compose -f docker-compose-certbot.yml run --rm certbot-certonly

# 4. Append https configuration to mysite.conf.template.
cat ./conf.d/nginx/https.template | sudo tee -a ./conf.d/nginx/mysite.template

# 5. Restart reverse proxy container.
sudo docker-compose restart nginx-proxy