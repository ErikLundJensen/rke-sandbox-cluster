apiVersion: v1
stringData:
  admin.password: {{GENPASSWORD}}
  admin.passwordMtime: '2020-01-10T15:02:13UTC'
kind: Secret
metadata:
  labels:
    app.kubernetes.io/name: argocd-secret
    app.kubernetes.io/part-of: argocd
  name: argocd-secret
type: Opaque