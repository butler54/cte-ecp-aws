resource "aws_key_pair" "ctm_ssh_key" {
    key_name   = "ctm_ssh_key"
    public_key = file("~/.ssh/id_rsa_yubikey.pub")

}
# Creating an instance of CipherTrust Manager Community Edition from the AWS Marketplace - https://aws.amazon.com/marketplace/pp/prodview-adjvglziiunpg
resource "aws_instance" "cm_instance" {
    ami = "ami-07838f3bd8eac0f9d"
    instance_type = "t2.xlarge"   # Recommended Size
    vpc_security_group_ids = [aws_security_group.ctm_sg.id]
    subnet_id = data.aws_subnet.ocp_subnet.id
    key_name = aws_key_pair.ctm_ssh_key.key_name
    associate_public_ip_address = "true"
    tags = {
            Name = "Ciphertrust Manager Instance"
        }
    
    root_block_device {
      volume_size = 100   # Recommended size to run CipherTrust Manager in production
      volume_type = "gp2"   # For higher volume transactions, you might want to update the type of EBS volume.
    }
    
}

# resource "aws_eip" "my_eip" {
#   vpc = true
# }

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.cm_instance.id
#   allocation_id = aws_eip.my_eip.id
# } 

resource "aws_security_group" "ctm_sg" {
    name        = "ctm_sg"
    description = "Allow inbound and outbound traffic from EC2 instances"
    vpc_id      = data.aws_vpc.ocp_vpc.id


}

resource "aws_vpc_security_group_egress_rule" "ctm_sg_egress" {
    security_group_id = aws_security_group.ctm_sg.id
    ip_protocol       = "-1"
    cidr_ipv4       = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "worker_nodes_to_aws" {
    security_group_id = aws_security_group.ctm_sg.id
    from_port         = 443
    to_port           = 443
    ip_protocol = "tcp"
    referenced_security_group_id = data.aws_security_group.ocp_worker_node_sg.id
}

locals {
  subnets = split(",", var.public_access_subnets)
}
resource "aws_vpc_security_group_ingress_rule" "web_access_to_ctm" {
    count = length(local.subnets)

    security_group_id = aws_security_group.ctm_sg.id
    from_port         = 443
    to_port           = 443
    ip_protocol       = "tcp"
    cidr_ipv4      = local.subnets[count.index]
}

# resource "aws_vpc_security_group_ingress_rule" "ssh_access_to_global" {

#     security_group_id = aws_security_group.ctm_sg.id
#     from_port         = 22
#     to_port           = 22
#     ip_protocol       = "tcp"
#     cidr_ipv4      = "0.0.0.0/0"
# }



resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_to_ctm" {
    count = length(local.subnets)

    security_group_id = aws_security_group.ctm_sg.id
    from_port         = 22
    to_port           = 22
    ip_protocol       = "tcp"
    cidr_ipv4      = local.subnets[count.index]
}

