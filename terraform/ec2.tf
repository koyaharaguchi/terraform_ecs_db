data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended"
}

resource "aws_instance" "db_cluster_instance" {
  ami                    = jsondecode(data.aws_ssm_parameter.ecs_ami.value).image_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.db.id, aws_security_group.ssh.id]
  iam_instance_profile   = module.ec2_container_service_role.iam_instance_profile_name
  subnet_id              = module.vpc.public_subnets[0]
  key_name               = aws_key_pair.db_instance_key.id

  root_block_device {
    volume_type           = "gp3"
    volume_size           = "30"
    delete_on_termination = true
    encrypted             = false
  }

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.db.name} >> /etc/ecs/ecs.config;
EOF
}

resource "aws_eip" "db_cluster_instance" {
  instance = aws_instance.db_cluster_instance.id
  vpc      = true
}
