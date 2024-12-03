// TGW -Tokyo
resource "aws_ec2_transit_gateway" "tokyo_tgw" {
  description = "Transit Gateway for Tokyo region"

  tags = {
    Name = "Tokyo-TGW"
  }
}
// TGW -New York
resource "aws_ec2_transit_gateway" "new_york_tgw" {
  provider = aws.new_york

  description = "Transit Gateway for New York region"

  tags = {
    Name = "NewYork-TGW"
  }
}
################################################################################
// VPC attachemnts -Tokyo -- UPDATE ONLY THIS SECTION
resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_vpc_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id
  vpc_id             = aws_vpc.security_zone.id

  subnet_ids = [
    aws_subnet.private-security-zone.id
  
  ]

  tags = {
    Name = "Tokyo-VPC-TGW-Attachment"
  }
}
// VPC attachment -New York
resource "aws_ec2_transit_gateway_vpc_attachment" "new_york_vpc_attachment" {
  provider          = aws.new_york
  transit_gateway_id = aws_ec2_transit_gateway.new_york_tgw.id
  vpc_id            = aws_vpc.agent_zone.id

  subnet_ids = [
    aws_subnet.private-agent-zone.id

  ]

  tags = {
    Name = "NewYork-VPC-TGW-Attachment"
  }
}
################################################################################################
// TGW Perring Attachment Tokyo
resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_new_york_peering" {
  transit_gateway_id             = aws_ec2_transit_gateway.tokyo_tgw.id
  peer_transit_gateway_id        = aws_ec2_transit_gateway.new_york_tgw.id
  peer_region                    = "us-east-1"

  tags = {
    Name = "Tokyo-NewYork-TGW-Peering"
  }
}
################################################################################################
// TGW Peering Attachment New York
resource "aws_ec2_transit_gateway_route_table" "tokyo_tgw_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id

  tags = {
    Name = "Tokyo-TGW-Route-Table"
  }
}
##############################################################################################
// Accept Transit Gateway Peering Connection in New York
resource "aws_ec2_transit_gateway_peering_attachment_accepter" "new_york_accept_tgw_peering" {
  provider = aws.new_york

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tokyo_new_york_peering.id

  tags = {
    Name = "NewYork-Accept-Tokyo-Peering"
  }
}
