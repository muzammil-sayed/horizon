variable "aws_account_short_name" {
  description = "The short name for the aws account. For example if the account name was jive-aws-pipeline, then the shortname would be pipeline"
}

variable "aws_account_id" {
  description = "The account Id fo the target AWS account"
}

variable "env" {
  description = "The target environment"
}

variable "mako_env" {
  description = "The corresponding Mako environment name"

  default = {
    pipeline     = "ms-pipeline"
    pipeline-jcx = "ms-pipeline"
    prod         = "ms-prod"
  }
}

variable "region" {
  description = "The target AWS region"
}

variable "sla" {
  description = "The SLA related to the resource"
}

variable "az" {
  description = "mapping of AZ number or AWS AZ identifier. This may need to be changed in the case a region other than us-west-2 is used"

  default = {
    az1 = "a"
    az2 = "b"
    az3 = "c"
  }
}

variable "az_count" {
  description = "The number of AZ's in the given region."
}

variable "cidr" {
  description = "CIDRs assignments"

  default = {
    vpc              = ""
    natdc-subnet-1   = ""
    natdc-subnet-2   = ""
    natdc-subnet-3   = ""
    public-subnet-1  = ""
    public-subnet-2  = ""
    public-subnet-3  = ""
    private-subnet-1 = ""
    private-subnet-2 = ""
    private-subnet-3 = ""
  }
}

variable "nat_asg" {
  description = "The number of NAT ASGs to create for an environment. 1 or 3 are the only options that make sense"
}

variable "infra_vpc_id" {
  description = "VPC ID of the infra VPC that manages this VPC"
}

variable "bastion_cidr" {
  description = "CIDR block of the bastion hosts used to manage instances within this VPC, likley a /32"
}

variable "route53_zone_id" {
  description = "Global private DNS zone"
}

variable "data" {
  description = "The Data account information"

  default = {
    aws_account_id         = ""
    comp_integ_vpc_id      = ""
    comp_test_vpc_id       = ""
    comp_release_vpc_id    = ""
    comp_brewprod_vpc_id   = ""
    comp_prod_vpc_id       = ""
    comp_integ_vpc_cidr    = ""
    comp_test_vpc_cidr     = ""
    comp_release_vpc_cidr  = ""
    comp_prod_vpc_cidr     = ""
    comp_brewprod_vpc_cidr = ""
  }
}

variable "reco" {
  description = "The Reco account information"

  default = {
    aws_account_id        = ""
    comp_integ_vpc_id     = ""
    comp_test_vpc_id      = ""
    comp_release_vpc_id   = ""
    comp_prod_vpc_id      = ""
    comp_integ_vpc_cidr   = ""
    comp_test_vpc_cidr    = ""
    comp_release_vpc_cidr = ""
    comp_prod_vpc_cidr    = ""
  }
}

variable "jcx" {
  description = "The JCX account information"

  default = {
    peer_id             = ""
    comp_vpc_cidr       = ""
    ms_acc_jcx_vpc_cidr = ""
    ms_acc_jcx_peer_id  = ""
    ms_acc_ms_vpc_cidr  = ""
    ms_acc_ms_peer_id   = ""
  }
}

variable "ms" {
  description = "The MS Prod and Pipeline account information"

  default = {
    pipeline_aws_account_id     = ""
    comp_pipeline_vpc_id        = ""
    comp_pipeline_vpc_cidr      = ""
    prod_peer_id                = ""
    comp_prod_vpc_cidr          = ""
  }
}

variable "condition" {
  description = "Count for conditional creation of resources"

  default = {
    data_integ       = 0
    data_test        = 0
    data_release     = 0
    data_brewprod    = 0
    data_prod        = 0
    reco_integ       = 0
    reco_test        = 0
    reco_release     = 0
    reco_brewprod    = 0
    reco_prod        = 0
    jcx_vpc          = 0
    ms_vpc           = 0
    ms_dbaas         = 0
    ms_prod          = 0
    ms_pipeline      = 0
    data_jcx_integ   = 0
    data_jcx_test    = 0
    data_jcx_release = 0
    data_jcx_prod    = 0
    bikou_jcx        = 0
    bikou            = 0
    build_vpn        = 0
  }
}

variable "condition_corp_vpn" {
  description = "Build toggle for corp VPN"

  default = {
    build_corp_vpn   = 0
  }
}

variable "kube_extra_id" {
  description = "Extra identifier for kubernetes clusters"
}

### RDS vars for jcx ###
variable "jcx_rds_db_name" {
  description = "Database name for jcx rds instance"
}

variable "jive_service" {
  description = "Name of service"
  default     = "microservices"
}

variable "bikou" {
  description = "The Bikou account infromation"

  default = {
    aws_account_id = ""
    main_vpc_id    = ""
    main_vpc_cidr  = ""
  }
}

variable "jive_vpn_ip" {
  description = "Jive DC external gateway IP address for VPNs"
}

variable "jive_vpn_bgp_asn" {
  description = "Jive DC BGP ASN for dynamic routing, set to 65000 (or other bogus number) for static routes"
  default     = 13364
}

variable "jive_corp_vpn_ip" {
  description = "Jive Corp external gateway IP address for VPNs"
  default     = ""
}

variable "jive_corp_vpn_bgp_asn" {
  description = "Jive Corp BGP ASN for dynamic routing, set to 65000 (or other bogus number) for static routes"
  default     = 65000
}

variable "jive_corp_vpn_static_routes_only" {
  description = "Whether or not to only use static routes for Corp VPNs (set to true when BGP is not in use)"
  default     = true
}

variable "vpn_customer_gateway" {
  description = "Customer Gateway ID for shitty hacks"
  default     = ""
}

variable "extra_subnets" {
  description = "Toggle to build additional subnets"
  default     = ""
}