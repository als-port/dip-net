module "grafana_prometheus_monitoring" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-grafana-prometheus.git"

  enabled = true
  #export KUBECONFIG=/home/als/.kube/config
  settings_grafana = {
    "adminPassword" = "admin"
    "persistence" : {
      "enabled" : true
      "storageClassName" : "gp2"
    }
    "service" : {
      "type" : "LoadBalancer"
    }
  }

}



