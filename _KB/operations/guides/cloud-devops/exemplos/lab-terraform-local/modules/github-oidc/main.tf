# INF-004 — GitHub Actions assume roles na AWS via OIDC, sem access key.
#
#   job ──(id-token: write)──► GitHub emite JWT {sub: "repo:ORG@ID/REPO@ID:ref:refs/heads/main", aud: sts}
#       ──► STS confere assinatura + aud + sub contra a trust policy ──► credencial temporária (~1h)

locals {
  issuer = "token.actions.githubusercontent.com"

  # Prefixo do sub por role: legado (repo:org/repo) ou imutável (repo:org@id/repo@id).
  sub_prefix = {
    for k, r in var.roles : k => (
      var.github_org_id == null
      ? "repo:${var.github_org}/${r.repository}"
      : "repo:${var.github_org}@${var.github_org_id}/${r.repository}@${r.repository_id}"
    )
  }

  provider_arn = var.create_provider ? aws_iam_openid_connect_provider.github[0].arn : var.existing_provider_arn
}

# Um por conta AWS. thumbprint_list é opcional desde que a AWS passou a validar
# o certificado do GitHub pelas CAs confiáveis.
resource "aws_iam_openid_connect_provider" "github" {
  count          = var.create_provider ? 1 : 0
  url            = "https://${local.issuer}"
  client_id_list = ["sts.amazonaws.com"]
}

# Trust policy: QUEM pode assumir cada role.
data "aws_iam_policy_document" "trust" {
  for_each = var.roles

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }

    # O token precisa ter sido emitido PARA a AWS.
    condition {
      test     = "StringEquals"
      variable = "${local.issuer}:aud"
      values   = ["sts.amazonaws.com"]
    }

    # StringEquals (exato): repo + environment/branch/PR.
    condition {
      test     = "StringEquals"
      variable = "${local.issuer}:sub"
      values   = [for s in each.value.subjects : "${local.sub_prefix[each.key]}:${s}"]
    }
  }
}

resource "aws_iam_role" "this" {
  for_each = var.roles

  name                 = "gha-${each.key}"
  path                 = var.role_path
  description          = "GitHub Actions: ${var.github_org}/${each.value.repository} (${join(", ", each.value.subjects)})"
  assume_role_policy   = data.aws_iam_policy_document.trust[each.key].json
  max_session_duration = each.value.max_session_duration
}

# Permissões: O QUE cada role pode fazer.
resource "aws_iam_role_policy" "this" {
  for_each = var.roles

  name   = "least-privilege"
  role   = aws_iam_role.this[each.key].id
  policy = each.value.policy_json
}
