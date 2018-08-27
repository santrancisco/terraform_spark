resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-spark"
  acl    = "private"
  tags {
    Name        = "${var.name}-spark"
  }
}

resource "aws_s3_bucket_policy" "this"{
   bucket = "${aws_s3_bucket.this.id}"
   policy = <<POLICY
{
"Version": "2012-10-17",
"Statement": [
    {
        "Sid": "AddCannedAcl",
        "Effect": "Allow",
        "Principal": {
            "AWS": "${aws_iam_role.this.arn}"
        },
        "Action": [
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::${var.name}-spark/*"
    },
    {
        "Effect": "Allow",
        "Principal": {
            "AWS": "${aws_iam_role.this.arn}"
        },
        "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation"
        ],
        "Resource": "arn:aws:s3:::${var.name}-spark"
    }
]
}
POLICY
}
