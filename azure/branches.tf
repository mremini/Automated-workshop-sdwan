//############################ Create Branch VNETs  ##################

resource "azurerm_virtual_network" "branches" {
for_each = var.az_branches

  name                = "${var.project}-${var.TAG}-${each.value.name}"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.hubrg.name
  address_space       = [each.value.cidr]

  tags = {
    Project = "${var.project}"
    Role    = "${var.TAG}"
  }
}

//############################ Create Branch Subnets ############################

resource "azurerm_subnet" "brsubnets" {
  for_each = var.az_branchsubnetscidrs

  name                 = each.value.name == "RouteServerSubnet" ? "${each.value.name}" :  "${var.TAG}-${var.project}-subnet-${each.value.name}"
  resource_group_name  = azurerm_resource_group.hubrg.name
  address_prefixes     = [each.value.cidr]
  virtual_network_name = azurerm_virtual_network.branches[each.value.vnet].name

}

//############################  Branch Route Tables ############################
resource "azurerm_route_table" "branchvnet_route_tables" {
  for_each = var.branch_vnetroutetables

  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  //disable_bgp_route_propagation = false
  tags = {
    Project = "${var.project}"
  }
}


//############################  RT Associations ############################
resource "azurerm_subnet_route_table_association" "brvnet_rt_assoc" {
  for_each = var.branch_vnetroutetables

  subnet_id = azurerm_subnet.brsubnets[each.key].id
  #subnet_id      = data.azurerm_subnet.pub_subnet.id
  route_table_id = azurerm_route_table.branchvnet_route_tables[each.key].id
}



//############################################################################################################################################

//############################  FGTs NICs ############################

//############################  LB ############################

resource "azurerm_public_ip" "branchpip" {
for_each = var.branchpublicip
  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  allocation_method   = "Static"
  sku = "Standard"

  tags = {
    Project = "${var.project}"
  }

}


resource "azurerm_lb" "intbranchlb" {
for_each = var.intbranchlb

  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  sku                 = "Standard"

  frontend_ip_configuration {

    name                 = "${var.TAG}-${var.project}-${each.value.name}-ip1"
    //public_ip_address_id = ( each.value.type == "external" ? azurerm_public_ip.branchpip[each.value.frontendip].id : null )

    subnet_id              = ( each.value.type == "internal" ? azurerm_subnet.brsubnets[each.value.subnet].id : null )
    private_ip_address_allocation = ( each.value.type == "internal" ? "Static" : null )
    private_ip_address            = ( each.value.type == "internal" ? each.value.frontendip : null )

  }

  tags = {
    Project = "${var.project}"
  }
}

/////////////////////////////////////This code is not good

resource "azurerm_lb" "extlbbranch1" {
for_each = var.extbranchlb1
  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  sku                 = "Standard"

   frontend_ip_configuration {

    name                 = "${var.TAG}-${var.project}-${each.value.name}-ip1"
    public_ip_address_id = ( each.value.type == "external" ? azurerm_public_ip.branchpip[each.value.frontendip1].id : null )

  }
   frontend_ip_configuration {

    name                 = "${var.TAG}-${var.project}-${each.value.name}-ip2"
    public_ip_address_id = ( each.value.type == "external" ? azurerm_public_ip.branchpip[each.value.frontendip2].id : null )
  }  

  tags = {
    Project = "${var.project}"
  }
}

resource "azurerm_lb" "extlbbranch2" {
for_each = var.extbranchlb2
  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  sku                 = "Standard"

   frontend_ip_configuration {

    name                 = "${var.TAG}-${var.project}-${each.value.name}-ip1"
    public_ip_address_id = ( each.value.type == "external" ? azurerm_public_ip.branchpip[each.value.frontendip1].id : null )

  }
   frontend_ip_configuration {

    name                 = "${var.TAG}-${var.project}-${each.value.name}-ip2"
    public_ip_address_id = ( each.value.type == "external" ? azurerm_public_ip.branchpip[each.value.frontendip2].id : null )
  }  

  tags = {
    Project = "${var.project}"
  }
}



/*
resource "azurerm_lb" "branchlb" {
dynamic "origin" {
for_each = var.branchlb

  name                = "${var.TAG}-${var.project}-${each.value.name}"
  location            = azurerm_virtual_network.branches[each.value.vnet].location
  resource_group_name = azurerm_resource_group.hubrg.name
  sku                 = "Standard"

  dynamic frontend_ip_configuration {
   for_each = origin.value.frontendip
    name                 = "${var.TAG}-${var.project}-${each.value.name}"
    public_ip_address_id = ( origin.value.type == "external" ? azurerm_public_ip.branchpip[each.value.pip].id : null )

    subnet_id              = ( origin.value.type == "internal" ? azurerm_subnet.brsubnets[origin.value.subnet].id : null )
    private_ip_address_allocation = ( origin.value.type== "internal" ? "Static" : null )
    private_ip_address            = ( origin.value.type == "internal" ? each.value.pip: null )

  }

  tags = {
    Project = "${var.project}"
  }

}
}

*/


