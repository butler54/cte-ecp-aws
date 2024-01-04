

data "aws_vpc" "ocp_vpc" {
    # We sponge off of the VPC created by the RHDPS installation of OCP
    id = var.vpc_id
}


data "aws_subnet" "ocp_subnet" {
    id = var.subnet_id
}

data "aws_security_group" "ocp_worker_node_sg" {
    id = var.worker_node_sg
}

