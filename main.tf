terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "aws_key_pair" "example" {
    key_name = "terraform-demo-sanjeev"
    public_key = file("id_rsa.pub")
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "mysubnet" {
    vpc_id  = aws_vpc.myvpc.id
    cidr_block = var.subnet-cidr
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myrt" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
}

resource "aws_route_table_association" "myrtassoc" {
    subnet_id = aws_subnet.mysubnet.id
    route_table_id = aws_route_table.myrt.id
}

resource "aws_security_group" "mysg" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id

    ingress{
        description = "HTTP to VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "HTTP to VPC"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]        
    }
    egress{
        description = "Outbound Config"
        from_port = 0
        to_port = 0
        protocol = "-1" #"tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      name = "Web-SG"
    }
}

resource "aws_instance" "k8s-master" {
    instance_type = var.instance-type
    ami = var.ami
    subnet_id = aws_subnet.mysubnet.id
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.mysg.id]

    tags = {
      name = "k8s-master"
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
        private_key = file("id_rsa")  # Replace with the path to your private key
        host        = self.public_ip
    }

    provisioner "remote-exec" {
    inline = [
        "echo 'Hello from the remote instance'",
        "sudo apt update -y",  # Update package lists (for ubuntu)
        /*"sudo apt-get install -y apt-transport-https ca-certificates curl",
        "sudo apt install docker.io -y",
        "sudo systemctl enable --now docker",
        "curl -fsSL 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg",
        "echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
        "sudo apt update",
        "sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y",
        "sudo kubeadm init",
        "mkdir -p $HOME/.kube",
        "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
        "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
        "kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml",
        "sudo kubeadm token create --print-join-command" */
    ]
    }
}

resource "aws_instance" "k8s-worker" {
    instance_type = var.instance-type
    ami = var.ami
    subnet_id = aws_subnet.mysubnet.id
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.mysg.id]

    tags = {
      name = "k8s-worker"
    }

    connection {
        type        = "ssh"
        user        = "ubuntu"  # Replace with the appropriate username for your EC2 instance
        private_key = file("id_rsa")  # Replace with the path to your private key
        host        = self.public_ip
    }

    provisioner "remote-exec" {
    inline = [
        "echo 'Hello from the remote instance'",
        "sudo apt update -y",  # Update package lists (for ubuntu)
        /*"sudo apt-get install -y apt-transport-https ca-certificates curl",
        "sudo apt install docker.io -y",
        "sudo systemctl enable --now docker",
        "curl -fsSL 'https://packages.cloud.google.com/apt/doc/apt-key.gpg' | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg",
        "echo 'deb https://packages.cloud.google.com/apt kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
        "sudo apt update",
        "sudo apt install kubeadm=1.20.0-00 kubectl=1.20.0-00 kubelet=1.20.0-00 -y",
        "sudo kubeadm reset pre-flight checks" */       
    ]
    }
}

output "k8s-worker-ip" {
    value = aws_instance.k8s-worker.public_ip
}

output "k8s-master-ip" {
    value = aws_instance.k8s-master.public_ip
}