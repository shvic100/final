resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb_sg_name
  }
}

resource "aws_iam_policy" "alb_ingress_policy" {
  name        = var.alb_ingress_policy_name
  description = "Policy for ALB Ingress Controller"
  policy      = file(var.alb_ingress_policy_file)
}

resource "aws_iam_role" "alb_ingress_role" {
  name = var.alb_ingress_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_ingress_role_policy" {
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
  role       = aws_iam_role.alb_ingress_role.name
}

output "alb_ingress_role_arn" {
  value = aws_iam_role.alb_ingress_role.arn
}
