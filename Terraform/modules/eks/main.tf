provider "aws" {
  region = var.region  # 사용할 AWS 리전 설정
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name  # EKS 클러스터 이름
  role_arn = var.cluster_role_arn  # EKS 클러스터에 할당된 IAM 역할 ARN
  version  = var.kubernetes_version  # Kubernetes 버전 설정

  vpc_config {
    subnet_ids = var.subnet_ids  # EKS 클러스터에 사용할 서브넷 ID 목록
  }
  
  tags = var.tags  # 태그 설정
}

resource "aws_eks_node_group" "node_group" {
  depends_on      = [aws_eks_cluster.eks]  # 클러스터 생성 완료 후 노드 그룹 생성
  cluster_name    = aws_eks_cluster.eks.name  # 클러스터 이름
  node_group_name = var.node_group_name  # 노드 그룹 이름
  node_role_arn   = var.node_role_arn  # 노드 그룹에 할당된 IAM 역할 ARN
  subnet_ids      = var.subnet_ids  # 노드 그룹에 사용할 서브넷 ID 목록
  instance_types  = var.instance_types  # 사용할 인스턴스 유형 목록
  scaling_config {
    desired_size  = var.desired_capacity  # 원하는 노드 수
    max_size      = var.max_capacity  # 최대 노드 수
    min_size      = var.min_capacity  # 최소 노드 수
  }

  tags = var.tags  # 태그 설정
}
