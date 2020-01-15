apiVersion: argoproj.io/v1alpha1
metadata:
  name: local-path-storage
spec:
    project: default
    source:
      repoURL: 'https://github.com/helm/charts.git'
      path: stable/prometheus-operator
      targetRevision: HEAD
      helm:
        parameters:
          - name: prometheus.ingress.enabled
            value: 'false'
          - name: grafana.ingress.enabled
            value: 'true'
        values: |-
          grafana:
            adminPassword: {{GENPASSWORD}}
            ingress:
              enabled: true
              hosts:
                - 'grafana.digitalocean.local'
              tls:
                - secretName: prometheus-operator-ingress-secret
                  hosts:
                    - grafana.digitalocean.local
    destination:
      server: 'https://kubernetes.default.svc'
      namespace: monitoring