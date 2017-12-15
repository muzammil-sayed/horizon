## Kubernetes Shared Templates
*Version 9*

### Changes:
* New cloud-config.yaml.template: Using ansible-coreos image for bootstrapping
* Added COREOS_AUTHKEY, DOCKER_REGISTRY, and ANSIBLE_BUCKET to cloud_config.tf
* Removed MASTER_EIP_ALLOC and ELB_NAME from cloud_config.tf
* Added the pam_workaround.sh to cloud_config.yaml
* Removed EIP off of k8s-master
