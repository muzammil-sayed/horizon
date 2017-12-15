## Kubernetes Shared Templates
*Version 4*

### Changes:
* Removed ENI from k8s master and relying on `eth0`
* EIP is now attached via `eip-attach.sh` script in `ansible-coreos`
* Now using ELB for k8s master
* k8s master is registered to ELB via `register-elb.sh` script in `ansible-coreos`
* Route53 record for the k8s master ELB in Infra Prod account
* No longer depending on `Master_ip` tag
* `{{ api_servers }}` now points to ELB DNS record
* Added `MASTER_EIP_ALLOC` and `ELB_NAME` to `cloud-config.yaml.template`
* Updated `k8s_master_instance` SG rule to allow traffic from `k8s_worker_instance`
* New k8s-worker SG ingress rules to allow nodePorts 30000 to 32767 access
