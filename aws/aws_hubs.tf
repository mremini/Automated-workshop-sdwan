
//############################ Hub VPC and IGW creation ############################

resource "aws_vpc" "aws_hub_vpc" {
  count = length(var.aws_hubscidr)
  cidr_block           = var.aws_hubscidr[count.index]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.TAG}-${var.project}-hub"
  }
}
resource "aws_internet_gateway" "aws_hub_vpc_igw" {
  count = length(var.aws_hubsloc)
  vpc_id            = element(aws_vpc.aws_hub_vpc.*.id , count.index) 
  tags = {
    Name = "${var.TAG}-${var.project}-hub_igw"
  }
}

/*
module "internalvpc_ec2_endpoint" {
  source = "./modules/vpc_endpoints/ec2"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "Internal-vpc"
  vpc_id= aws_vpc.internal_vpc.id
  sg_id= module.fgt_private_sg.id
  subnet_id= [
   aws_subnet.external_subnet.0.id,
   aws_subnet.external_subnet.1.id
  
  ]
}
*/

//############################ Hub Subnets and RTB ############################ 

resource "aws_subnet" "aws_hub_subnet_ext" {
  for_each = { for k, v in var.aws_hubssubnets_az : k=>v  if contains(["external"], v.name)  }
  vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)  // This code is not very clean

  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-hub-${each.value.name}-${each.value.az}"
  }
}

resource "aws_subnet" "aws_hub_subnet_int" {
  for_each = { for k, v in var.aws_hubssubnets_az : k=>v  if contains(["internal"], v.name)  }
  vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)  // This code is not very clean

  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-hub-${each.value.name}-${each.value.az}"
  }
}

resource "aws_subnet" "aws_hub_subnet_mgmt-ha" {
  for_each = { for k, v in var.aws_hubssubnets_az : k=>v  if contains(["ha-mgmt"], v.name)  }
  vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)  // This code is not very clean

  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-hub-${each.value.name}-${each.value.az}"
  }
}

resource "aws_subnet" "aws_hub_subnet_tgw" {
  for_each = { for k, v in var.aws_hubssubnets_az : k=>v  if contains(["tgw"], v.name)  }
  vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)  // This code is not very clean
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-hub-${each.value.name}-${each.value.az}"
  }
}

//-------------------------------Public RTB--------------------------
resource "aws_route_table" "public_rtb" {
count = length(var.aws_hubscidr)
vpc_id = element(aws_vpc.aws_hub_vpc.*.id , count.index)

  tags = {
    Name = "${var.TAG}-${var.project}-hub-public_rtb"
  }
}
resource "aws_route" "public_default" {
  count = length(var.aws_hubscidr)
route_table_id              = element(aws_route_table.public_rtb.*.id , count.index)
destination_cidr_block = "0.0.0.0/0"
gateway_id             = element(aws_internet_gateway.aws_hub_vpc_igw.*.id , count.index)

}

resource "aws_route_table_association" "public_rtb_assoc" {
  for_each = aws_subnet.aws_hub_subnet_ext
  subnet_id     = each.value.id
  route_table_id = element(aws_route_table.public_rtb.*.id , 0)
}



/*
data "aws_subnet_ids" "aws_hub_ext_subnet" {
    vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)
    tags = {
    Name = "*external*"
    }
    depends_on=[
    aws_subnet.aws_hub_subnet
    ]  
}
*/




//-------------------------------Private RTB--------------------------
resource "aws_route_table" "private_rtb" {
  count = length(var.aws_hubscidr)
vpc_id = element(aws_vpc.aws_hub_vpc.*.id , count.index)

  tags = {
    Name = "${var.TAG}-${var.project}-hub-private_rtb"
  }
}
resource "aws_route" "private_default" {
  count = length(var.aws_hubscidr)
route_table_id              = element(aws_route_table.private_rtb.*.id , count.index)
destination_cidr_block = "10.0.0.0/8"
transit_gateway_id     =  aws_ec2_transit_gateway.tgw.id

  depends_on=[
    aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch 
    ]
}

/*
data "aws_subnet_ids" "aws_hub_int_subnetid" {
    vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)
  tags = {
    Name = "*internal*"
  }
}
*/


