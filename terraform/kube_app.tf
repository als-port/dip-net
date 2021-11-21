resource "kubernetes_deployment" "app-deployment" {
  metadata {
    name = "app-deployment"
    labels = {
      app = "app-dip"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "app-dip"
      }
    }

    template {
      metadata {
        labels = {
          app = "app-dip"
        }
      }

      spec {
        container {
          image = "alsxs/nginx:alpineapp"
          name  = "app-dip"

                    resources {
                      limits = {
                        cpu    = "0.5"
                        memory = "1024Mi"
                      }
                      requests = {
                        cpu    = "500m"
                        memory = "512Mi"
                      }
                    }
//
//                    liveness_probe {
//                      http_get {
//                        path = "/nginx_status"
//                        port = 80
//
//                        http_header {
//                          name  = "X-Custom-Header"
//                          value = "Awesome"
//                        }
//                      }
//
//                      initial_delay_seconds = 3
//                      period_seconds        = 3
//                    }
        }
      }
    }
  }
}

resource "kubernetes_service" "app-svc" {
  metadata {
    name = "app-dip"

  }
  spec {
    selector = {
      app = kubernetes_deployment.app-deployment.metadata.0.labels.app
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

locals {
  lb_name = split("-", split(".", kubernetes_service.app-svc.status.0.load_balancer.0.ingress.0.hostname).0).0
}

data "aws_elb" "example" {
  name = local.lb_name
}


