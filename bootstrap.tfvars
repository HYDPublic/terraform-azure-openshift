azure_location = "chinaeast2"
azure_resource_group_name = "azure-openshift-tf"

#Change the number of fault domain according to the region of your deployment
azure_fault_domain_count = "2"

openshift_node_count = "2"
openshift_master_count = "3"
openshift_infra_count = "2"
openshift_node_vm_size = "Standard_D2_v3"
openshift_master_vm_size = "Standard_D2_v3"
openshift_infra_vm_size = "Standard_D2_v3"
openshift_bastion_vm_size = "Standard_D2_v3"
openshift_master_domain = "openshift.ocp-tf-test.com"
openshift_router_domain = "ocp-tf-test.com"

#Azure global use RHEL
#openshift_os_image_publisher = "RedHat"
#openshift_os_image_offer = "RHEL"
#openshift_os_image_sku = "7-RAW"

#Azure China use RHEL by Yungoal
openshift_os_image_publisher = "yungoalbj"
openshift_os_image_offer = "redhat"
openshift_os_image_sku = "redhat_en-us_7_3_0"

openshift_os_image_version = "latest"
openshift_vm_admin_user = "cloud-user"

#Red Hat Network Account
rhn_user = "your-username"
rhn_password = "your-password"
