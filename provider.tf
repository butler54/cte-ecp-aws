terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }

    backend "kubernetes" {
        config_path = "~/.kube/config"
        secret_suffix = "cte-ecp-aws"
    }
}