resource "aws_route_table_association" "private_rtb_assoc" {
 for_each = aws_subnet.aws_hub_subnet_int
  subnet_id     = each.value.id
  route_table_id = element(aws_route_table.private_rtb.*.id , 0)

}

//-------------------------------Mgmt-HA RTB------------------
resource "aws_route_table" "hamgmt_rtb" {
count = length(var.aws_hubscidr)
vpc_id = element(aws_vpc.aws_hub_vpc.*.id , count.index)

  tags = {
    Name = "${var.TAG}-${var.project}-hub-ha-mgmt_rtb"
  }
}
resource "aws_route" "ha-mgmt_default" { 
count = length(var.aws_hubscidr)
route_table_id              = element(aws_route_table.hamgmt_rtb.*.id , count.index)
destination_cidr_block = "0.0.0.0/0"
gateway_id             = element(aws_internet_gateway.aws_hub_vpc_igw.*.id , count.index)

}
/*
data "aws_subnet_ids" "aws_hub_hamgmt_subnetid" {
    vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)
    tags = {
    Name = "*ha-mgmt*"
    }
}
*/


resource "aws_route_table_association" "hamgmt_rtb_assoc" {
 for_each = aws_subnet.aws_hub_subnet_mgmt-ha
  subnet_id     = each.value.id
  route_table_id = element(aws_route_table.hamgmt_rtb.*.id , 0)

}







/*

//############################ HA Subnets and RTB ############################

resource "aws_subnet" "ha_subnet" {
  count = length(var.ha_subnets_cidr)
  cidr_block        = var.ha_subnets_cidr[count.index]
  vpc_id            = aws_vpc.internal_vpc.id
  availability_zone = var.AZs[count.index]
  tags = {
    Name = "${var.TAG}-${var.project}-ha_subnet_${count.index+1}"
  }
}
//-------------------------------RTB--------------------------
resource "aws_route_table" "ha_rtb" {
vpc_id = aws_vpc.internal_vpc.id

  tags = {
    Name = "${var.TAG}-${var.project}-ha_rtb"
  }
}

resource "aws_route_table_association" "ha_rtb_assoc" {
  count = length(var.ha_subnets_cidr)
  subnet_id      =element(aws_subnet.ha_subnet.*.id , count.index)
  route_table_id = aws_route_table.ha_rtb.id
}

*/


//############################ TGW and Attachments ############################







//--------FGT RTB , Associations and Propagations-----



