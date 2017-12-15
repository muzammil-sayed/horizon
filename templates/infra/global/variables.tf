variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The account Id fo the target AWS account"
}

variable "governor_account_arn" {
  description = "The ARN of the governor account for cross account roles"
}

variable "env" {
  description = "The target environment"
}

variable "region" {
  description = "The target AWS region"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "private_domain" {
  description = "Domain for Jive instances"
}

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "ldap_ip" {
  description = "IP address of the LDAP system used for authentication. Record ldap.<env>.jiveprivate.com will be created using this IP address"
}

variable "ldap_phx_ip" {
  description = "IP address of the LDAP system used for authentication. Record ldap.<env>.jiveprivate.com will be created using this IP address"
}

variable "ldap_ams_ip" {
  description = "IP address of the LDAP system used for authentication. Record ldap.<env>.jiveprivate.com will be created using this IP address"
}

variable "nexus_ip" {
  description = "IP address of the nexus system used to get artifacts to SW deploys. Record nexus.<env>.jiveprivate.com will be created using this IP address"
}

variable "stash_ip" {
  description = "IP address of the stash system used to store source code. Record stash.<env>.jiveprivate.com will be created using this IP address"
}

variable "jive_phx_ip" {
  description = "Public IP address of outbound PHX traffic."
}

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
  default     = ""
}

variable "mako_services_route53_zone" {
  description = "Subdomains for MAKO services"
}

variable "condition_route53" {
  description = "Count for conditional creation of resources"

  default = {
    mako_services = 0
  }
}
