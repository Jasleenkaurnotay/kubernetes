# Query existing ACM cerificate
data "aws_acm_certificate" "issued_https_cert" {
    domain = var.cert_domain_name
    statuses = ["ISSUED"]  
}

# Query Route53 hosted zone tied to the specific domain
data "aws_route53_zone" "dns_zone" {
    name = "${var.domain_name}."
    private_zone = false
}

# Create Route 53 alias entry mapping the domain name to the ALB
resource "aws_route53_record" "alb_route_record" {
    zone_id = data.aws_route53_zone.dns_zone.zone_id
    name = var.route53_record_name
    type = "A"

    alias {
        name = data.aws_lb.ingress_alb.dns_name
        zone_id = data.aws_lb.ingress_alb.zone_id
        evaluate_target_health = true
    }
  
}