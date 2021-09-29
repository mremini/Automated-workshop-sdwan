//-------------------------------TGW and TGW Hub Attachments and RTB------------------

resource "aws_ec2_transit_gateway" "tgw" {
  description      = "${var.TAG}-${var.project}-TGW"
  dns_support= "enable"
  vpn_ecmp_support = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

    tags = {
    Name = "${var.TAG}-${var.project}-tgw"
  }
}

/*
data "aws_subnet_ids" "aws_hub_tgw_subnetid" {
    vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)
    tags = {
    Name = "*tgw*"
    }
}*/


/* Hub vpc att */
resource "aws_ec2_transit_gateway_vpc_attachment" "hub_vpc_tgw_attch" {
  subnet_ids         = [for sub in aws_subnet.aws_hub_subnet_tgw : sub.id ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = element(aws_vpc.aws_hub_vpc.*.id , 0)
  transit_gateway_default_route_table_association= false
  transit_gateway_default_route_table_propagation= false
  tags = {
    Name = "${var.TAG}-${var.project}-hub-vpc-att"
  }
}

/* spoke1 vpc att */
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1_vpc_tgw_attch" {

  subnet_ids         = [for sub in aws_subnet.aws_spoke1_subnet : sub.id ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 0)  // This code is not very clean
  transit_gateway_default_route_table_association= false
  transit_gateway_default_route_table_propagation= false
  tags = {
    Name = "${var.TAG}-${var.project}-spoke1-vpc-att"
  }
}

/* spoke2 vpc att */
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke2_vpc_tgw_attch" {

  subnet_ids         = [for sub in aws_subnet.aws_spoke2_subnet : sub.id ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = element(aws_vpc.aws_spoke_vpc.*.id , 1)  // This code is not very clean
  transit_gateway_default_route_table_association= false
  transit_gateway_default_route_table_propagation= false
  tags = {
    Name = "${var.TAG}-${var.project}-spoke2-vpc-att"
  }
}

//################################ TGW RTB ################################

//----------------------RTBs--------------
resource "aws_ec2_transit_gateway_route_table" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.TAG}-${var.project}-SpokeVPCsRouteTable"
  }

}

resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id=  aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id

}

resource "aws_ec2_transit_gateway_route_table" "FGT" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "${var.TAG}-${var.project}-HubRouteTable"
  }
}

//----------------------Association--------------
resource "aws_ec2_transit_gateway_route_table_association" "spoke1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke2" {
 // for_each = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_tgw_attch
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
}

resource "aws_ec2_transit_gateway_route_table_association" "FGT_VPC" {
//  for_each = aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.FGT.id
}


//----------------------Propagation--------------
resource "aws_ec2_transit_gateway_route_table_propagation" "FGT_VPC-To-Spoke" {
//  for_each = aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub_vpc_tgw_attch.id

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "Spoke1_to_FGT_RTB" {
//    for_each = aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_tgw_attch
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke1_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.FGT.id
}
resource "aws_ec2_transit_gateway_route_table_propagation" "Spoke2_to_FGT_RTB" {
//  for_each = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_tgw_attch
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke2_vpc_tgw_attch.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.FGT.id
}