output "cluster_id" {
  value = aws_eks_cluster.eks.id  # 클러스터 ID 출력
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint  # 클러스터 엔드포인트 URL 출력
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.eks.certificate_authority[0].data  # 클러스터 인증 기관 데이터 출력
}
