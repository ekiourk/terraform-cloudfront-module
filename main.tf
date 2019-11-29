
resource "aws_cloudfront_distribution" "react_app" {
  origin {
    domain_name = var.bucket_domain_name
    origin_id   = var.app_origin_id
    origin_path = "/${var.app_version}"
  }

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = "${var.app_origin_id}/config"
    origin_path = "/${var.app_version}/config/${var.environment}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = concat(list(var.app_origin_id), var.additional_aliases)

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.app_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "*.js.map"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.app_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    trusted_signers = ["self"]
    compress = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = var.config_behavior_path_pattern
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.app_origin_id}/config"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code = "404"
    error_caching_min_ttl = "3600"
    response_code = "200"
    response_page_path = "/index.html"
  }

  tags = {
    Environment = var.environment
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
}

resource "aws_route53_record" "react_app" {
  count = var.route53_record ? 1 : 0

  zone_id = var.aws_hosted_zone_id
  name = var.route53_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.react_app.domain_name
    zone_id = aws_cloudfront_distribution.react_app.hosted_zone_id
    evaluate_target_health = false
  }
}
