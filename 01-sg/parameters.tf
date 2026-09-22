resource "aws_ssm_parameter" "sg-id" {
  name="${var.project}-${var.environment}/frontend_sg_id"
  type="String"
  value=module.aws_security_group.sg_id
}

