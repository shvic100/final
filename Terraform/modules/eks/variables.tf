variable "region" {
  description = "The AWS region to deploy to"  # 배포할 AWS 리전
  type        = string
  default     = "ap-northeast-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"  # EKS 클러스터 이름
  type        = string
  default     = "EOF_EKS"
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster"  # EKS 클러스터에 할당할 IAM 역할의 ARN
  type        = string
  default     = "arn:aws:iam::058264352854:role/eksClusterRole"
}

variable "node_group_name" {
  description = "The name of the node group"  # 노드 그룹 이름
  type        = string
  default     = "EOF"
}

variable "node_role_arn" {
  description = "The ARN of the IAM role to use for the node group"  # 노드 그룹에 할당할 IAM 역할의 ARN
  type        = string
  default     = "arn:aws:iam::058264352854:instance-profile/EC2"
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster"  # EKS 클러스터에 사용할 서브넷 ID 목록
  type        = list(string)
  default     = ["subnet-00d02eafb4e506765", "subnet-09edd79d5a32315c0"]
}

variable "instance_types" {
  description = "A list of instance types for the node group"  # 노드 그룹에 사용할 인스턴스 유형 목록
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_capacity" {
  description = "The desired number of nodes in the node group"  # 원하는 노드 수
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "The maximum number of nodes in the node group"  # 최대 노드 수
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "The minimum number of nodes in the node group"  # 최소 노드 수
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of tags to assign to the resources"  # 리소스에 할당할 태그 목록
  type        = map(string)
  default     = {
    NAME = "EOF-subnet-public1-ap-northeast-1a"
    Environment = "EOF"
    }
}
