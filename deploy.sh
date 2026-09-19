#!/bin/bash
set -e

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

# 3. Point docker to minikube's daemon
echo "▶ Connecting to minikube's Docker daemon..."
eval $(minikube docker-env)

# 4. Build the image inside minikube
echo "▶ Building container image..."
docker build -t kcd-keynote:latest .

# 5. Deploy to k8s
echo "▶ Applying Kubernetes manifests..."
kubectl apply -f k8s/deploy.yaml

# 6. Wait for rollout
echo "▶ Waiting for pod to be ready..."
kubectl rollout status deployment/kcd-keynote --timeout=60s

# 7. Get the URL
echo ""
echo "=================================================="
echo "✅ Deployed!"
echo ""
echo "Pod status:"
kubectl get pods -l app=kcd-keynote
echo ""

URL=$(minikube service kcd-keynote --url 2>/dev/null || echo "")
if [ -n "$URL" ]; then
  echo "🌐 Open: $URL"
else
  echo "🌐 Run:  minikube service kcd-keynote"
fi
echo ""
echo "Quick commands:"
echo "  kubectl logs -l app=kcd-keynote     # View logs"
echo "  kubectl get pods -l app=kcd-keynote # Pod status"
echo "  minikube service kcd-keynote        # Open in browser"
echo "  kubectl delete -f k8s/deploy.yaml   # Tear down"
echo "=================================================="
