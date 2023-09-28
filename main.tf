provider "aws" {
    region = "us-east-1" 
} 

terraform {
  backend "s3" {
    bucket         = "task51"
    key            = "task5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "TerraformStateLocks"
  }
}

module "my-network"{
    source = "./modules/network"
}

module "cluster"{
    source = "./modules/cluster"
    eks_subnets = [ 
        module.my-network.public_subnet_1_id, 
        module.my-network.public_subnet_2_id, 
        module.my-network.private_subnet_1_id, 
        module.my-network.private_subnet_2_id
    ]
}

module "node_group"{
    source = "./modules/node_group"
    eks_name = module.cluster.eks_name
    subnet_ids = [ 
        module.my-network.private_subnet_1_id, 
        module.my-network.private_subnet_2_id
    ]
}