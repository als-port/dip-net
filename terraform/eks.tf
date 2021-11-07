//resource "aws_iam_role" "eks_cluster_role" {
//  # The name of the role
//  name = var.cluster_name
//  assume_role_policy = <<POLICY
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "eks.amazonaws.com"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//POLICY
//}
//
//resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
//  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
//  role = aws_iam_role.eks_cluster_role.name
//}

resource "aws_iam_role" "wg1_role" {
  # The name of the role
  name = "eks-node-group-general"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.wg1_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.wg1_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  # The role the policy should be applied to
  role = aws_iam_role.wg1_role.name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "avail" {
  state = "available"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token

}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
  //role_arn = aws_iam_role.eks_cluster_role.arn

}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_version = "1.21"
  cluster_name    = var.cluster_name
  vpc_id          = aws_vpc.my_vpc.id
  subnets         = [aws_subnet.public_subnet.id, aws_subnet.public_subnet1.id]
  cluster_endpoint_public_access = true

  worker_groups_launch_template = [
    {
      name          = "wg1"
      instance_type = "t2.micro"
      asg_desired_capacity = 2
      node_role_arn = aws_iam_role.wg1_role.arn
      additional_security_group_ids = [aws_security_group.main.id]
      public_ip = true
      key_name = "aws-key1"

    }
  ]
}

//provider "kubernetes" {
//  host                   = aws_eks_cluster.eks.endpoint
//  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
//  token                  = data.aws_eks_cluster_auth.eks.token
//
//}
//
//data "aws_eks_cluster_auth" "eks" {
//  name = aws_eks_cluster.eks.name
//}
//
//resource "aws_eks_cluster" "eks" {
//  name = var.cluster_name
//  role_arn = aws_iam_role.eks_cluster_role.arn
//
//  # Desired Kubernetes master version
//  version = "1.21"
//
//  vpc_config {
//    //endpoint_private_access = false
//    endpoint_public_access = true
//    subnet_ids = [
//      aws_subnet.public_subnet.id,
//      aws_subnet.public_subnet1.id
//    ]
//  }
//
//  depends_on = [
//    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
//  ]
//}
//
resource "aws_eks_node_group" "ng1" {
  cluster_name = module.eks.cluster_id
  node_group_name = "ng1"
  node_role_arn = aws_iam_role.wg1_role.arn

  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet1.id
  ]

  scaling_config {
    desired_size = 2
    max_size = 2
    min_size = 2
  }

  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  force_update_version = false
  instance_types = ["t2.micro"]
  remote_access {
    ec2_ssh_key = "aws-key1"
    //source_security_group_ids = [aws_security_group.main.id]

  }

  labels = {
    role = "wg1_role"
  }

  version = "1.21"

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_general,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_general,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]
}