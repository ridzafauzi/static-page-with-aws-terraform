variable "root_domain_name" {
  type    = string
  default = "sweetserenity.net"
}

variable "hosted-zone-id" {
  type    = string
  default = "Z0117675JN91A026UUOQ"
}


provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

#Create an ACM Certificate

resource "aws_acm_certificate" "site_cert" {
  depends_on =[aws_s3_bucket_policy.example-policy]
  domain_name       = var.root_domain_name
  validation_method = "DNS"
  provider = aws.virginia
  lifecycle {
    create_before_destroy = true
  }
}

#Add CNAME records

resource "aws_route53_record" "site_cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.site_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.hosted-zone-id
  ttl = 60
}

output "example" {
  value = aws_acm_certificate.site_cert.arn
}

output "example1" {
  value = aws_route53_record.site_cert_dns.fqdn
}

#Validate the certificcate

resource "aws_acm_certificate_validation" "site_cert_validate" {
  provider = aws.virginia
  certificate_arn = aws_acm_certificate.site_cert.arn
  validation_record_fqdns = [aws_route53_record.site_cert_dns.fqdn]
  depends_on = [aws_acm_certificate.site_cert]
}
      
