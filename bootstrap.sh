#!/bin/bash
set -e

RHN_USER=`grep rhn_user bootstrap.tfvars|awk -F '"' '{print $2}'`
RHN_PASSWORD=`grep rhn_password bootstrap.tfvars|awk -F '"' '{print $2}'`
sed -i "s/###rhn_user###/$RHN_USER/g" terraform/provision/bastion.sh
sed -i "s/###rhn_password###/$RHN_PASSWORD/g" terraform/provision/bastion.sh

cd terraform

if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

echo "Synchronizing Terraform state..."
terraform refresh -var-file=../bootstrap.tfvars

echo "Planning Terraform changes..."
terraform plan -out openshift.plan -var-file=../bootstrap.tfvars

echo "Deploying Terraform plan..."
terraform apply openshift.plan

echo "Getting output variables..."
BASTION_IP=$(terraform output bastion_public_ip)
ROUTER_IP=$(terraform output router_public_ip)
MASTER_IP=$(terraform output console_public_ip)
MASTER_FQDN=$(terraform output console_public_fqdn)
NODE_COUNT=$(terraform output node_count)
MASTER_COUNT=$(terraform output master_count)
INFRA_COUNT=$(terraform output infra_count)
ADMIN_USER=$(terraform output admin_user)
MASTER_DOMAIN=$(terraform output master_domain)
ROUTER_DOMAIN=$(terraform output router_domain)

cd ..

chmod 600 certs/*

echo "Transfering files to bastion server..."
scp -q -o StrictHostKeychecking=no -i certs/bastion.key certs/openshift.key $ADMIN_USER@$BASTION_IP:/home/$ADMIN_USER/.ssh/id_rsa
scp -q -o StrictHostKeychecking=no -i certs/bastion.key scripts/install.sh $ADMIN_USER@$BASTION_IP:/home/$ADMIN_USER
ssh -q -t -o StrictHostKeychecking=no -i certs/bastion.key $ADMIN_USER@$BASTION_IP mkdir -p terraform-azure-openshift/certs
scp -q -o StrictHostKeychecking=no -i certs/bastion.key -r ansible/ templates/ $ADMIN_USER@$BASTION_IP:/home/$ADMIN_USER/terraform-azure-openshift
scp -q -o StrictHostKeychecking=no -i certs/bastion.key -r certs/openshift.* $ADMIN_USER@$BASTION_IP:/home/$ADMIN_USER/terraform-azure-openshift/certs

echo "Running install script..."
ssh -t -o StrictHostKeychecking=no -i certs/bastion.key $ADMIN_USER@$BASTION_IP ./install.sh $NODE_COUNT $MASTER_COUNT $INFRA_COUNT $ADMIN_USER $MASTER_DOMAIN $ROUTER_DOMAIN $MASTER_FQDN $RHN_USER $RHN_PASSWORD 

echo "-----------------------------------------"
echo "-----------------------------------------"
echo "Master Load Balancer: $MASTER_IP"
echo "Router Load Balancer: $ROUTER_IP"
echo "Console: https://$MASTER_DOMAIN:8443"
echo "Bastion: ssh -i certs/bastion.key $ADMIN_USER@$BASTION_IP"
echo "-----------------------------------------"
echo "-----------------------------------------"
