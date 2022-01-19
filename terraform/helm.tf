# Assumes that an enforcer secret with the token is created before as described in: https://jira.nexusgroup.com/browse/IS-2337
resource "helm_release" "main" {
  name       = lower(var.component)
  repository = "https://helm.aquasec.com"
  chart      = "scanner"
  version    = "6.5.3"
  namespace  = var.kubernetes_namespace
  timeout    = 1200

  values = [<<EOF
platform: aks

imageCredentials:
  create: false

scannerUserSecret:
  enable: true
  secretName: scanner-user
  userKey: user
  passwordKey: password

serviceAccount:
  name: "${var.kubernetes_namespace}-sa"

server:
  serviceName: "aquaserver-console-svc"

replicaCount: 2
resources:
  limits:
    cpu: 2000m
    memory: 1000Mi
  requests:
    cpu: 1000m
    memory: 500Mi
# Trying to make it possible for https://docs.renovatebot.com/modules/manager/helm-values/ to find the values
image: 
#renovatebot depname=registry.aquasec.com/scanner
  tag: 6.5.22003

EOF
  ]
