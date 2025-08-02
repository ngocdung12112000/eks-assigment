resource "aws_iam_policy" "s3_readonly" {
  name   = "s3-readonly-policy"
  policy = file("${path.module}/iam-policies/s3-readonly-policy.json")
}

module "irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.30.0"

  role_name        = "nginx-s3-role"
  role_policy_arns = {
    s3 = aws_iam_policy.s3_readonly.arn   # <-- map key can be any label
  }

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:nginx-serviceaccount"]
    }
  }
}
