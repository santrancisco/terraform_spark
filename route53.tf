resource "aws_route53_zone" "this" {
  vpc_id  = "${var.vpc_platform_id}" // Private to this VPC
  name    = "${var.name}-spark."
  comment = "${var.name}-spark dns zone"
}

// The use of route53 record for master node is to avoid circle dependency 
// between the masternode ec2 and the ASG.
resource "aws_route53_record" "master" {
#   // This is the DNS server used throughout the VPC, so obviously you can't even query this
#   // without knowing where the DNS server is already.  But for scripts on machines that are
#   // already set up, `dig +short ns.net.cld.internal.` is easier than parsing /etc/resolv.conf
  zone_id = "${aws_route53_zone.this.zone_id}"
  name    = "master.${var.name}-spark."
  type    = "A"
  ttl     = 600
  records = ["${aws_instance.master.private_ip}"]
}
