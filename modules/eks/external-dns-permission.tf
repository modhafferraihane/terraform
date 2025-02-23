resource "aws_iam_role" "external_dns_role" {
  name = "eks-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::350137757872:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/2011004A76C575745357445151BC1D8E"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_eks_cluster.example.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:external-dns:external-dns"
          }
        }
      }
    ]
  })
}
#IAM Role for External DNS
resource "aws_iam_policy" "external_dns_policy" {
  name        = "ExternalDNSPolicyy"
  description = "Policy for ExternalDNS to access Route53"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets"
        ]
        Resource = "arn:aws:route53:::hostedzone/xxxxx"
      }
    ],
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ListHostedZones",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
  depends_on = [ aws_iam_role.external_dns_role ]
}

resource "aws_iam_role_policy_attachment" "external_dns_policy_attachment" {
  role       = aws_iam_role.external_dns_role.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
  depends_on = [ aws_iam_role.external_dns_role, aws_iam_policy.external_dns_policy ]
}


resource "aws_iam_role_policy_attachment" "externalDns_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.external_dns_role.name
  depends_on = [ aws_iam_role.external_dns_role ]
}

