variable "region" {
  description = "ap-northeast-1"  # 배포할 AWS 리전
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"  # EKS 클러스터 이름
  type        = string
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster"  # EKS 클러스터에 할당할 IAM 역할의 ARN
  type        = string
}

variable "node_group_name" {
  description = "The name of the node group"  # 노드 그룹 이름
  type        = string
}

variable "node_role_arn" {
  description = "The ARN of the IAM role to use for the node group"  # 노드 그룹에 할당할 IAM 역할의 ARN
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster"  # EKS 클러스터에 사용할 서브넷 ID 목록
  type        = list(string)
}

variable "instance_types" {
  description = "A list of instance types for the node group"  # 노드 그룹에 사용할 인스턴스 유형 목록
  type        = list(string)
}

variable "desired_capacity" {
  description = "The desired number of nodes in the node group"  # 원하는 노드 수
  type        = number
}

variable "max_capacity" {
  description = "The maximum number of nodes in the node group"  # 최대 노드 수
  type        = number
}

variable "min_capacity" {
  description = "The minimum number of nodes in the node group"  # 최소 노드 수
  type        = number
}

variable "tags" {
  description = "A map of tags to assign to the resources"  # 리소스에 할당할 태그 목록
  type        = map(string)
  default     = {}
}
