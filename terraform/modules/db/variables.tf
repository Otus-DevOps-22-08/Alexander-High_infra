variable "public_key_path" {
  # Описание переменной
  type        = string
  description = "Path to the public key used for ssh access"
}
variable "db_disk_image" {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}
variable "subnet_id" {
  description = "subnet_id"
}
variable "count_num" {
  description = "count of VM"
  default     = "1"
}
