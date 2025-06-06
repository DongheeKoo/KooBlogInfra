resource "aws_db_instance" "main" {
  identifier = var.identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted

  db_name  = var.db_name
  username = var.username
  password = var.password

  db_subnet_group_name   = aws_db_subnet_group.main.id
  vpc_security_group_ids = [aws_security_group.main.id]
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az

  backup_retention_period      = var.backup_retention_period
  monitoring_interval          = var.monitoring_interval
  performance_insights_enabled = var.performance_insights_enabled
  deletion_protection          = var.deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot

  tags = {
    Name      = var.identifier
    ManagedBy = "Terraform"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name      = "${var.identifier}-subnet-group"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "main" {
  name   = "${var.identifier}-security-group"
  vpc_id = var.vpc_id

  tags = {
    Name      = "${var.identifier}-security-group"
    ManagedBy = "Terraform"
  }
}
