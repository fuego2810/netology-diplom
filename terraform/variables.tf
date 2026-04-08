variable "sa_key_file" {
  description = "Path to service account key JSON file"
  type        = string
  default     = "../key.json"
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "default_zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "ubuntu_image_id" {
  description = "Ubuntu 22.04 LTS image ID"
  type        = string
  default     = "fd81radk00nmm2jpqh94"
}
