resource "tls_private_key" "key_gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_s3_object" "private_key" {
  bucket  = var.ssh_bucket.bucket_name
  key     = "${var.instance_name}.pem"
  content = tls_private_key.key_gen.private_key_openssh
}

resource "aws_key_pair" "key" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.key_gen.public_key_openssh
}

resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2_instance_s3_access_role-${var.instance_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3_read" {
  name = "s3_read_policy-${var.instance_name}"
  role = aws_iam_role.ec2_s3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::${var.web_service_bucket.bucket_name}",
          "arn:aws:s3:::${var.web_service_bucket.bucket_name}/*",
        ],
      },

    ]
  })
}

resource "aws_iam_role_policy" "sns_access" {
  name = "sns_access_policy-${var.instance_name}"
  role = aws_iam_role.ec2_s3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sns:Publish",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sns:CreateTopic"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "cloudwatch_logs_policy-${var.instance_name}"
  role = aws_iam_role.ec2_s3_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:log-group:${var.log_group_name}:*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  role = aws_iam_role.ec2_s3_access.name
}

resource "aws_instance" "ec2" {
  count = var.instance_count

  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = aws_key_pair.key.key_name
  subnet_id            = var.subnet_id
  ipv6_address_count   = var.enable_ipv6 ? 1 : 0
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [aws_security_group.sg.id]

  user_data = <<-EOF
    #!/bin/bash
    if command -v apt-get &>/dev/null; then
      sudo curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
      sudo apt-get install -y nodejs
    elif command -v yum &>/dev/null; then
      sudo  curl -sL https://rpm.nodesource.com/setup_20.x | sudo bash -
      sudo yum install -y nodejs
    fi

    sudo mkdir -p /home/ec2-user/app
    cd /home/ec2-user/app

    if ! aws s3 sync s3://${var.web_service_bucket.bucket_name}/ .; then
      echo "Failed to sync from S3"
      exit 1
    fi

    ${join("", formatlist("echo '%s=%s' >> .env\n", keys(var.app_env_vars), values(var.app_env_vars)))}

    sudo npm install
    sudo npm install pm2@latest -g
    sudo bash -c 'cd /home/ec2-user/app && pm2 start ecosystem.config.js'
  EOF

  tags = {
    Name = "${var.instance_name}"
  }
}

resource "aws_security_group" "sg" {
  name        = "${var.instance_name}-sg"
  vpc_id      = var.vpc_id
  description = "Managed by Terraform"

  dynamic "ingress" {
    for_each = var.security_group_rules.ingress
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.security_group_rules.egress
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }
}

resource "aws_lb_target_group_attachment" "tga" {
  for_each = { for idx, inst in aws_instance.ec2 : idx => inst.id }

  target_group_arn = var.alb_target_group_arn
  target_id        = each.value
  port             = var.alb_listener_port

  depends_on = [aws_security_group.sg]
}

