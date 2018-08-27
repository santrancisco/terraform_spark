resource "aws_instance" "master" {
  ami                  = "${var.image_id}"
  instance_type        = "${var.master_instance_type}"

  tags {
    Name = "${var.name}-spark_master"
  }
  iam_instance_profile = "${aws_iam_instance_profile.this.name}"
  subnet_id                   = "${var.subnet_id}"
  key_name                    = "${var.key_name}"
  user_data            = "${data.template_file.master_user_data.rendered}"
  vpc_security_group_ids = [
    "${var.security_groups_ids}",
    "${aws_security_group.this.id}",
  ]
}

// USER_DATA script to bootstrap spark master node 
data "template_file" "master_user_data" {
  template = "${file("${path.module}/templates/spark_master_bootstrap.sh")}"
  vars {
    spark_version        = "${var.spark_version}"
    autoscalinggroupname = "${aws_autoscaling_group.this.name}"
    fleet_private_key    = "${var.fleet_private_key}"
    # ecs_logging       = "${var.ecs_logging}"
    # cluster_name      = "${aws_ecs_cluster.cluster.name}"
    # custom_userdata   = "${var.custom_userdata}"
    # efs_dns_name      = "${aws_efs_mount_target.ecs_persistent.0.dns_name}"
  }
}

