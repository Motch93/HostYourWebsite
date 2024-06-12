#!/bin/bash

echo "check nginx"
nginx -t
echo "start nginx"
nginx
if [ "$1" == "demo"  ]; then
  echo "STAGE Demo certbot generating ca - STAGING"
  certbot certonly --cert-name proxy --webroot --webroot-path=/usr/share/nginx/html/ --email testuser@testwebsite.de --non-interactive --agree-tos --no-eff-email --staging -d testwebsite.de -d www.testwebsite.de -d sub.testwebsite.de -d www.sub.testwebsite.de
  sudo sleep "$3"
elif [ "$1" == "prod"  ]; then
  echo "STAGE PROD certbot generating ca - PROD"
  certbot certonly --cert-name proxy --webroot --webroot-path=/usr/share/nginx/html/ --email testuser@testwebsite.de --non-interactive --agree-tos --no-eff-email --force-renewal  -d testwebsite.de -d www.testwebsite.de -d sub.testwebsite.de -d www.sub.testwebsite.de
  sudo sleep "$3"
elif [ "$1" == "test"  ]; then
  echo "Stage TEST - certbot generating no ca - TEST"
  tail -f /dev/null
fi