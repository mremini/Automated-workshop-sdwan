variable "TAG" {
  description = "Customer Prefix TAG of the created ressources"
  type        = string
}

variable "project" {
  description = "project Prefix TAG of the created ressources"
  type        = string
}

variable "azsubscriptionid" {
  description = "Azure Subscription id"
}
variable "hubrglocation" {
  description = "Hub Resource Group Location"

}

//---------------Hubs -----------------

variable "az_hubs" {
  description = "List of Azure Hubs"

}
//---------------Hubs Subnets--------
variable "az_hubsubnetscidrs" {
  description = "Hub Subnets CIDRs"
}

variable "vnetroutetables" {
  description = "VNET Route Table names"
}
//---------------NSG--------
variable "nsgs" {
  description = "Network Security Groups"
}

variable "nsgrules" {
  description = "Network Security Group Rules"
}

//-------------------Hub1 NICs----------
variable "hub1fgt1" {
  description = "Azure FGT1 nics IP"

}
variable "hub1fgt2" {
  description = "Azure FGT2 nics IP"

}
variable "hub1fgt3" {
  description = "Azure FGT3 nics IP"

}

variable "az_ilbip" {
  description = "Internal LBs IP"
  type        = list(string)
}
variable "az_lbprob" {
  description = "Internal LBs Port Probing"
}
variable "az_fgtasn" {
  description = "FGT ASN"
}



//-----------------FG information ---------------
variable "az_fgt_vmsize" {
  description = "FGT VM size"
}

variable "az_lnx_vmsize" {
  description = "Linux VM size"
}

variable "az_FGT_IMAGE_SKU" {
  description = "Azure Marketplace default image sku hourly (PAYG 'fortinet_fg-vm_payg_20190624') or byol (Bring your own license 'fortinet_fg-vm')"
}
variable "az_FGT_VERSION" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
}
variable "az_FGT_OFFER" {
  description = "FortiGate version by default the 'latest' available version in the Azure Marketplace is selected"
}
//------------------------------

variable "username" {
}
variable "password" {
}


//---------------Spoke VNETs--------

variable "az_spokevnet" {
  description = "Spoke VNETs"

}
variable "az_spokevnetsubnet" {
  description = "Spokes VNETs Subnets CIDRs"

}


//---------------Branch Site VNETs--------

variable "az_branches" {
  description = "Spoke VNETs Location"

}
variable "az_branchsubnetscidrs" {
  description = "Branch Sites  CIDRs"
}

variable "branch_vnetroutetables" {
  description = "Branch Sites  CIDRs"
}

//---------------Branch FGTs-------

variable "branch1fgt1" {
  description = "Branch1 FGT1"

}
variable "branch1fgt2" {
  description = "Branch1 FGT1"

}
variable "branch2fgt1" {
  description = "Branch2 FGT1"

}
variable "branch2fgt2" {
  description = "Branch2 FGT2"

}
variable "branch3fgt1" {
  description = "Branch3 FGT1"

}

//---------------Branch LB and PIP-------
variable "branchpublicip" {
  description = "Branch PIPs"

}
variable "intbranchlb" {
  description = "INT Branch LB"

}

variable "extbranchlb1" {
  description = "EXT Branch1 LB"

}

variable "extbranchlb2" {
  description = "EXT Branch2 LB"

}