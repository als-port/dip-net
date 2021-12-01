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

#https://www.youtube.com/watch?v=2T67_c5YIBQ
#https://habr.com/ru/post/493580/
#https://www.youtube.com/watch?v=0D_wKERZ2zo
#https://github.com/ksemaev/project_template/blob/master/jenkinsfiles/docker_build.jenkins
#https://github.com/shazforiot/How-to-Push-docker-image-to-Docker-Hub-using-Jenkins-Pipeline/blob/main/Jenkinsfile
#kubectl create deployment app-deployment --image=alsxs/nginx:${BUILD_TIMESTAMP} --port=80 && kubectl scale deployment app-deployment --replicas=3