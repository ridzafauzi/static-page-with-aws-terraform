resource "aws_cloudfront_distribution" "s3_distribution" {
  
  depends_on = [aws_acm_certificate.site_cert, aws_acm_certificate_validation.site_cert_validate]

  origin {
    domain_name              = "sweetserenity.net.s3-website-ap-southeast-2.amazonaws.com"
    origin_id                = "sweetserenity.net-origin"
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1"]
    }
  }

  enabled = true
  wait_for_deployment = false
  aliases = ["sweetserenity.net"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "sweetserenity.net-origin"

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    #acm_certificate_arn = "arn:aws:acm:us-east-1:176966444446:certificate/f28e0a3f-c457-44bb-af52-375a48ae5f7c"
    acm_certificate_arn = aws_acm_certificate.site_cert.arn
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


