resource "aws_iam_role" "eks_cluster" {
    name = "task6-8"
    assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "eks.amazonaws.com"
                ]
            }
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_iam_role.eks_cluster.name
  
}

resource "aws_eks_cluster" "eks_cluster" {
    name = "eks"
    role_arn = aws_iam_role.eks_cluster.arn
    version = "1.28"
    vpc_config {
      endpoint_private_access = false
      endpoint_public_access = true
      subnet_ids = var.eks_subnets
    }
    depends_on = [ aws_iam_role_policy_attachment.eks_policy ]
  
}