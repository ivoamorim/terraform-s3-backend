variable "region" {
  description = "AWS Region"
  type        = "string"
}

variable "project" {
  description = "The unique project name for tfstate"
  type        = "string"
  default     = "Example"
}

variable "environment" {
  description = "The environment for tfstate"
  type        = "string"
  default     = "Integration"
}

provider "aws" {
  region = "${var.region}"
}

module "backend" {
  source = "../modules/backend"

  project     = "${var.project}"
  environment = "${var.environment}"
}