/*

//############################ Security group ############################

//------------------------Private SG-------------
module "fgt_private_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "private-SG"
  vpc_id= aws_vpc.internal_vpc.id
   
}
resource "aws_security_group_rule" "private_sg_rule_ingress" {
  type= "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.sg_cidr_private
  security_group_id= module.fgt_private_sg.id
}
resource "aws_security_group_rule" "private_sg_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.fgt_private_sg.id
}
//------------------------Public SG-------------
module "fgt_public_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "public-SG"
  vpc_id= aws_vpc.internal_vpc.id
   
}
resource "aws_security_group_rule" "public_sg_rule_ingress" {
  type= "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = var.sg_cidr_public
  security_group_id= module.fgt_public_sg.id
}
resource "aws_security_group_rule" "public_sg_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.fgt_public_sg.id
}

//------------------------HA SG-------------

module "fgt_ha_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "ha-SG"
  vpc_id= aws_vpc.internal_vpc.id
   
}
resource "aws_security_group_rule" "ha_rule_ingress" {
  type= "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [aws_vpc.internal_vpc.cidr_block]
  security_group_id= module.fgt_ha_sg.id
}
resource "aws_security_group_rule" "ha_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.fgt_ha_sg.id
}

//------------------------MGMT SG-------------

module "fgt_mgmt_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "MGMT-SG"
  vpc_id= aws_vpc.internal_vpc.id
   
}
resource "aws_security_group_rule" "fgtmgmt_sg_rule_ingress" {
  count= length(var.fgt_mgmt_sg_ports)
  type= "ingress"
  from_port   = element(var.fgt_mgmt_sg_ports[count.index],0)
  to_port     = element(var.fgt_mgmt_sg_ports[count.index],0)
  protocol    = element(var.fgt_mgmt_sg_ports[count.index],1)
  cidr_blocks = var.sg_cidr_mgmt
  security_group_id= module.fgt_mgmt_sg.id
  
}
resource "aws_security_group_rule" "fgtmgmt_sg_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.fgt_mgmt_sg.id
}

//------------------------FMG SG-------------
module "fmg_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FMG-SG"
  vpc_id= aws_vpc.nocsoc_vpc.id
   
}
resource "aws_security_group_rule" "fmg_sg_rules" {
  count = length(var.fmg_sg_ports)
  type= "ingress"
  from_port   = element(var.fmg_sg_ports[count.index],0)
  to_port     = element(var.fmg_sg_ports[count.index],0)
  protocol    = element(var.fmg_sg_ports[count.index],1)
  cidr_blocks = var.sg_cidr_private
  security_group_id= module.fmg_sg.id
}

resource "aws_security_group_rule" "fmg_sg_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.fmg_sg.id
}


//------------------------FAZ SG-------------

module "faz_sg" {
  source = "./modules/security_group"
  aws_region = var.aws_region
  aws_profile= var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FAZ-SG"
  vpc_id= aws_vpc.nocsoc_vpc.id   
}

resource "aws_security_group_rule" "faz_sg_rules" {
  count = length(var.faz_sg_ports)
  type= "ingress"
  from_port   = element(var.faz_sg_ports[count.index],0)
  to_port     = element(var.faz_sg_ports[count.index],0)
  protocol    = element(var.faz_sg_ports[count.index],1)
  cidr_blocks = var.sg_cidr_private
  security_group_id= module.faz_sg.id
}
resource "aws_security_group_rule" "faz_sg_rule_egress" {
  type= "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id= module.faz_sg.id
}
//############################ FGT INSTANCES ############################


//-------------------- GET AMI ID --------------------
data "aws_ami" "fgt_ami_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiGate-VM64-AWS *${var.fortigate_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

data "aws_ami" "fgt_ami_ondemand" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiGate-VM64-AWSONDEMAND *${var.fortigate_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

//-------------------- Create IAM Policy and Role --------------------

module "fgt_ha_iampolicy" {
  source = "./modules/iam_policy"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FGT-HA"
  iampolicyfile="./assets/fgt_ha_iampolicy.json"
}
module "fgt_ha_iamrole" {
  source = "./modules/iam_role"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FGT-HA"
  iamassumepolicyfile="./assets/ec2_assume_rolepolicy.json"
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = module.fgt_ha_iamrole.id
  policy_arn = module.fgt_ha_iampolicy.arn
}
resource "aws_iam_instance_profile" "fortigate_iamprofile" {
  name = "${var.TAG}-${var.project}-FGT-HA-IAM-PROFILE"
  role = module.fgt_ha_iamrole.id
}


//-------------------- Create Instance --------------------

module "fgt1" {
  source = "./modules/fgtinstance_ha"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FGT1"
  aws_fgt_ami= var.byol? data.aws_ami.fgt_ami_byol.id : data.aws_ami.fgt_ami_ondemand.id
  aws_fgt_instance_type = var.fortigate_instance_type
  availability_zone = var.AZs[0]
  keypair= var.keypair
  use_eip= var.use_eip
  assign_publicip= var.assign_publicip
  public_subnet_id= aws_subnet.external_subnet.0.id
  private_subnet_id= aws_subnet.internal_subnet.0.id
  ha_subnet_id= aws_subnet.ha_subnet.0.id
  mgmt_subnet_id= aws_subnet.mgmt_subnet.0.id
  security_group_public_id=    module.fgt_public_sg.id
  security_group_private_id= module.fgt_private_sg.id
  security_group_ha_id= module.fgt_ha_sg.id
  security_group_mgmt_id= module.fgt_mgmt_sg.id
  public_ip_address= var.fgt1_public_ip
  private_ip_address= var.fgt1_private_ip
  ha_ip_address= var.fgt1_ha_ip
  mgmt_ip_address= var.fgt1_mgmt_ip
  iam_instance_profile_id= aws_iam_instance_profile.fortigate_iamprofile.id
  fortigate_hostname= "${var.TAG}-${var.project}-FGT1"
  fgt_priority= var.fgt1_ha_priority
  fgt_ha_password= var.ha_password
  fgt_admin_password= var.fgt_admin_password
  fgt_ha_clustername= var.fgt_ha_clustername
  ha_peerip= var.fgt2_ha_ip
  cloudinitfile = var.byol? "./assets/fgt-ha-userdata.tpl":"./assets/fgt-ha-userdata_payg.tpl"
  licensefile= var.byol? "./assets/fgt1.lic" : ""

}

module "fgt2" {
  source = "./modules/fgtinstance_ha"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FGT2"
  aws_fgt_ami= var.byol? data.aws_ami.fgt_ami_byol.id : data.aws_ami.fgt_ami_ondemand.id
  aws_fgt_instance_type = var.fortigate_instance_type
  availability_zone = var.AZs[1]
  keypair= var.keypair
  use_eip= var.use_eip
  assign_publicip= false
  public_subnet_id= aws_subnet.external_subnet.1.id
  private_subnet_id= aws_subnet.internal_subnet.1.id
  ha_subnet_id= aws_subnet.ha_subnet.1.id
  mgmt_subnet_id= aws_subnet.mgmt_subnet.1.id
  security_group_public_id=    module.fgt_public_sg.id
  security_group_private_id= module.fgt_private_sg.id
  security_group_ha_id= module.fgt_ha_sg.id
  security_group_mgmt_id= module.fgt_mgmt_sg.id
  public_ip_address= var.fgt2_public_ip
  private_ip_address= var.fgt2_private_ip
  ha_ip_address= var.fgt2_ha_ip
  mgmt_ip_address= var.fgt2_mgmt_ip
  iam_instance_profile_id= aws_iam_instance_profile.fortigate_iamprofile.id
  fortigate_hostname= "${var.TAG}-${var.project}-FGT2"
  fgt_priority= var.fgt2_ha_priority
  fgt_ha_password= var.ha_password
  fgt_admin_password= var.fgt_admin_password
  fgt_ha_clustername= var.fgt_ha_clustername
  ha_peerip= var.fgt1_ha_ip
  cloudinitfile = var.byol? "./assets/fgt-ha-userdata.tpl":"./assets/fgt-ha-userdata_payg.tpl"
  licensefile= var.byol? "./assets/fgt2.lic" : ""
  byol= var.byol

}

//-------------------- Create and attach EIP --------------------

resource "aws_eip" "cluster_eip" {
  vpc                       = true
  network_interface         = module.fgt1.network_public_interface_id
  associate_with_private_ip = var.fgt1_public_ip
  tags = {
    Name = "${var.TAG}-${var.project}-CL-EIP"
  }
  depends_on= [
  aws_internet_gateway.internal_vpc_igw
  ]
}

//############################ FMG and FAZ INSTANCES ###########################

//-------------------- IAM --------------------
module "fmg_connector_iampolicy" {
  source = "./modules/iam_policy"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FMG"
  iampolicyfile="./assets/ec2_ro_only.json"
}
module "fmg_iamrole" {
  source = "./modules/iam_role"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FMG"
  iamassumepolicyfile="./assets/ec2_assume_rolepolicy.json"
}

resource "aws_iam_role_policy_attachment" "fmg-policy-attach" {
  role       = module.fmg_iamrole.id
  policy_arn = module.fmg_connector_iampolicy.arn
}
resource "aws_iam_instance_profile" "fmg_iamprofile" {
  name = "${var.TAG}-${var.project}-FMG-IAM-PROFILE"
  role = module.fmg_iamrole.id
}

//-------------------- GET AMI ID --------------------

data "aws_ami" "fmg_ami_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiManager VM64-AWS *${var.fmg_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
}

data "aws_ami_ids" "fmg_ami_ondemand" {
  filter {
    name                         = "name"
    values                       = ["FortiManager VM64-AWSOnDemand *${var.fmg_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
  sort_ascending                 = true 
}
data "aws_ami" "faz_ami_byol" {
  most_recent = true

  filter {
    name                         = "name"
    values                       = ["FortiAnalyzer VM64-AWS *${var.fmg_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical

}

data "aws_ami_ids" "faz_ami_ondemand" {
  filter {
    name                         = "name"
    values                       = ["FortiAnalyzer VM64-AWSOnDemand *${var.fmg_version}*"]
  }

  filter {
    name                         = "virtualization-type"
    values                       = ["hvm"]
  }

  owners                         = ["679593333241"] # Canonical
  sort_ascending                 = true 
}
//---------------------Instances---------------

data "template_file" "fmg_userdata" {
  count = length (var.fmgs_ip)
  template = var.byol? file("./assets/fmg-userdata.tpl"): file("./assets/fmg-userdata-payg.tpl")
    vars = {
    fmg_hostname         = "${var.TAG}-${var.project}-FMG${count.index+1}"
    fmg_byol_license= var.byol? "./assets/fmg${count.index+1}.lic" : ""
  }
}
module "fmg" {
  source = "./modules/create_instance"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FMG"
  nbr_instance= length (var.fmgs_ip)
  instance_ami= var.byol? data.aws_ami.fmg_ami_byol.id : data.aws_ami_ids.fmg_ami_ondemand.ids[0]
  subnet_id= aws_subnet.nocsoc_subnet.*.id
  instance_ip_address = var.fmgs_ip
  keypair= var.keypair
  security_group_id= module.fmg_sg.id
  iam_instance_profile_id= aws_iam_instance_profile.fmg_iamprofile.id
  availability_zone = var.AZs
  instance_type= var.fmg_instance_type
  cloudinitdata= data.template_file.fmg_userdata.*.rendered
}

//---------------------Instances---------------
data "template_file" "faz_userdata" {
  count = length (var.fazs_ip)
  template = var.byol? file("./assets/faz-userdata.tpl"): file("./assets/faz-userdata-payg.tpl")
    vars = {
    faz_hostname         = "${var.TAG}-${var.project}-FAZ${count.index+1}"
    faz_byol_license= var.byol? "./assets/faz${count.index+1}.lic" : ""
  }
}
module "faz" {
  source = "./modules/create_instance"
  aws_region = var.aws_region
  aws_profile = var.aws_profile
  TAG= var.TAG
  project= var.project
  name= "FAZ"
  nbr_instance= length (var.fazs_ip)
  instance_ami= var.byol? data.aws_ami.faz_ami_byol.id : data.aws_ami_ids.faz_ami_ondemand.ids[0]
  subnet_id= aws_subnet.nocsoc_subnet.*.id
  instance_ip_address = var.fazs_ip
  keypair= var.keypair
  security_group_id= module.faz_sg.id
  iam_instance_profile_id= aws_iam_instance_profile.fmg_iamprofile.id
  availability_zone = var.AZs
  instance_type= var.faz_instance_type
  cloudinitdata= data.template_file.faz_userdata.*.rendered
}


//############################ OUTPUTS ############################

output "internal_vpc_id" {
  value       = aws_vpc.internal_vpc.id
  description = "The VPC Id of the newly created VPC."
}
output "nocsoc_vpc_id" {
  value       = aws_vpc.nocsoc_vpc.id
  description = "The VPC Id of the newly created VPC."
}
output "TGW_id" {
  value       = var.newtgw ? aws_ec2_transit_gateway.tgw.0.id : var.existtgwid
  description = "The ID of the TGW."
}

output "BYOL_AMI_ID" {
  value       = data.aws_ami.fgt_ami_byol.id
  description = "BYOL AMI."
}
output "ONDEMAND_AMI_ID" {
  value       = data.aws_ami.fgt_ami_ondemand.id
  description = "BYOL AMI."
}
output "FGT1_ID" {
  value       = module.fgt1.instance_id
  description = "FGT1 instance ID"
}
output "FGT2_ID" {
  value       = module.fgt2.instance_id
  description = "FGT2 instance ID"
}

output "FMG_ID" {
  value       = module.fmg.instance_id
  description = "FMG instance ID"
}
output "FAZ_ID" {
  value       = module.faz.instance_id
  description = "FAZ instance ID"
}
output "FMGMI_IDs" {
  value       = data.aws_ami_ids.fmg_ami_ondemand.ids

}
output "FAZ_AMI_IDs" {
  value       = data.aws_ami_ids.faz_ami_ondemand.ids

}

*/