#!/bin/bash
# Скрипт обновляет айпишники bastion в inventory из terraform output при смене ip
cd ~/diplom/terraform
BASTION_IP=$(terraform output -raw bastion_public_ip)
echo "Bastion IP: $BASTION_IP"
sed -i "s/ProxyJump=ubuntu@[0-9.]*/ProxyJump=ubuntu@${BASTION_IP}/g" ~/diplom/ansible/inventory.yml
sed -i "s/ansible_host: [0-9.]*/ansible_host: ${BASTION_IP}/g" ~/diplom/ansible/inventory.yml
echo "Inventory updated"
grep "ProxyJump\|ansible_host" ~/diplom/ansible/inventory.yml
