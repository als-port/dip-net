//resource "kubernetes_service_account" "jenkins_svsacc" {
//    metadata {
//      name = "jenkins"
//    }
//    secret {
//    name = kubernetes_secret.jenkins.metadata.0.name
//    }
//}
//
//resource "kubernetes_secret" "jenkins_svsacc_secr" {
//  metadata {
//    name = "jenkins"
//  }
//}

resource "kubernetes_cluster_role" "jenkins_svsacc_role" {
  metadata {
    name = "jenkins"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/exec"]
    verbs      = ["create","delete","get","list","patch","update","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["pods/log"]
    verbs      = ["get","list","watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["create","delete","get","list","patch","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["create","delete","get","list","patch","update"]
  }
  rule {
    api_groups = ["apps"]
    resources  = ["deployments"]
    verbs      = ["create","delete","get","list","patch","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["statefulset"]
    verbs      = ["create","delete","get","list","patch","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["create","delete","get","list","patch","update"]
  }
  rule {
    api_groups = [""]
    resources  = ["ingresses"]
    verbs      = ["create","delete","get","list","patch","update"]
  }

}

resource "kubernetes_cluster_role_binding" "jenkins_svsacc_role_bind" {
  metadata {
    name = "jenkins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "jenkins"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "jenkins"
    namespace = "default"
  }

}