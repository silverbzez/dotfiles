#!/usr/bin/env bash
crontab -e
curl https://get.acme.sh | sh
acme.sh --set-default-ca --server letsencrypt
acme.sh --register-account -m "" # Email
export CF_Token="" # API Token
export CF_Account_ID="" # Account ID
export CF_Zone_ID="" # Zone ID

acme.sh --issue --dns dns_cf -d diamondbz.xyz -d "*.diamondbz.xyz" --keylength ec-256
sudo install -o boom -g users -m 0755 -d /opt/ssl_diamondbz.xyz
acme.sh --install-cert -d diamondbz.xyz -d "*.diamondbz.xyz" --ecc \
  --cert-file /opt/ssl_diamondbz.xyz/diamondbz.xyz.crt \
  --key-file /opt/ssl_diamondbz.xyz/diamondbz.xyz.key \
  --fullchain-file /opt/ssl_diamondbz.xyz/diamondbz.xyz.pem \
  --reloadcmd "/usr/bin/python3.9 /home/boom/.bin/syncssl"
