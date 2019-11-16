# usage getip.sh <cluster-name>
# see your terraform file
#
# resource "aws_ecs_cluster" "main" {
#  name = "<cluster-name>"
# }
cluster_grep="(?<=task/${1}/)\w+"
task_arn=$(aws ecs list-tasks --cluster selenium-cluster | grep -oP "${cluster_grep}")
network_interface_id="eni-"$(aws ecs describe-tasks --cluster ${1} --task ${task_arn} | grep -oP '(?<=eni-)\w+')
aws ec2 describe-network-interfaces --network-interface-ids ${network_interface_id} | grep -P '(?<=PublicIp)' | grep -m1 "" | grep -oE '[^ ]+$' | grep -oE '[^";]+'
