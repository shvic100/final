#IAM Role 및 정책 설정
#Karpenter가 AWS 리소스를 관리할 수 있도록 IAM 역할과 정책을 설정해야 합니다.

resource "aws_iam_role" "karpenter" {
  name = "KarpenterControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "karpenter" {
  name = "KarpenterControllerPolicy"
  role = aws_iam_role.karpenter.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:GetCoipPoolUsage",
          "ec2:DescribeVpcs",
          "iam:PassRole",
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:DeleteTags"
        ],
        Resource = "*",
        Effect = "Allow"
      }
    ]
  })
}
