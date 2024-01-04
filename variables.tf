variable "aws_region" {
    description = "Region Thales CipherTrust Manager will be deployed in."
    type = string
    default = "ap-southeast-1"
}

variable "kubeconfig" {
    description = "Path to the kubeconfig file."
    type = string
    default = "~/.kube/config"
}

variable "vpc_id" {
    description = "VPC used by the OCP installer"
    type = string
}

variable "subnet_id" {
    description = "Subnet used by the OCP installer"
    type = string   
  
}

variable "worker_node_sg" {
    description = "Security Group used by the OCP installer for the worker nodes"
    type = string
}

variable "bastion_eip" {
    description = "Security Group used by the bastion node"
    type = string
}


variable "public_access_subnets" {
    description = "List of subnets as a comma separated string that will be allowed to access the CipherTrust Manager"
    type = string
}
