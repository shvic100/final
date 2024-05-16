region           = "ap-northeast-1"
cluster_name     = "EOF_EKS"
cluster_role_arn = "arn:aws:iam::058264352854:role/eksClusterRole"
node_group_name  = "EOF"
node_role_arn    = "arn:aws:iam::058264352854:instance-profile/EC2"
subnet_ids       = ["subnet-00d02eafb4e506765", "subnet-09edd79d5a32315c0"]
instance_types   = ["t3.medium"]
desired_capacity = 1
max_capacity     = 3
min_capacity     = 1
tags             = {
  "Environment" = "dev"
}
