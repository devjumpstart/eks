resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = var.autoscaler_chart_version
  namespace  = "kube-system"

  atomic  = true
  wait    = true
  timeout = 300

  values = [
    yamlencode({
      cloudProvider = "aws"
      awsRegion     = var.aws_region

      autoDiscovery = {
        clusterName = data.terraform_remote_state.cluster.outputs.cluster_name
      }

      image = {
        repository = "registry.k8s.io/autoscaling/cluster-autoscaler"
        tag        = var.autoscaler_image_tag
      }

      rbac = {
        serviceAccount = {
          create = true
          name   = "cluster-autoscaler"
        }
      }

      replicaCount = 1

      resources = {
        requests = {
          cpu    = "100m"
          memory = "200Mi"
        }
        limits = {
          memory = "400Mi"
        }
      }
    })
  ]

  depends_on = [
    aws_eks_pod_identity_association.cluster_autoscaler,
    aws_iam_role_policy_attachment.cluster_autoscaler
  ]
}