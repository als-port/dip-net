output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "aws_region" {
  value = data.aws_region.current.id
}

//output "cluster_security_group_id" {
//  description = "sg contr plane"
//  value = module.eks.cluster_security_group_id
//}
//
//output "cluster_endpoint" {
//  description = "ep control plane"
//  value = module.eks.cluster_endpoint
//}

//output "kubectl_config" {
//  description = "kubectl_conf"
//  value = module.eks.kubeconfig
//}

//output "config_map_aws_auth" {
//  description = "conf auth"
//  value = module.eks.config_map_aws_auth
//}

