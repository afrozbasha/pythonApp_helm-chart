#!/bin/bash
kubectl get pods -n python-app -o NAME | awk -F "/" '{print $2}' > file.txt
file='file.txt'
i=1
check="Status:       Running"
while read pod; do
status=$(kubectl describe pod -n python-app $pod | grep "Status:")
echo "pod No.$i $pod -> $status"

case "$status" in
	#case 1
	"Status:       Running") helm status nginx --namespace python-app | grep "STATUS" ;;
	#case 2
	"Status:       Pending") helm rollback --namespace python-app nginx ;;
	#else
    *) helm rollback --namespace python-app nginx ;;
esac

i=$((i+1))
done < $file
