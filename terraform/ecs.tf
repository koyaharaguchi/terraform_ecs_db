resource "aws_ecs_cluster" "db" {
  name = "db"
}

resource "aws_ecs_task_definition" "db" {
  family                   = "db"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn

  container_definitions = jsonencode([
    {
      "name" : "db",
      "image" : "mysql:8.0",
      "memory" : 512,
      "essential" : true,
      "portMappings" : [
        {
          "hostPort" : 3306,
          "containerPort" : 3306,
          "protocol" : "tcp"
        }
      ],
      "environmentFiles" : [
        {
          "value" : "${aws_s3_bucket.db.arn}/${aws_s3_object.db_env.id}",
          "type" : "s3"
        }
      ],
      "mountPoints" : [
        {
          "sourceVolume" : "db-store",
          "containerPath" : "/var/lib/mysql",
        }
      ]
    }
  ])

  volume {
    name = "db-store"
    docker_volume_configuration {
      scope         = "shared"
      autoprovision = true
    }
  }
}

resource "aws_ecs_service" "db" {
  name                               = "db"
  cluster                            = aws_ecs_cluster.db.id
  task_definition                    = aws_ecs_task_definition.db.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
}
