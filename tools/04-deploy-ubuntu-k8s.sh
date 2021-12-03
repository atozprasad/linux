cat > ubuntuon_k8s.yaml << EOFYMAL
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: ubuntu
  name: ubuntu
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ubuntu
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: ubuntu
    spec:
      containers:
      - image: harbor-repo.vmware.com/challagandlp/tools/ubuntu
        name: ubuntu
        command: ["/bin/sleep", "3650d"]
        resources: {}
EOFYMAL

kubectl apply  -f ubuntuon_k8s.yaml
PODNAME=`kubectl -n default get --no-headers=true pods -o name | awk -F "/" '{print $2}' | grep ubuntu`
kubectl -n default exec --stdin --tty $PODNAME -- /bin/bash

