
output "aws_cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.react_app.id
}

output "aws_cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.react_app.domain_name
}

output "aws_cloudfront_distribution_hosted_zone_id" {
  value = aws_cloudfront_distribution.react_app.hosted_zone_id
}
