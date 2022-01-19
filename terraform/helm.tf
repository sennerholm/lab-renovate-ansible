# Assumes that an enforcer secret with the token is created before as described in: https://jira.nexusgroup.com/browse/IS-2337
resource "helm_release" "main" {
  name       = lower(var.component)
  repository = "https://helm.aquasec.com"
  chart      = "scanner"
  version    = "6.5.3"
  namespace  = var.kubernetes_namespace
  timeout    = 1200

  values = [<<EOF
testvalues
#Trying to make it possible for https://docs.renovatebot.com/modules/manager/helm-values/ to find the values
image: 
#renovatebot depname=registry.aquasec.com/scanner
  tag: 6.5.22003

EOF
  ]
}