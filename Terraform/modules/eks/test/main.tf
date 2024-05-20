# AWS 제공자 설정
provider "aws" {
  region = "ap-northeast-1"  # 사용할 AWS 리전 설정
}

# VPC 리소스 생성
resource "aws_vpc" "EOF-vpc" {
  cidr_block           = "10.0.0.0/16"  # VPC의 CIDR 블록 설정
  enable_dns_hostnames = true  # DNS 호스트네임 활성화
  enable_dns_support   = true  # DNS 지원 활성화
  instance_tenancy     = "default"  # 인스턴스 테넌시 설정
  tags = {
    Name = "EOF-vpc"  # 태그 설정
  }
}

# 퍼블릭 서브넷 생성 (AZ: ap-northeast-2a)
resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.EOF-vpc.id  # VPC ID 참조
  cidr_block              = "10.0.0.0/24"  # 서브넷의 CIDR 블록 설정
  map_public_ip_on_launch = true  # 퍼블릭 IP 자동 할당
  availability_zone       = "ap-northeast-1a"  # 가용 영역 설정
}

# 퍼블릭 서브넷 생성 (AZ: ap-northeast-2c)
resource "aws_subnet" "public-c" {
  vpc_id                  = aws_vpc.EOF-vpc.id  # VPC ID 참조
  cidr_block              = "10.0.1.0/24"  # 서브넷의 CIDR 블록 설정
  map_public_ip_on_launch = true  # 퍼블릭 IP 자동 할당
  availability_zone       = "ap-northeast-1c"  # 가용 영역 설정
}

# 프라이빗 서브넷 생성 (AZ: ap-northeast-2a)
resource "aws_subnet" "private-a" {
  vpc_id                  = aws_vpc.EOF-vpc.id  # VPC ID 참조
  cidr_block              = "10.0.2.0/24"  # 서브넷의 CIDR 블록 설정
  map_public_ip_on_launch = true  # 퍼블릭 IP 자동 할당
  availability_zone       = "ap-northeast-1a"  # 가용 영역 설정
}

