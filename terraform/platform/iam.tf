# Trust policy for EKS Pod Identity
data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# Cluster Autoscaler IAM role
resource "aws_iam_role" "cluster_autoscaler" {
  count              = var.enable_cluster_autoscaler ? 1 : 0
  name               = "${data.terraform_remote_state.cluster.outputs.cluster_name}-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

# Autoscaler permissions
data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid = "ReadScalingInformation"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]

    resources = ["*"]
  }

  statement {
    sid = "ScaleClusterNodes"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${data.terraform_remote_state.cluster.outputs.cluster_name}"
      values   = ["owned"]
    }
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count  = var.enable_cluster_autoscaler ? 1 : 0
  name   = "${data.terraform_remote_state.cluster.outputs.cluster_name}-autoscaler"
  policy = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count      = var.enable_cluster_autoscaler ? 1 : 0
  role       = aws_iam_role.cluster_autoscaler[count.index].name
  policy_arn = aws_iam_policy.cluster_autoscaler[count.index].arn
}

# Connect IAM role to Kubernetes service account
resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  count           = var.enable_cluster_autoscaler ? 1 : 0
  cluster_name    = data.terraform_remote_state.cluster.outputs.cluster_name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler[count.index].arn
}

# AWS Load Balancer Controller IAM role
resource "aws_iam_role" "aws_load_balancer_controller" {
  name               = "${data.terraform_remote_state.cluster.outputs.cluster_name}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json
}

# Controller IAM policy
resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "${data.terraform_remote_state.cluster.outputs.cluster_name}-alb-controller"

  policy = file(
    "${path.module}/policies/aws-load-balancer-controller.json"
  )
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

# Associate IAM role with Kubernetes ServiceAccount
resource "aws_eks_pod_identity_association" "aws_load_balancer_controller" {
  cluster_name = data.terraform_remote_state.cluster.outputs.cluster_name

  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"

  role_arn = aws_iam_role.aws_load_balancer_controller.arn
}