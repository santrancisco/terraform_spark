resource "aws_security_group" "this" {
  name        = "${var.name}-spark"
  vpc_id      = "${var.vpc_platform_id}"
  description = "${var.name}-spark security group"
  // All the components of the spark cluster can freely communicate with each other.
egress {
  protocol  = "-1"
  from_port = "0"
  to_port   = "0"
  self      = true
}
ingress {
  protocol  = "-1"
  from_port = "0"
  to_port   = "0"
  self      = true
}
}

output "security_group_id" {
    value = "${aws_security_group.this.id}"
}
