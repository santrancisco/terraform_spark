
# Launch configuration for slave instances
resource "aws_launch_configuration" "this" {
  name_prefix                 = "${var.name}_lc_"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.slave_instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.this.name}"
  key_name                    = "${var.key_name}"
  security_groups             = [
      "${var.security_groups_ids}",
      "${aws_security_group.this.id}",
      ]
  user_data                   = "${data.template_file.slave_user_data.rendered}"
  spot_price                  = "${var.spot_price}"
  ebs_optimized               = "${var.ebs_optimized}"
  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}


# Autoscaling group for slave instances
resource "aws_autoscaling_group" "this" {
  // When launch configuration changes, we want to create new autoscaling group with unique name
  name                 = "${var.name}_${aws_launch_configuration.this.name}_asg"
  max_size             = "${var.slave_asg_max_size}"
  min_size             = "${var.slave_asg_min_size}"
  desired_capacity     = "${var.slave_asg_desired_capacity}"
  launch_configuration = "${aws_launch_configuration.this.id}"
  vpc_zone_identifier  = ["${var.subnet_id}"]

  tag {
    key                 = "Name"
    value               = "${var.name}_${aws_launch_configuration.this.name}_asg"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// USER_DATA script to bootstrap all spark slave instances part of the spark clusterl
data "template_file" "slave_user_data" {
  template = "${file("${path.module}/templates/spark_slave_bootstrap.sh")}"
  vars {
    spark_version        = "${var.spark_version}"
    fleet_private_key    = "${var.fleet_private_key}"
    master_address       = "master.${var.name}-spark."
    # ecs_logging       = "${var.ecs_logging}"
    # cluster_name      = "${aws_ecs_cluster.cluster.name}"
    # custom_userdata   = "${var.custom_userdata}"
    # efs_dns_name      = "${aws_efs_mount_target.ecs_persistent.0.dns_name}"
  }
}

output "asg_id" {
  value = "${aws_autoscaling_group.this.id}"
}