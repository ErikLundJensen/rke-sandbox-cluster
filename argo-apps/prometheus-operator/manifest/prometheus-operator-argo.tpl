apiVersion: argoproj.io/v1alpha1
metadata:
  name: prometheus-operator
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
                - 'grafana.apps.rke1.test.2108.dk'
              tls:
                - secretName: prometheus-operator-grafana-ingress-secret
                  hosts:
                    - grafana.apps.rke1.test.2108.dk
    destination:
      server: 'https://kubernetes.default.svc'
      namespace: monitoring