output "website_url" {
  value       = module.alb.alb_dns_name
  description = "The HTTP endpoint for the ALB"
}
