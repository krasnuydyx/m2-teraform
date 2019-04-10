/*resource "aws_acm_certificate" "web-cert" {
	domain_name = "your-domain.com"
	validation_method = "NONE"
	subject_alternative_names = [ "your_domain2", "your_domain3" ]
    tags {
      Name = "web-cert"
      Application = "Magento"
      Environment = "TST"
      TechOwnerEmail = "your_email@your_domain"
    }
}*/

resource "tls_private_key" "web-cert" {
  algorithm = "RSA"
}
resource "tls_self_signed_cert" "web-cert" {
  key_algorithm   = "${tls_private_key.web-cert.algorithm}"
  private_key_pem = "${tls_private_key.web-cert.private_key_pem}"
  # Certificate expires after 1 year.
  validity_period_hours = 240
  #validity_period_hours = 24
  # Generate a new certificate if Terraform is run within 10
  # days of the certificate's expiration time.
  #early_renewal_hours = 240
  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]
  #dns_names = ["sampledomain.com", "www.sampledomain.com"]
  subject {
      common_name  = "${aws_alb.alb-web.dns_name}"
      organization = "Your Inc"
  }
}
resource "aws_acm_certificate" "web-cert" {
  private_key      = "${tls_private_key.web-cert.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.web-cert.cert_pem}"
  tags {
    Name = "web-cert"
    Application = "Magento"
    TechOwnerEmail = "your_email@your_domain"
    Environment = "TST"
  }
}
