azsubscriptionid = "useyourown"

project = "mremini-workshop"
TAG     = "sdwan"
hubrglocation= "westeurope"

////////////////////Hub//////////////////
az_hubs={
  "hub1"  = { name = "hub1", cidr = "10.10.0.0/16", location="westeurope" },
}

az_hubsubnetscidrs = {
  "hub1_fgt_public"  = { name = "fgt_public", cidr = "10.10.0.0/24" , vnet= "hub1"},
  "hub1_fgt_private" = { name = "fgt_private", cidr = "10.10.1.0/24", vnet= "hub1" },
  "hub1_RouteServer"  = { name = "RouteServerSubnet", cidr = "10.10.2.0/24", vnet= "hub1" }
}

vnetroutetables = {
  "hub1_fgt_public"  = { name = "hub1_fgt-pub_rt" ,  vnet= "hub1"},
  "hub1_fgt_private" = { name = "hub1_fgt-priv_rt" , vnet= "hub1" }
}


hub1fgt1 = {
  "nic1" = { vmname = "fgt1", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.4" , vnet= "hub1" },
  "nic2" = { vmname = "fgt1", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.4", vnet= "hub1"},
}
hub1fgt2 = {
  "nic1" = { vmname = "fgt2", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.5", vnet= "hub1" },
  "nic2" = { vmname = "fgt2", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.5", vnet= "hub1"},
}

hub1fgt3 = {
  "nic1" = { vmname = "fgt3", name = "port1", subnet = "hub1_fgt_public", ip = "10.10.0.6", vnet= "hub1"},
  "nic2" = { vmname = "fgt3", name = "port2", subnet = "hub1_fgt_private", ip = "10.10.1.6", vnet= "hub1" },
}


az_ilbip = ["10.10.2.10", // Hub1 Internal LB Listner 
]
az_lbprob = "3422"

az_fgt_vmsize    = "Standard_F4s_v2"
az_FGT_IMAGE_SKU = "fortinet_fg-vm_payg_20190624"  // we should probably use Flex VM codes
az_FGT_VERSION   = "7.0.0"
az_FGT_OFFER     = "fortinet_fortigate-vm_v5"

az_fgtasn= "64622"


username = "azureadin"
password = "useyourown"

////////////////////NSG//////////////////

nsgs = {
  "pub-nsg"  = { name = "pub-nsg" , vnet="hub1"},
  "priv-nsg" = { name = "priv-nsg", vnet="hub1" }
}

nsgrules = {
  "pub-nsg-inbound"   = { nsgname = "pub-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "pub-nsg-outbound"  = { nsgname = "pub-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
  "priv-nsg-inbound"  = { nsgname = "priv-nsg", rulename = "AllInbound", priority = "100", direction = "Inbound", access = "Allow" },
  "priv-nsg-outbound" = { nsgname = "priv-nsg", rulename = "AllOutbound", priority = "100", direction = "Outbound", access = "Allow" },
}

//####################################Spoke Vnets#############################

az_spokevnet={
  "spoke11"  = { name = "spoke11", cidr = "10.11.0.0/16", location="westeurope" , peerto= "hub1"},
  "spoke12"  = { name = "spoke12", cidr = "10.12.0.0/16", location="northeurope", peerto= "hub1"}
}

az_spokevnetsubnet = {
  "spoke11_subnet" = { name = "spoke11-subnet1", cidr = "10.11.1.0/24" , vnet= "spoke11" },
  "spoke12_subnet" = { name = "spoke12-subnet1", cidr = "10.12.1.0/24",  vnet= "spoke12" }
}

az_lnx_vmsize       = "Standard_D2_v3"

//////////////////////////////////////////////////////////Branch Sites////////////////////////////////////////////////////////////////

az_branches={
  "branch1"  = { name = "branch1", cidr = "172.16.0.0/16", location="eastus2" },
  "branch2"  = { name = "branch2", cidr = "172.17.0.0/16", location="eastus2" },
  "branch3"  = { name = "branch3", cidr = "172.18.0.0/16", location="westeurope" },
}

az_branchsubnetscidrs = {
  "branch1_fgt_public"  = { name = "br1_fgt_pub", cidr = "172.16.1.0/24" , vnet= "branch1"},
  "branch1_fgt_private" = { name = "br1_fgt_priv", cidr = "172.16.2.0/24", vnet= "branch1"},
  "branch2_fgt_public"  = { name = "br2_fgt_pub", cidr = "172.17.1.0/24" , vnet= "branch2"},
  "branch2_fgt_private" = { name = "br2_fgt_priv", cidr = "172.17.2.0/24", vnet= "branch2"},
  "branch3_fgt_public"  = { name = "br3_fgt_pub", cidr = "172.18.1.0/24" , vnet= "branch3"},
  "branch3_fgt_private" = { name = "br3_fgt_priv", cidr = "172.18.2.0/24", vnet= "branch3"}
}

branch_vnetroutetables = {
  "branch1_fgt_private"  = { name = "branch1_rt" ,  vnet= "branch1"},
  "branch2_fgt_private"  = { name = "branch2_rt" ,  vnet= "branch2"},
  "branch3_fgt_private"  = { name = "branch3_rt" ,  vnet= "branch3"},
}


branch1fgt1 = {
  "nic1" = { vmname = "br1-fgt1", name = "port1", subnet = "br1_fgt_pub",  ip = "172.16.1.4" ,vnet = "branch1" },
  "nic2" = { vmname = "br1-fgt1", name = "port2", subnet = "br1_fgt_priv", ip = "172.16.2.4", vnet = "branch1"},
  "nic3" = { vmname = "br1-fgt1", name = "port3", subnet = "br1_fgt_pub", ip = "172.16.1.14", vnet = "branch1"}
}
branch1fgt2 = {
  "nic1" = { vmname = "br1-fgt2", name = "port1", subnet = "br1_fgt_pub" , ip = "172.16.1.5" ,vnet = "branch1" },
  "nic2" = { vmname = "br1-fgt2", name = "port2", subnet = "br1_fgt_priv", ip = "172.16.2.5", vnet = "branch1"},
  "nic3" = { vmname = "br1-fgt2", name = "port3", subnet = "br1_fgt_pub", ip = "172.16.1.15", vnet = "branch1"}
}

branch2fgt1 = {
  "nic1" = { vmname = "br2-fgt1", name = "port1", subnet =  "br2_fgt_pub"  , ip = "172.17.1.4", vnet = "branch2" },
  "nic2" = { vmname = "br2-fgt1", name = "port2", subnet =  "br2_fgt_priv" , ip = "172.17.2.4", vnet = "branch2"},
  "nic3" = { vmname = "br2-fgt1", name = "port3", subnet =  "br2_fgt_pub" , ip = "172.17.1.14", vnet = "branch2"}
}
branch2fgt2 = {
  "nic1" = { vmname = "br2-fgt2", name = "port1", subnet = "br2_fgt_pub" , ip = "172.17.1.5", vnet = "branch2" },
  "nic2" = { vmname = "br2-fgt2", name = "port2", subnet = "br2_fgt_priv", ip = "172.17.2.5", vnet = "branch2"},
  "nic3" = { vmname = "br2-fgt2", name = "port3", subnet = "br2_fgt_pub", ip = "172.17.1.15", vnet = "branch2"}
}
branch3fgt1 = {
  "nic1" = { vmname = "br3-fgt1", name = "port1", subnet = "br3_fgt_pub" , ip = "172.18.1.4", vnet = "branch3" },
  "nic2" = { vmname = "br3-fgt1", name = "port2", subnet = "br3_fgt_priv", ip = "172.18.2.4", vnet = "branch3"},
  "nic3" = { vmname = "br3-fgt1", name = "port3", subnet = "br3_fgt_pub", ip = "172.18.1.14", vnet = "branch3"},
}

branchpublicip = {
  "branch1-pip1"  = { name = "br1-elbpip1" ,  vnet= "branch1"},
  "branch1-pip2"  = { name = "br1-elbpip2" ,  vnet= "branch1"},  
  "branch2-pip1"  = { name = "br2-elbpip1" ,  vnet= "branch2"},
  "branch2-pip2"  = { name = "br2-elbpip2" ,  vnet= "branch2"},  
  "branch3-pip1"  = { name = "br3-pip" ,  vnet= "branch3"}
}

/*
branchlb = {
  "branch1extlb1"  = { name = "br1-elb" ,  vnet= "branch1", type="external" , probe= "8008" ,  pool= "br1-ext-fgt-ap" , frontendip = { "frontend1" = {name= frontend1, pip= "branch1-pip1"}, "frontend2" = {name= frontend2, pip= "branch1-pip2"} }, subnet= "" }
  "branch2extlb1"  = { name = "br2-elb" ,  vnet= "branch2", type="external" , probe= "8008" ,  pool= "br2-ext-fgt-ap" , frontendip = { "frontend1" = {name= frontend2, pip= "branch2-pip1"}, "frontend2" = {name= frontend2, pip= "branch2-pip2"} }, subnet= "" },
  "branch1intlb"  = { name = "br1-ilb" ,  vnet= "branch1", type="internal" , probe= "8008" ,   pool= "br1-int-fgt-ap" , frontendip = "172.16.2.10" , subnet= "branch1_fgt_private" },
  "branch2intlb"  = { name = "br2-ilb" ,  vnet= "branch2", type="internal" , probe= "8008" ,   pool= "br2-int-fgt-ap" , frontendip = "172.17.2.10" , subnet= "branch2_fgt_private" },
}
*/

intbranchlb = {
  "branch1intlb"  = { name = "br1-ilb" ,  vnet= "branch1", type="internal" , probe= "8008" ,   pool= "br1-int-fgt-ap" , frontendip = "172.16.2.10" , subnet= "branch1_fgt_private" },
  "branch2intlb"  = { name = "br2-ilb" ,  vnet= "branch2", type="internal" , probe= "8008" ,   pool= "br2-int-fgt-ap" , frontendip = "172.17.2.10" , subnet= "branch2_fgt_private" },
}

extbranchlb1 = {
  "branch1intlb"  = { name = "br1-elb" ,  vnet= "branch1", type="external" , probe= "8008" ,  pool= "br1-ext-fgt-ap" , frontendip1 = "branch1-pip1" , frontendip2 = "branch1-pip2" , subnet= "" }
}
extbranchlb2 = {
  "branch2intlb"  = { name = "br2-elb" ,  vnet= "branch2", type="external" , probe= "8008" ,  pool= "br2-ext-fgt-ap" , frontendip1 = "branch2-pip1" , frontendip2 = "branch2-pip2" , subnet= "" },
}
