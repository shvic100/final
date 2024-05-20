variable "region" {
  description = "The AWS region to deploy to"  # 배포할 AWS 리전
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"  # VPC의 CIDR 블록
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "The CIDR block for the public subnet in AZ a"  # 퍼블릭 서브넷 A의 CIDR 블록
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_c_cidr" {
  description = "The CIDR block for the public subnet in AZ c"  # 퍼블릭 서브넷 C의 CIDR 블록
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  description = "The CIDR block for the private subnet in AZ a"  # 프라이빗 서브넷 A의 CIDR 블록
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_c_cidr" {
  description = "The CIDR block for the private subnet in AZ c"  # 프라이빗 서브넷 C의 CIDR 블록
  type        = string
  default     = "10.0.3.0/24"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"  # 클러스터 이름
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster"  # 쿠버네티스 버전
  type        = string
  default     = "1.28"
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the EKS node group"  # 최소 노드 수
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the EKS node group"  # 최대 노드 수
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the EKS node group"  # 원하는 노드 수
  type        = number
  default     = 2
}

variable "node_group_instance_types" {
  description = "Instance types for the EKS node group"  # 인스턴스 유형
  type        = list(string)
  default     = ["t3.small"]
}

variable "cluster_endpoint_private_access" {
  description = "Enable private access to the EKS cluster endpoint"  # 프라이빗 엔드포인트 접근 설정
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to resources"  # 태그 설정
  type        = map(string)
  default     = {
    Environment = "dev"
    Terraform   = "true"
  }
}
