variable "cloud_id" {
  description = "cloud_id"
}
variable "folder_id" {
  description = "folder_id"
}
variable "zone" {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable "public_key_path" {
  # Описание переменной
  type        = string
  description = "Path to the public key used for ssh access"
}
variable "private_key_path" {
  type        = string
  description = "Path to the private key used for ssh access"
}
variable "image_id" {
  description = "image_id"
}
variable "subnet_id" {
  description = "subnet_id"
}
variable "service_account_key_file" {
  description = "key .json"
}
variable "count_num" {
  description = "count of VM"
  default     = "1"
}
