output "vpcId" {
	value = "${aws_vpc.default.id}"
}

output "natGateway" {
  value = "${aws_nat_gateway.gw.id}"
}

output "privateSubnet" {
  value = "${aws_subnet.private_subnet.id}"
}

output "publicSubnet" {
  value = "${aws_subnet.public-subnet.id}"
}