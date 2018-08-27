
resource "aws_iam_role" "this" {
  name = "${var.name}-spark"
    assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
    {
    "Action": "sts:AssumeRole",
    "Principal": {
        "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": "AllowAssumeRole"
    }
]
}
EOF
}
resource "aws_iam_role_policy" "this" {
  name = "SparkMasterReadAccess"
  role = "${aws_iam_role.this.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowReadAutoScaling",
        "Effect": "Allow",
        "Action": [
            "autoscaling:DescribeAutoScalingInstances",
            "ec2:DescribeInstances",
            "ec2:DescribeInstanceAttribute",
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeLaunchConfigurations",
            "autoscaling:DescribeLoadBalancers",
            "ec2:DescribeInstanceStatus"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}

# This is the instance profile that we use to attach to all slave and master nodes to access this S3 bucket
resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-spark"
  role = "${aws_iam_role.this.name}"
}