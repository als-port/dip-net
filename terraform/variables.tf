variable "pk" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcIUc+IHgJxRXppFIRBviqm/L3dfHMW+ePn3g6oYb/2Ob9z5xLwtVNpcI0zttf/LQABARzuHvLSa4eZSjPLywkmaR+cZH8aPxhPDAM2tmHzrdgLeLzE6NkwG+0d8H13UatmZoiuMmxoVC4rL/c2plN9DE3l27O5cGONxSPPbZAVzPSKqa9FyHdRu9MGuhP+e+EFZTf736zSYcZ2CKI+zyMirOOWiImqjdA0BqDvREUpvtlx0zV5fh50PLueKNKMHODwDO1rCiEqbsCT6SCHAOEsCBCqc1R5XnVujXpZMmMBA5sReJ31pAldNac1dQ+iSIwHy+CzpITrJxkN6pn5Lah als@ub21"
}

variable "serv_sert" {
  default = "arn:aws:acm:eu-central-1:336639867151:certificate/4618aba8-3330-45f1-9467-2be73fe6a222"
}

variable "sert" {
  default = "arn:aws:acm:eu-central-1:336639867151:certificate/604c31d3-1bfb-490d-955e-88b008e50118"
}

variable "cluster_name" {
  default = "dip-net-cluster"
}

//variable "map_accounts" {
//  description = "Additional AWS account numbers to add to the aws-auth configmap."
//  type        = list(string)
//
//  default = [
//    "777777777777",
//    "888888888888",
//  ]
//}
//
//variable "map_roles" {
//  description = "Additional IAM roles to add to the aws-auth configmap."
//  type = list(object({
//    rolearn  = string
//    username = string
//    groups   = list(string)
//  }))
//
//  default = [
//    {
//      rolearn  = "arn:aws:iam::66666666666:role/role1"
//      username = "role1"
//      groups   = ["system:masters"]
//    },
//  ]
//}
//
//variable "map_users" {
//  description = "Additional IAM users to add to the aws-auth configmap."
//  type = list(object({
//    userarn  = string
//    username = string
//    groups   = list(string)
//  }))
//
//  default = [
//    {
//      userarn  = "arn:aws:iam::66666666666:user/user1"
//      username = "user1"
//      groups   = ["system:masters"]
//    },
//    {
//      userarn  = "arn:aws:iam::66666666666:user/user2"
//      username = "user2"
//      groups   = ["system:masters"]
//    },
//  ]
//}
