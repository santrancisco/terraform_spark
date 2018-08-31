variable "vpc_platform_id" {}
variable "account_id" {
  description = "Account id of AWS account"  
}
variable "key_name" {
  description = "The ssh key used to access these nodes"
}
variable "name" {
  description = "The name of our new spark cluster"
  default = "bigdata"
}

variable "fleet_private_key" {
  description = "The private keys used to communicate between ec2 mach"
  
}


variable "slave_asg_max_size" {
  description = "The maximum size of the auto scale group"
}

variable "slave_asg_min_size" {
  description = "The minimum size of the auto scale group"
}

# variable "slave_asg_desired_capacity" {
#   default = 0
#   description = "The number of Amazon EC2 instances that should be running in the group"
# }

variable "evaluation_periods" {
  default = "2"
  description = "The number of periods over which data is compared to the specified threshold."
}

variable "period" {
  default = "120"
  description = "The period in seconds over which the specified statistic is applied."
}

variable "threshold" {
  default = "85"
  description = "The value against which the Average CPUUtilization statistic is compared to."
}

variable "cooldown" {
  default = "300"
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start."
}

variable "scaling_adjustment" {
  default = "2"
  description = "The number of instances by which to scale. adjustment_type determines the interpretation of this number."
}

variable master_instance_type {
  description = "Instance type for our master node"
  default = "m3.medium"
}
variable slave_instance_type {
  description = "Instance type for our slave nodes"
  default = "m3.medium"
}

variable "image_id" {
  description = "The AMI use to create our nodes"   
  default = "ami-0b1a7767bce29a01a"
}

variable "ebs_optimized" {
  description = "If true, the slave instances will be EBS-optimized"
  default = false
}


variable "subnet_id" {
  description = "The subnet that we want the spark cluster to be deployed"  
}

variable "security_groups_ids" {
  type        = "list"
  description = "Security group IDs for spark"
  default = []
}

variable "spot_price" {
  description = "The maximum bid you are willing to pay for spot instances"
  default = "0.0045"
}

variable "spark_version" {
  description = "Released version of spark you want to install fetches from github"
  # Find version you want to download here https://spark.apache.org/downloads.html
  default = "2.3.1"
}

variable "hadoop_version" {
  description = "Hadoop version you want to install on all machines"
  # Find version of hadoop here http://apache.mirror.serversaustralia.com.au/hadoop/common/
  default = "2.8.4"
}
