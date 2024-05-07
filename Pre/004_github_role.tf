resource "aws_iam_role" "github_role_assumed" {
  provider = aws.principal
  name     = "RoleGithubRunners_Infrastructure_Pre_common"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "TrustPolicy",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::237106410778:role/RoleGithubRunners",
     "AWS" : "arn:aws:iam::237106410778:role/RoleGithubRunners_Infrastructure_Pre_common"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
  tags = merge(var.tags, var.compute-tags)
}
