provider "aws" {
  region = var.region  # 사용할 AWS 리전 설정
}

module "eks" {
  source           = "./modules/eks"  # EKS 모듈 경로
  region           = var.region  # 사용할 AWS 리전
  cluster_name     = var.cluster_name  # EKS 클러스터 이름
  cluster_role_arn = var.cluster_role_arn  # EKS 클러스터에 할당할 IAM 역할의 ARN
  node_group_name  = var.node_group_name  # 노드 그룹 이름
  node_role_arn    = var.node_role_arn  # 노드 그룹에 할당할 IAM 역할의 ARN
  subnet_ids       = var.subnet_ids  # EKS 클러스터에 사용할 서브넷 ID 목록
  instance_types   = var.instance_types  # 노드 그룹에 사용할 인스턴스 유형 목록
  desired_capacity = var.desired_capacity  # 원하는 노드 수
  max_capacity     = var.max_capacity  # 최대 노드 수
  min_capacity     = var.min_capacity  # 최소 노드 수
  tags             = var.tags  # 태그 설정
}

output "eks_cluster_id" {
  value = module.eks.cluster_id  # EKS 클러스터 ID 출력
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint  # EKS 클러스터 엔드포인트 URL 출력
}

output "eks_cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority  # EKS 클러스터 인증 기관 데이터 출력
}
