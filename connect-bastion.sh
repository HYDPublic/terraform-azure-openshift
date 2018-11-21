#!/bin/sh

set -e

cd terraform
bastion_ip=$(terraform output bastion_public_ip)
ssh -i ../certs/bastion.key cloud-user@$bastion_ip
