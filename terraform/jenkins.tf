provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  values = [
    "${file("jenkins.yaml")}"
  ]

  set_sensitive {
    name  = "controller.adminUser"
    value = "admin"
  }
  set_sensitive {
    name = "controller.adminPassword"
    value = "admin"
  }
  set_sensitive {
    name = "adminPassword"
    value = "admin"
  }
}