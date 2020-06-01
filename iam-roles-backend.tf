resource aws_iam_role "backend-all" {
  name               = "terraform-backend"
  description        = "Allows access to all Terraform workspaces"
  assume_role_policy = data.aws_iam_policy_document.backend-assume-role-all.json
}

resource aws_iam_role_policy "backend-all" {
  name   = "terraform-backend"
  role   = aws_iam_role.backend-all.id
  policy = data.aws_iam_policy_document.iam-role-policy.json

  depends_on = [aws_iam_role.backend-all]
}

resource aws_iam_role "backend-restricted" {
  count       = length(var.workspaces)
  name        = "terraform-backend-${element(var.workspaces, count.index)}"
  description = "Allows access to the ${element(var.workspaces, count.index)} Terraform worksapce"
  assume_role_policy = element(
    data.aws_iam_policy_document.backend-assume-role-restricted.*.json,
    count.index
  )
}

resource aws_iam_role_policy "backend-restricted" {
  count = length(var.workspaces)
  name  = "terraform-backend-${element(var.workspaces, count.index)}"
  role  = "terraform-backend-${element(var.workspaces, count.index)}"
  policy = element(
    data.aws_iam_policy_document.iam-role-policy-restricted.*.json,
    count.index
  )
  depends_on = [aws_iam_role.backend-restricted]
}
