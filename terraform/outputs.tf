output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.id
}


output "load_balancer_hostname" {
  value = kubernetes_service.app-svc.status.0.load_balancer.0.ingress.0.hostname
}



//
//output "load_balancer_name" {
//  value = local.lb_name
//}
//
//output "load_balancer_info" {
//  value = data.aws_elb.example
//}

//output "kubectl_config" {
//  description = "kubectl config as generated by the module."
//  value       = module.eks.kubeconfig
//}

//output "config_map_aws_auth" {
//  description = "A kubernetes configuration to authenticate to this EKS cluster."
//  value       = module.eks.config_map_aws_auth
//}