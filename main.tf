// Main module to deploy all at once

// deploy vpc
module "terraform_vpc" {
  source  			= "./vpc"
  aws_access_key 	= "${var.aws_access_key}"
  aws_secret_key 	= "${var.aws_secret_key}"
  aws_key_name   	= "${var.aws_key_name}"
  }

// deploy database
module "terraform_database" {
  source  			= "./database"
  aws_access_key 	= "${var.aws_access_key}"
  aws_secret_key 	= "${var.aws_secret_key}"
  aws_key_name   	= "${var.aws_key_name}"
  vpc_id			= "${module.terraform_vpc.vpcId}"
  subnet_id         = "${module.terraform_vpc.privateSubnet}"
  depends_on 	 	= ["${module.terraform_vpc.vpcId}"]
}

// deploy webserver
module "terraform_webserver" {
  source  			= "./webserver"
  aws_access_key 	= "${var.aws_access_key}"
  aws_secret_key 	= "${var.aws_secret_key}"
  aws_key_name   	= "${var.aws_key_name}"
  vpc_id			= "${module.terraform_vpc.vpcId}"
  subnet_id         = "${module.terraform_vpc.publicSubnet}"
  depends_on 	 	= ["${module.terraform_vpc.vpcId}"]
}