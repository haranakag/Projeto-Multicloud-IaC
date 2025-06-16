resource "aws_key_pair" "key" {
  key_name   = "aws-key"
  #gerar as chaves com o comando ssh-keyger -f aws-key
  public_key = file("./aws-key.pub")
}

resource "aws_instance" "vm" {
  #pegar ID de alguma ami no console da AWS e cola abaixo
  ami           = ""
  instance_type = "t3a.micro"
  key_name = aws_key_pair.key.key_name
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "vm-terraform"
  }
}