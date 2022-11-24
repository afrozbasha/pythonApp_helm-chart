#!/bin/bash
sleep 30s
kubectl get pods -n jenkins -o NAME | awk -F "/" '{print $2}' > file.txt
file='file.txt'
i=1
check="Status:       Running"
while read pod; do
status=$(kubectl describe pod -n jenkins $pod | grep "Status:")
echo "pod No.$i $pod -> $status"

case "$status" in
	#case 1
	"Status:       Running") helm status backend --namespace jenkins | grep "STATUS" ;;
	#case 2
	"Status:       Pending") helm rollback --namespace jenkins backend ;;
	#else
    *) helm rollback --namespace jenkins backend ;;
esac

i=$((i+1))
done < $file
