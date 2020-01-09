#!/bin/bash


# Delete all of Weave Scope if needed
# kubectl delete all --selector app=weave-scope -n weave

mkdir -p tmp
# Create secret for Weave Scope UI
echo -n `pwgen -s 16 -1` > ./tmp/weave-scope-password.plain
sed -e s/{{GENPASSWORD}}/`cat ./tmp/weave-scope-password.plain`/ < addons/weave-scope-secret.tpl > ./tmp/weave-scope-secret.yaml
kubectl apply -f ./tmp/weave-scope-secret.yaml -n weave
kubectl apply -f addons/weave-scope-1.16.yaml -n weave

kubectl rollout restart deployment weave-scope-app -n weave

echo Password for Weave Scope is located in file ./tmp/weave-scope-password.plain

# Argo CD downloaded from https://github.com/argoproj/argo-cd/releases
for namespace in  argocd
do
  echo Installing Argo CD in namespace: $namespace

  # Replace namespace in configuration - todo: running multiple argocd instances in different namespaces give auth problems.
  # sed -e s"/namespace: argocd/namespace: $namespace/"g <addons/argo-cd-v1.3.6.yaml >./tmp/argo-cd-v1.3.6-$namespace.yaml
  # kubectl apply -f ./tmp/argo-cd-v1.3.6-$namespace.yaml -n $namespace

  kubectl apply -f addons/argo-cd-v1.3.6.yaml -n $namespace

  # Create secret for Argo CD by overwriting the secret. Password have to be bcrypt encrypted.
  echo -n `pwgen -s 16 -1` > ./tmp/argo-cd-password-$namespace.plain
  htpasswd -bnBC 16 "" `cat ./tmp/argo-cd-password-$namespace.plain` | tr -d ':\n' | sed 's/$2y/$2a/' > ./tmp/argo-cd-password-$namespace.bcrypted
  # Use equal '=' as delimiter in sed to avoid collision with password
  sed -e s={{GENPASSWORD}}=`cat ./tmp/argo-cd-password-$namespace.bcrypted`= < addons/argo-cd-secret.tpl > ./tmp/argo-cd-secret-$namespace.yaml
  kubectl apply -f ./tmp/argo-cd-secret-$namespace.yaml -n $namespace

  # Rollout new version to ensure password is reloaded
  kubectl rollout restart deployment argocd-server -n $namespace

  echo "Password for Argo in namespace: $namespace is located in file ./tmp/argo-cd-password-$namespace.plain"
done

echo Done
