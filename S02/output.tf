output "vpc_id" {
  value = aws_vpc.vpc_1.id
}

output "availability_zones" {
  value = data.aws_availability_zones.az.names
}

output "subnet_ids" {
  value = {
    first  = aws_subnet.public.id
    second = aws_subnet.private.id
  }
}

output "public_instance_ip" {
  value = {
    public = aws_instance.public_instance.public_ip 
    private = aws_instance.public_instance.private_ip
}
  }


output "private_instance_ip" {
  value = aws_instance.public_instance.private_ip
}

# resource "local_file" "outputs_json" {
#   filename = "outputs.json"
#   content = jsonencode({
#     vpc_id               = aws_vpc.vpc_1.id
#     availability_zones   = data.aws_availability_zones.az.names
#     subnet_ids           = {
#       first  = aws_subnet.public.id
#       second = aws_subnet.private.id
#     }
#     public_instance_ip   = {
#       public  = aws_instance.public_instance.public_ip
#       private = aws_instance.public_instance.private_ip
#     }
#     private_instance_ip  = aws_instance.private_instance.private_ip
#   })
# }
