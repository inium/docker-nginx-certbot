#!/bin/bash

# 5. Create from http + https configuration to default.template.
cat ./conf.d/nginx/http.template ./conf.d/nginx/https.template | sudo tee ./conf.d/nginx/default.template

# 6. Restart reverse proxy container.
sudo docker-compose restart nginx-proxy