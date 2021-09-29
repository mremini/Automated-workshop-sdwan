variable "TAG" {
    description = "Customer Prefix TAG of the created ressources"
    type= string
}
variable "project" {
    description = "project Prefix TAG of the created ressources"
    type= string
}

//================================================AWS================================================

variable "aws_region" {
    description = "AWS region where infrastructure will be deployed "

}
variable "aws_profile" {
    description = "AWS region where infrastructure will be deployed "
}

//---------------Hub VPC and subnets---------------
variable "aws_hubsloc" {
    description = "AWS Hubs Location"
    type = list(string)

}
variable "aws_hubscidr" {
    description = "AWS Hubs CIDRs"
    type = list(string)

}
variable "aws_hubssubnets_az" {
    description = "AWS Hub Subnets CIDRs and AZ"
}


//---------------Spoke VPC---------------


variable "aws_spokescidr" {
    description = "AWS Spokes CIDRs"
    type = list(string)

}
variable "aws_spoke1subnets_az" {
    description = "AWS Spoke1 Subnets CIDRs and AZ"
}
variable "aws_spoke2subnets_az" {
    description = "AWS Spoke2 Subnets CIDRs and AZ"
}



//---------------Spoke VPC---------------

/*

variable "byol"{
    description = "Enter true to use BYOL image. If set to false ONDEMAND image will be used"
    default = false
    type = bool

}
variable "fortigate_version" {
    description = "FGT OS version to be deployed "

}
variable "fortigate_instance_type" {
  description = "Instance type for fortigates"
}
variable "use_eip"{
    description = "Enter true to assign eip"
    default = false
    type = bool
}
variable "assign_publicip"{
    description = "Enter true to assign public IP, either EIP or AWS Public IP, depends on variable use_eip"
    default = false
    type = bool
}
variable "keypair" {
  description = "Keypair name for instances that support keypairs"
}
//------------------------------
variable "newtgw" {
    description = "Enter true to create a New TGW otherwise enter false "
    default = false
    type = bool

}
variable "newtgwbgpasn"{
    description = "TGW AWS BGP ASN"
}
variable "existtgwid" {
    description = "Enter the ID of the TGW if you want to use an existing one otherwise leave empty "
}
variable "customergwasn"{
    description = "FGT BGP ASN"
}
variable "tgw_tunnel_cidrs" {
    description = "CIDR for the TGW inside tunnel subnets"
    type= list(string)
}
variable "tgw_tunnel_psk" {
    description = "TGW Tunnel psk"
    type= list(string)
}
//------------------------------
variable "internal_vpc_cidr" {
    description = "CIDR for the Internal VPC"
}
variable "nocsoc_vpc_cidr" {
    description = "CIDR for NOCSOC the VPC"
}
variable "external_subnets_cidr" {
    description = "CIDR for the external subnets"
    type= list(string)
}
variable "internal_subnets_cidr" {
    description = "CIDR for the Internal subnets"
    type= list(string)
}
variable "mgmt_subnets_cidr" {
    description = "CIDR for the MGMT subnets"
    type= list(string)
}
variable "ha_subnets_cidr" {
    description = "CIDR for the HA subnets"
    type= list(string)
}
variable "tgw_subnets_cidr" {
    description = "CIDR for the Internal VPC TGW Attch subnets"
    type= list(string)
}
variable "nocsoc_subnets_cidr" {
    description = "CIDR for the NOCSOC subnets"
    type= list(string)
}
//------------------------------
variable "sg_cidr_private" {
    description = "CIDR List of the  subnets to be allowed in Private Security Group"
    type= list(string)

}
variable "sg_cidr_public" {
    description = "CIDR List of the  subnets to be allowed in Public Security Group"
    type= list(string)

}
variable "sg_cidr_mgmt" {
    description = "CIDR List of the  subnets to be allowed in MGMT Security Group"
    type= list(string)

}
//------------------------------

variable "fgt1_public_ip" {
    description = "FGT1 IP Address for External ENI"
}
variable "fgt1_private_ip" {
    description = "FGT1 IP Address for Internal ENI"
}
variable "fgt1_ha_ip" {
    description = "FGT1 IP Address for HA ENI"
}
variable "fgt1_mgmt_ip"{
    description = "FGT1 IP Address for MGMT ENI"
}

variable "fgt2_public_ip" {
    description = "FGT2 IP Address for External ENI"
}
variable "fgt2_private_ip" {
    description = "FGT2 IP Address for Internal ENI"
}
variable "fgt2_ha_ip" {
    description = "FGT2 IP Address for HA ENI"
}
variable "fgt2_mgmt_ip"{
    description = "FGT2 IP Address for MGMT ENI"
}

variable "fgt_mgmt_sg_ports" {
    description = "List of ports and protocols to open for FMG"
    type= list
}

//------------------------------

variable "fortigate1_hostname" {
  description = "FortiGate1 Hostname"
}
variable "fortigate2_hostname" {
  description = "FortiGate2 Hostname"
}
variable "fgt_admin_password" {
  description = "FGT admin password"
}
//------------------------------

variable "ha_password" {
  description = "HA password"
}
variable "fgt1_ha_priority" {
  description = "FGT1 HA priority"
}
variable "fgt2_ha_priority" {
  description = "FGT1 HA priority"
}
variable "fgt_ha_clustername" {
  description = "FGT HA clustername"
}

//------------------------------
variable "fmg_version" {
    description = "FMG OS version to be deployed "

}
variable "fmg_instance_type" {
  description = "Instance type for fortigates"
}
variable "fmgs_ip" {
    description = "List of primary IP of FMGs instances"
    type= list(string)
}
variable "fmg_sg_ports" {
    description = "List of ports and protocols to open for FMG"
    type= list
}
//------------------------------
variable "faz_version" {
    description = "FMG OS version to be deployed "

}
variable "faz_instance_type" {
  description = "Instance type for fortigates"
}
variable "fazs_ip" {
    description = "List of primary IP of FAZs instances"
    type= list(string)
}
variable "faz_sg_ports" {
    description = "List of ports and protocols to open for FAZ"
    type= list
}

*/