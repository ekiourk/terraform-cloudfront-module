variable "app_version" {}
variable "bucket_domain_name" {}
variable "app_origin_id" {}
variable "additional_aliases" {
  type = "list"
  default = []
}
variable "config_behavior_path_pattern" {
  default = "config.*.json"
}
variable "environment" {}
variable "aws_hosted_zone_id" {}
variable "route53_name" {}
variable "route53_record" {default = true}
variable "acm_certificate_arn" {}
