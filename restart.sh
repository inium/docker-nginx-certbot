#!/bin/bash

# 5. Create from http + https configuration to default.template.
cat ./conf.d/nginx/http.template ./conf.d/nginx/https.template | sudo tee ./conf.d/nginx/default.template

# 3. Run Server
sudo docker-compose up -d