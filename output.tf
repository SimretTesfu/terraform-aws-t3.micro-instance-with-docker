output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable."
  value = try(

    aws_instance.web.public_ip,
 
   
  )
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.web.private_ip
   
  

  )
}