[ ! -f deploy.yaml ] && wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/baremetal/deploy.yaml && \
kubectl apply -f deploy.yaml

status='none'
while [ "$status" != 'Completed' ]; do
    status=$(kubectl get po -A | grep ingress-nginx-admission-patch | awk -F' ' '{print $4}')
    sleep 3
done

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission


