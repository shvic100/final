variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "alb_sg_name" {
  description = "Name of the ALB security group"
  type        = string
}

variable "alb_ingress_policy_name" {
  description = "Name of the ALB ingress policy"
  type        = string
}

variable "alb_ingress_policy_file" {
  description = "File path for the ALB ingress policy"
  type        = string
}

variable "alb_ingress_role_name" {
  description = "Name of the ALB ingress role"
  type        = string
}

variable "alb_ingress_service_account_name" {
  description = "Name of the ALB ingress service account"
  type        = string
}

variable "app_lb_name" {
  description = "Name of the application load balancer"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "app_tg_name" {
  description = "Name of the application target group"
  type        = string
}

variable "app_listener_http_name" {
  description = "Name of the HTTP listener for the application load balancer"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_id" {
  description = "EKS cluster ID"
  type        = string
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
}
