#!/bin/bash

# 1. Get dhparam.
sudo openssl dhparam -out ./conf.d/nginx/dhparam.pem 2048
# sudo curl https://ssl-config.mozilla.org/ffdhe2048.txt | sudo tee ./conf.d/nginx/dhparam.pem

# 2. Create http configuration to default.template
cat ./conf.d/nginx/http.template | sudo tee ./conf.d/nginx/default.template

# 3. Run Server
sudo docker-compose up -d

# 4. Get certificates.
sudo docker-compose -f docker-compose-certbot.yml run --rm certbot-certonly

# 5. Create from http + https configuration to default.template.
cat ./conf.d/nginx/http.template ./conf.d/nginx/https.template | sudo tee ./conf.d/nginx/default.template

# 6. Restart reverse proxy container.
sudo docker-compose restart nginx-proxy
