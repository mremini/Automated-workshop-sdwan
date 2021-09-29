project = "workshop"
TAG = "sdwan"

//================================================AWS================================================

aws_profile= "default"
aws_region= "us-east-2"

aws_hubsloc = [
    "us-east-2"
]
aws_hubscidr = [
    "10.20.0.0/16"
]
aws_hubssubnets_az={
"subnet1" = {name="external", az="us-east-2a", cidr="10.20.1.0/24"},
"subnet2" = {name="internal", az="us-east-2a", cidr="10.20.2.0/24"},
"subnet3" = {name="ha-mgmt",  az="us-east-2a", cidr="10.20.3.0/24"},
"subnet4" = {name="tgw",      az="us-east-2a", cidr="10.20.4.0/24"},
"subnet5" = {name="external", az="us-east-2b", cidr="10.20.5.0/24"},
"subnet6" = {name="internal", az="us-east-2b", cidr="10.20.6.0/24"},
"subnet7" = {name="ha-mgmt",  az="us-east-2b", cidr="10.20.7.0/24"},
"subnet8" = {name="tgw",      az="us-east-2b", cidr="10.20.8.0/24"}

}

///////Spokes///////

aws_spokescidr = [  
    "10.21.0.0/16", 
    "10.22.0.0/16"              
]

aws_spoke1subnets_az={
"subnet1" = {name="servers", az="us-east-2a", cidr="10.21.1.0/24"}
}

aws_spoke2subnets_az={
"subnet1" = {name="servers", az="us-east-2a", cidr="10.22.1.0/24"}
}



/*

///////Branches///////



fgt1_public_ip="10.100.0.4"
fgt1_private_ip="10.100.2.4"
fgt1_ha_ip="10.100.6.4"
fgt1_mgmt_ip="10.100.4.4"

fgt2_public_ip="10.100.1.4"
fgt2_private_ip="10.100.3.4"
fgt2_ha_ip="10.100.7.4"
fgt2_mgmt_ip="10.100.5.4"
    
fgt_mgmt_sg_ports=[
  ["22","tcp"],
  ["443","tcp"]
]

nocsoc_vpc_cidr= "10.101.0.0/16"
nocsoc_subnets_cidr=[
    "10.101.0.0/24", 
    "10.101.1.0/24"
]  

sg_cidr_private =[
    "192.168.0.0/16", 
    "10.0.0.0/8",
    "172.16.0.0/12"
]
sg_cidr_public =[
    "0.0.0.0/0"
]
sg_cidr_mgmt =[
    "0.0.0.0/0"
]                

newtgw= true
newtgwbgpasn= "64515"
existtgwid ="tgw-0aa2ffd6feebf6c69"
customergwasn ="64516"

tgw_tunnel_cidrs = [
"169.254.10.0/30",
"169.254.10.4/30"
]

tgw_tunnel_psk = [
"FortinetGov2020_99PoC",
"FortinetGov2020_98PoC"
]

use_eip=false
assign_publicip=true

byol=false
fortigate_version= "6.4.2"
fortigate_instance_type = "c5n.xlarge"


fortigate1_hostname="ftntpoc-int-fgt1"
fortigate2_hostname="ftntpoc-int-fgt2"
fgt_admin_password= "Fortinet2020!!"

ha_password="o0wdy279wmdkd7"
fgt1_ha_priority="100"
fgt2_ha_priority= "50"
fgt_ha_clustername= "ftntpoc-intvpc-cl"


fmg_version= "6.4.2"
fmg_instance_type = "m5.large"

faz_version= "6.4.2"
faz_instance_type = "m5.large"


keypair = "ftntpoc"


fmgs_ip=[
    "10.101.0.10", 
    "10.101.1.10"
    ]
fmg_sg_ports=[
  ["22","tcp"],
  ["443","tcp"],
  ["541","tcp"],
  ["8","icmp"]
]

fazs_ip=[
    "10.101.0.11", 
    "10.101.1.11"
    ]
faz_sg_ports=[
  ["22","tcp"],
  ["443","tcp"],
  ["541","tcp"],
  ["514","tcp"],
  ["514","udp"],
  ["8","icmp"]
]


*/

 