# 프라이빗 서브넷 생성 (AZ: ap-northeast-2c)
resource "aws_subnet" "private-c" {
  vpc_id                  = aws_vpc.EOF-vpc.id  # VPC ID 참조
  cidr_block              = "10.0.3.0/24"  # 서브넷의 CIDR 블록 설정
  map_public_ip_on_launch = true  # 퍼블릭 IP 자동 할당
  availability_zone       = "ap-northeast-1c"  # 가용 영역 설정
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "EOF-igw" {
  vpc_id = aws_vpc.EOF-vpc.id  # VPC ID 참조
  tags = {
    Name = "EOF-internet-gateway"  # 태그 설정
  }
}

# 기본 라우팅 테이블 태그 설정
resource "aws_default_route_table" "public-route_table" {
  default_route_table_id = aws_vpc.EOF-vpc.default_route_table_id  # 기본 라우팅 테이블 ID 참조
  tags = {
    Name = "default"  # 태그 설정
  }
}

# 인터넷 게이트웨이를 사용하는 라우트 설정
resource "aws_route" "internet-gw-route" {
  route_table_id         = aws_vpc.EOF-vpc.main_route_table_id  # 라우팅 테이블 ID 참조
  destination_cidr_block = "0.0.0.0/0"  # 기본 라우트 설정
  gateway_id             = aws_internet_gateway.EOF-igw.id  # 인터넷 게이트웨이 ID 참조
}

# EIP(Elastic IP) 생성
resource "aws_eip" "EOF-nat-eip" {
  domain     = "vpc" # VPC 사용 설정
  depends_on = [aws_internet_gateway.EOF-igw]  # 인터넷 게이트웨이 생성 후 실행
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "EOF-nat" {
  allocation_id = aws_eip.EOF-nat-eip.id  # EIP 할당 ID 참조
  subnet_id     = aws_subnet.public-a.id  # 퍼블릭 서브넷 ID 참조
  depends_on    = [aws_internet_gateway.EOF-igw]  # 인터넷 게이트웨이 생성 후 실행
}

# 프라이빗 라우팅 테이블 생성
resource "aws_route_table" "EOF-private-route-table" {
  vpc_id = aws_vpc.EOF-vpc.id  # VPC ID 참조
  tags = {
    Name = "private"  # 태그 설정
  }
}

# 프라이빗 라우트 설정
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.EOF-private-route-table.id  # 라우팅 테이블 ID 참조
  destination_cidr_block = "0.0.0.0/0"  # 기본 라우트 설정
  nat_gateway_id         = aws_nat_gateway.EOF-nat.id  # NAT 게이트웨이 ID 참조
}

# 퍼블릭 서브넷과 라우팅 테이블 연결 (subnet-a)
resource "aws_route_table_association" "public_subneta_association" {
  subnet_id      = aws_subnet.public-a.id  # 퍼블릭 서브넷 ID 참조
  route_table_id = aws_vpc.EOF-vpc.main_route_table_id  # 라우팅 테이블 ID 참조
}

# 퍼블릭 서브넷과 라우팅 테이블 연결 (subnet-c)
resource "aws_route_table_association" "public_subnetb_association" {
  subnet_id      = aws_subnet.public-c.id  # 퍼블릭 서브넷 ID 참조
  route_table_id = aws_vpc.EOF-vpc.main_route_table_id  # 라우팅 테이블 ID 참조
}

# 프라이빗 서브넷과 라우팅 테이블 연결 (subnet-a)
resource "aws_route_table_association" "private_subneta_association" {
  subnet_id      = aws_subnet.private-a.id  # 프라이빗 서브넷 ID 참조
  route_table_id = aws_route_table.EOF-private-route-table.id  # 라우팅 테이블 ID 참조
}

# 프라이빗 서브넷과 라우팅 테이블 연결 (subnet-c)
resource "aws_route_table_association" "private_subnetb_association" {
  subnet_id      = aws_subnet.private-c.id  # 프라이빗 서브넷 ID 참조
  route_table_id = aws_route_table.EOF-private-route-table.id  # 라우팅 테이블 ID 참조
}

# EKS 클러스터 모듈 사용
module "eks" {
  source          = "terraform-aws-modules/eks/aws"  # EKS 모듈 소스
  version         = "18.26.6"  # EKS 모듈 버전
  cluster_name    = "EOF-cluster"  # 클러스터 이름
  cluster_version = "1.28"  # 쿠버네티스 버전
  vpc_id          = aws_vpc.EOF-vpc.id  # VPC ID 참조
  subnet_ids = [
    aws_subnet.public-a.id,
    aws_subnet.public-c.id,
    aws_subnet.private-a.id,
    aws_subnet.private-c.id
  ]
  eks_managed_node_groups = {
    default_node_group = {
      min_size       = 2  # 최소 노드 수
      max_size       = 3  # 최대 노드 수
      desired_size   = 2  # 원하는 노드 수
      instance_types = ["t3.small"]  # 인스턴스 유형
    }
  }
  tags = {
    Environment = "dev"  # 태그 설정 (환경)
    Terraform   = "true"  # 태그 설정 (Terraform)
  }
  cluster_endpoint_private_access = true  # 프라이빗 엔드포인트 접근 설정
}

# EKS 클러스터 보안 그룹 규칙 추가 (클러스터 액세스 허용)
resource "aws_security_group_rule" "eks_cluster_add_access" {
  security_group_id = module.eks.cluster_security_group_id  # 클러스터 보안 그룹 ID 참조
  type              = "ingress"  # 인그레스 규칙
  from_port         = 0  # 시작 포트
  to_port           = 0  # 종료 포트
  protocol          = "-1"  # 모든 프로토콜
  cidr_blocks       = ["10.0.0.0/16"]  # 허용할 CIDR 블록
}

# EKS 노드 보안 그룹 규칙 추가 (노드 액세스 허용)
resource "aws_security_group_rule" "eks_node_add_access" {
  security_group_id = module.eks.node_security_group_id  # 노드 보안 그룹 ID 참조
  type              = "ingress"  # 인그레스 규칙
  from_port         = 0  # 시작 포트
  to_port           = 0  # 종료 포트
  protocol          = "-1"  # 모든 프로토콜
  cidr_blocks       = ["10.0.0.0/16"]  # 허용할 CIDR 블록
}
