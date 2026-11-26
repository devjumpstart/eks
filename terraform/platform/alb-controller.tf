resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "3.6.1"
  namespace  = "kube-system"

  atomic  = true
  wait    = true
  timeout = 300

  values = [
    yamlencode({
      clusterName = data.terraform_remote_state.cluster.outputs.cluster_name

      region = var.aws_region
      vpcId  = data.terraform_remote_state.network.outputs.vpc_id

      replicaCount = 1

      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
      }

      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
        limits = {
          memory = "512Mi"
        }
      }
    })
  ]

  depends_on = [
    aws_eks_pod_identity_association.aws_load_balancer_controller,
    aws_iam_role_policy_attachment.aws_load_balancer_controller
  ]
}