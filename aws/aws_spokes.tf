//############################ SPOKE VPC ############################

resource "aws_vpc" "aws_spoke_vpc" {
  count = length(var.aws_spokescidr)
  cidr_block           = var.aws_spokescidr[count.index]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.TAG}-${var.project}-spoke-${count.index}+1"
  }
}

resource "aws_subnet" "aws_spoke1_subnet" {
  for_each = var.aws_spoke1subnets_az
  
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 0)  // This code is not very clean

  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-spoke1-${each.value.name}-${each.value.az}"
  }
}

resource "aws_subnet" "aws_spoke2_subnet" {
  for_each = var.aws_spoke2subnets_az
  
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 1)  // This code is not very clean

  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.TAG}-${var.project}-spoke2-${each.value.name}-${each.value.az}"
  }
}

//----------------------------------Spoke RTB-----------------------------------------------
//---------------------Spoke1---------
resource "aws_route_table" "spoke1_rtb" {
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 0) 

  tags = {
    Name = "${var.TAG}-${var.project}-spoke1_rtb"
  }
}
resource "aws_route_table_association" "spoke1_rtb_assoc" {
  for_each = aws_subnet.aws_spoke1_subnet
  subnet_id     = each.value.id
  route_table_id = aws_route_table.spoke1_rtb.id
}
resource "aws_route" "spoke1_default_tgw" {
  route_table_id              = aws_route_table.spoke1_rtb.id
  destination_cidr_block =      "0.0.0.0/0"
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  depends_on=[
    aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_tgw_attch
    ]
}

//---------------------Spoke2---------
resource "aws_route_table" "spoke2_rtb" {
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 1) 
  tags = {
    Name = "${var.TAG}-${var.project}-spoke2_rtb"
  }
}
resource "aws_route_table_association" "spoke2_rtb_assoc" {
 for_each = aws_subnet.aws_spoke2_subnet
  subnet_id     = each.value.id
  route_table_id = aws_route_table.spoke2_rtb.id
}
resource "aws_route" "spoke2_default_tgw" {
  route_table_id              = aws_route_table.spoke2_rtb.id
  destination_cidr_block =      "0.0.0.0/0"
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  depends_on=[
    aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_tgw_attch
    ]
}






