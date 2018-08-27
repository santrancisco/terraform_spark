#!/bin/bash

set -xe

## Slave node bootstrap code here

#determine the current region and place into REGION
EC2AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION="`echo \"$EC2AZ\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
export EC2USERHOME="/home/ec2-user"

## Installing JAVA and git
sudo yum install -y java-devel

## Download and extract Spark
mkdir -p $EC2USERHOME/spark
curl --location --output $EC2USERHOME/spark.tgz "https://www.apache.org/dyn/closer.lua?action=download&filename=spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop2.7.tgz"
tar xfz $EC2USERHOME/spark.tgz -C $EC2USERHOME/spark --strip-component 1
chown -R ec2-user:ec2-user $EC2USERHOME/spark

## Build spark 

## Making soft links and setting SPARK_HOME environment for every user to use the tool
for f in $(find $EC2USERHOME/spark/bin -type f -executable -not -name '*.cmd'); do
    sudo ln -s "$f" "/usr/local/bin/$(basename $f)"
done
echo "export SPARK_HOME='$EC2USERHOME/spark'" >> /etc/bashrc

## Creating the fleet private key used by nodes to talk to each others
cat > $EC2USERHOME/.ssh/id_rsa << EOF
${fleet_private_key}
EOF
chown ec2-user:ec2-user $EC2USERHOME/.ssh/id_rsa
chmod 400 $EC2USERHOME/.ssh/id_rsa

# Getting the public key and push it into authorized_keys
# I'm guessting this should only be require by slave nodes? But we keep it in for now.
ssh-keygen -y -f $EC2USERHOME/.ssh/id_rsa >> $EC2USERHOME/.ssh/authorized_keys

# Start our slave node and point it to our master node!
su ec2-user -c "$EC2USERHOME/spark/sbin/start-slave.sh spark://${master_address}:7077"
