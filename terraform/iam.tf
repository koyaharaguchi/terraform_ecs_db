data "aws_iam_policy" "ec2_container_service" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

module "ec2_container_service_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.2.0"

  role_name               = "ec2_container_service"
  create_role             = true
  create_instance_profile = true
  role_requires_mfa       = false

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  custom_role_policy_arns = [
    data.aws_iam_policy.ec2_container_service.arn
  ]
}

data "aws_iam_policy" "ecs_task_execution_role" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "s3_readonly_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

module "ecs_task_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.2.0"

  role_name         = "ecs_task_execution"
  create_role       = true
  role_requires_mfa = false

  trusted_role_services = [
    "ecs-tasks.amazonaws.com"
  ]

  custom_role_policy_arns = [
    data.aws_iam_policy.ecs_task_execution_role.arn,
    data.aws_iam_policy.s3_readonly_access.arn,
  ]
}
