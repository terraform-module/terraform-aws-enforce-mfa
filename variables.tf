variable "policy_name" {
  default     = "managed-force-mfa-policy"
  description = "The name of the policy."
  type        = string
}

variable "account_id" {
  default     = "*"
  description = "Account identification. (Optional, default '*')"
  type        = string
}

variable "manage_own_password_without_mfa" {
  default     = true
  description = "Whethehr password management without mfa is allowd"
  type        = bool
}

variable "manage_own_access_keys" {
  default     = false
  description = "Allow a new AWS secret access key and corresponding AWS access key ID for the specified user."
  type        = bool
}

variable "manage_own_signing_certificates" {
  default     = false
  description = "Allow managing signing certificates."
  type        = bool
}

variable "manage_own_ssh_public_keys" {
  default     = false
  description = "Allow managing ssh public keys."
  type        = bool
}

variable "manage_own_git_credentials" {
  default     = false
  description = "Allow managing git credentials."
  type        = bool
}


variable "groups" {
  default     = []
  description = "Enforce MFA for the members in these groups. (Optional, default '[]')"
  type        = list(string)
}

variable "path" {
  default     = "/"
  description = "Path in which to create the policy. (Optional, default '/')"
  type        = string
}

