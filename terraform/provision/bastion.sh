#!/bin/bash
rhn_user=###rhn_user###
rhn_password=###rhn_password###
sudo subscription-manager register --username="${rhn_user}" --password="${rhn_password}"
sudo subscription-manager refresh
sudo subscription-manager attach --pool=`sudo subscription-manager list --available --matches '*OpenShift Container Platform'|grep 'Pool ID:'|awk '{print $3}'|head -1`
sudo subscription-manager repos --disable="*"
sudo subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.6-rpms"
#sudo yum -y install epel-release centos-release-openshift-origin
sudo yum -y update
sudo yum -y install openshift-ansible openshift-clients wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct httpd-tools vim
