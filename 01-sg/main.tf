module "frontend" {
    source = "git::https://github.com/Anjuma11/terraform-aws-securitygroup.git?ref=main"
    project=var.project
    environment= var.environment
    sg_name=var.frontend_sg_name
    sg_description=var.frontend_sg_description
    vpc_id=local.vpc_id
}

module "backend"{
    source="git::https://github.com/Anjuma11/terraform-aws-securitygroup.git?ref=main"
    project=var.project
    environment=var.environment
    
    sg_name=var.backend_sg_name
    sg_description=var.backend_sg_description
    vpc_id=local.vpc_id
}

module "mysql"{
     source="git::https://github.com/Anjuma11/terraform-aws-securitygroup.git?ref=main"
     project=var.project
     environment=var.environment

     sg_name=var.database_sg_name
     sg_description=var.database_sg_description
     vpc_id=local.vpc_id
}

module "bastion"{
     source="git::https://github.com/Anjuma11/terraform-aws-securitygroup.git?ref=main"
     project=var.project
     environment=var.environment

     sg_name=var.bastion_sg_name
     sg_description=var.bastion_sg_description
     vpc_id=local.vpc_id
}

#BASTION
#bastion should accept connections from laptop
resource "aws_security_group_rule" "bastion-laptop" {
    type="ingress"
    from_port=22
    to_port=22
    cidr_blocks="[0.0.0.0]"
    protocol="ssh"

    security_group_id=module.bastion.sg_id
}
#FRONTEND
#frontend should accept connection from bastion.
resource "aws_security_group_rule" "frontend_bastion" {
    type="ingress"
    from_port=22
    to_port=22
    protocol="ssh"

    security_group_id=module.frontend.sg_id
    source_security_group_id=module.bastion.sg_id
}

#BACKEND
#backend should accept connection from bastion.
resource "aws_security_group_rule" "backend_bastion" {
    count=length(var.backend_ports)
    type="ingress"
    from_port=var.backend_ports[count.index]
    to_port=var.backend_ports[count.index]
    protocol="tcp"

    security_group_id=module.backend.sg_id
    source_security_group_id=module.bastion.sg_id
}

#backend should accept connections from frontend
resource "aws_security_group_rule" "backend_frontend" {
    type="ingress"
    from_port=8080
    to_port=8080
    protocol="tcp"

    security_group_id=module.backend.sg_id
    source_security_group_id=module.frontend.sg_id
} 

#MYSQL
#mysql accepting connection from bastion
resource "aws_security_group_rule" "mysql_bastion" {
    count=length(var.mysql_ports)
    type="ingress"
    from_port=var.mysql_ports[count.index]
    to_port=var.mysql_ports[count.index]
    
    protocol="tcp"

    security_group_id=module.mysql.sg_id
    source_security_group_id=module.bastion.sg_id
}

#mysql accepting connections from backend
resource "aws_security_group_rule" "mysql_backend"{
    type="ingress"
    from_port=3306
    to_port=3306
    protocol="tcp"

    security_group_id=module.mysql.sg_id
    source_security_group_id=module.backend.sg_id
}


