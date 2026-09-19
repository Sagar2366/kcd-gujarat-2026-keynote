#!/bin/bash
set -e

DOMAIN="kcdgujarat.com"

echo "🚀 Deploying KCD Gujarat 2026 Keynote to Minikube"
echo "=================================================="

# 1. Check minikube
if ! command -v minikube &> /dev/null; then
  echo "❌ minikube not found. Install: https://minikube.sigs.k8s.io/docs/start/"
  exit 1
fi

# 2. Start minikube if not running
if ! minikube status | grep -q "Running"; then
  echo "▶ Starting minikube..."
  minikube start
fi

# 3. Enable ingress addon
echo "▶ Enabling NGINX Ingress controller..."
minikube addons enable ingress
echo "▶ Waiting for ingress controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s 2>/dev/null || echo "  (ingress controller starting...)"

# 4. Point docker to minikube's daemon
echo "▶ Connecting to minikube's Docker daemon..."
eval $(minikube docker-env)

# 5. Build the image inside minikube
echo "▶ Building container image..."
docker build -t kcd-keynote:latest .

# 6. Deploy to k8s
echo "▶ Applying Kubernetes manifests..."
kubectl apply -f k8s/deploy.yaml
kubectl apply -f k8s/ingress.yaml

# 7. Wait for rollout
echo "▶ Waiting for pod to be ready..."
kubectl rollout status deployment/kcd-keynote --timeout=60s

# 8. Configure /etc/hosts
MINIKUBE_IP=$(minikube ip)
echo ""
echo "▶ Configuring $DOMAIN → $MINIKUBE_IP"

if grep -q "$DOMAIN" /etc/hosts; then
  echo "  $DOMAIN already in /etc/hosts — updating..."
  sudo sed -i.bak "/$DOMAIN/d" /etc/hosts
fi
echo "$MINIKUBE_IP  $DOMAIN" | sudo tee -a /etc/hosts > /dev/null
echo "  ✅ Added: $MINIKUBE_IP  $DOMAIN"

# 9. Done
echo ""
echo "=================================================="
echo "✅ Deployed!"
echo ""
echo "Pod status:"
kubectl get pods -l app=kcd-keynote
echo ""
echo "Ingress:"
kubectl get ingress kcd-keynote
echo ""
echo "🌐 Open: http://$DOMAIN"
echo ""
echo "Quick commands:"
echo "  kubectl logs -l app=kcd-keynote       # View logs"
echo "  kubectl get pods -l app=kcd-keynote   # Pod status"
echo "  kubectl get ingress                   # Ingress status"
echo "  kubectl delete -f k8s/                # Tear down"
echo "  sudo sed -i.bak '/$DOMAIN/d' /etc/hosts  # Remove DNS entry"
echo "=================================================="
