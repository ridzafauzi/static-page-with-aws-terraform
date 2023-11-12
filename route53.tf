
output "distribution-id1" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

output "distribution-domain-name1" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}


#create A record

resource "aws_route53_record" "A" {
    depends_on = [aws_cloudfront_distribution.s3_distribution]
    
    name    = "sweetserenity.net"	# The name of the record
    type    = "A"
    zone_id = "Z0117675JN91A026UUOQ"	#The ID of the hosted zone to contain this record

    alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name 	#DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone
    zone_id = "Z2FDTNDATAQYW2"		#Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone. all cloudfront hosted zone id is Z2FDTNDATAQYW2
    evaluate_target_health = false
  }
}

