apiVersion: v1
stringData:
  username: admin
  password: {{GENPASSWORD}}
kind: Secret
metadata:
  name: weave-scope-secret
  namespace: weave
type: Opaque