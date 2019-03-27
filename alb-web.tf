resource "aws_alb" "alb-web" {
  name = "alb-web"
  internal = false
  load_balancer_type = "application"
  subnets = ["${aws_subnet.Public-1a.id}", "${aws_subnet.Public-1b.id}"]
  security_groups = ["${aws_security_group.sg-elb.id}", "${aws_security_group.sg-ssh.id}", "${aws_security_group.sg-elb-ephemeral.id}"]
  enable_cross_zone_load_balancing = true
  tags {
      Name = "mage-vpc-alb-web"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
  }
}

resource "aws_alb_listener" "alb-web-80" {
  load_balancer_arn = "${aws_alb.alb-web.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb-web-tg.arn}"
  }
}
resource "aws_alb_listener" "alb-web-443" {
  load_balancer_arn = "${aws_alb.alb-web.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.web-cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb-web-tg.arn}"
  }
}
resource "aws_alb_target_group" "alb-web-tg" {
  name = "alb-web-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.mage-vpc.id}"
  health_check {
    interval            = 60
    path                = "/health_check.php"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 10
    protocol            = "HTTP"
    matcher             = "200"
  }
  tags {
      Name = "alb-web"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
  }
}

resource "aws_alb" "alb-web-ssh" {
  name = "alb-web-ssh"
  internal = false
  load_balancer_type = "network"
  subnets = ["${aws_subnet.Public-1a.id}", "${aws_subnet.Public-1b.id}"]
  enable_cross_zone_load_balancing = true
  #internal = true
  tags {
      Name = "mage-vpc-alb-web-ssh"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
  }
}
resource "aws_alb_listener" "alb-web-ssh-22" {
  load_balancer_arn = "${aws_alb.alb-web-ssh.arn}"
  port              = "22"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb-web-ssh-tg.arn}"
  }
}
resource "aws_alb_target_group" "alb-web-ssh-tg" {
  name = "alb-web-ssh-tg"
  port = 22
  protocol = "TCP"
  vpc_id = "${aws_vpc.mage-vpc.id}"
  tags {
      Name = "alb-web-ssh-tg"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
  }
}

output "Web ELB address" {
    value = "${aws_alb.alb-web.dns_name}"
}
output "SSH ELB address" {
    value = "${aws_alb.alb-web-ssh.dns_name}"
}
