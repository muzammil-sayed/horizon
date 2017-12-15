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

variable "tenancy_test_ip" {
  description = "IP address of the tenancy-test system used to store source code. Record tenancy-test.<env>.jiveprivate.com will be created using this IP address"
}

variable "tenancy_integ_ip" {
  description = "IP address of the tenancy-integ system used to store source code. Record tenancy-integ.<env>.jiveprivate.com will be created using this IP address"
}

variable "tenancy_brewprod_ip" {
  description = "IP address of the tenancy-brewprod system used to store source code. Record tenancy-brewprod.<env>.jiveprivate.com will be created using this IP address"
}

variable "tenancy_prod_ip" {
  description = "IP address of the tenancy-prod system used to store source code. Record tenancy-prod.<env>.jiveprivate.com will be created using this IP address"
}
