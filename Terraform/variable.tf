variable "region" {
  type = string
  default = "ap-south-1"
}
variable "avail_zone" {
  type = string
  default = "ap-south-1a"
}


variable "ami_id" {
  description = "The AMI ID for the desired operating system based on list selected"
  type        = map(string)
  default     = {
    windows   = "ami-064607abed305477a" # Replace with the actual Windows AMI ID
    linux     = "ami-02a2af70a66af6dfb" # Replace with the actual Linux AMI ID
    ubuntu    = "ami-0287a05f0ef0e9d9a" # Replace with the actual Ubuntu AMI ID
  }
}
variable "os_type" {
  type = string
  description = "Provide the OS details for server creation [windows/linux/ubuntu]"

}
