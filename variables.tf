variable "environment" {
  description = "ex: test/dev/prod; (add *environment = test/dev/prod* in your .tfvars only if stage/env is applicable)"
  default     = ""
}

variable "namespace" {
  description = "project name"
  type        = string
}

