WARNING: THIS DOCUMENT IS SLIGHTLY OUT-OF-DATE

The combination of service_component, jive_subservice, and pipeline_phase must be unique!

o Pipeline_phase combined with jive_subservice determine the Elasticsearch cluster name
o All three together are used by the call_ansible.sh script (https://stash.jiveland.com/projects/DE/repos/ansible-playbook-elasticsearch/browse/ansible/bin/call_ansible.sh) to discover the Elasticsearch masters for the cluster
