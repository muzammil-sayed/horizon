The combination of Service_component, Jive_service, and Pipeline_phase must be unique!

o Pipeline_phase combined with Jive_service determine the Elasticsearch cluster name
o All three together are used by the call_ansible.sh script (https://stash.jiveland.com/projects/DE/repos/ansible-playbook-elasticsearch/browse/ansible/bin/call_ansible.sh) to discover the Elasticsearch masters for the cluster
