variable "admin_username" {}

variable "admin_password" {}

variable "dept_name" {}

variable "team_name" {}

variable "app_name" {}

variable "app_env" {}

variable "count" {
  default = 2
}

variable "default_tags" { 
    type = "map" 
    default = { 
        department: "${var.dept_name}",
        team: "${var.team_name}",
        app: "${var.app_name}",
        env: "${var.app_env}"
  } 
}