variable "environment"{
    default="dev"
}

variable "project"{
    default="expense"
}

variable "frontend_sg_name"{
  default="frontend_sg"
}

variable "frontend_sg_description"{
  default="Created sg for frontend"
}

variable "backend_sg_name"{
  default="backend_sg"
}

variable "backend_sg_description"{
  default="Created sg for backend"
}

variable "database_sg_name"{
  default="database_sg"
}

variable "database_sg_description"{
  default="Created sg for database"
}

variable "bastion_sg_name"{
  default="bastion_sg"
}

variable "bastion_sg_description"{
  default="Created sg for bastion"
}

variable "backend_ports"{
  default=[22, 8080]
}

variable "mysql_ports"{
  default=[22, 3306]
}
