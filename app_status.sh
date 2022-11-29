#!/bin/bash
sleep 20
kubectl get pods -n python-app -o NAME | awk -F "/" '{print $2}' | grep backend > file.txt
file='file.txt'
i=1
check="Status:       Running"


Total_Pods=$(awk 'END { print NR }' file.txt)
a=0
test=0
while [ $Total_Pods -ne $a ] && [ $test -lt 4 ]
do
        while read pod;
        do
                status=$(kubectl describe -n python-app pod $pod | grep "Status:")
                case "$status" in
                        #case 1
                        "Status:       Running") a=$((a+1)) ;;
                        #case 2
                        "Status:       Terminating") ;;
                        #else
                        *) echo $status
                        sleep 5
                        test=$((test+1)) ;;
                esac
        done < $file
done

while read pod; do
status=$(kubectl describe -n python-app pod $pod | grep "Status:")
echo "pod No.$i $pod -> $status"


case "$status" in
        #case 1
        "Status:       Running") helm status backend --namespace python-app | grep "STATUS" ;;
        #case 2
        "Status:       Pending") helm rollback backend --namespace python-app ;;
        #else
        *) helm rollback backend --namespace python-app ;;
esac


i=$((i+1))
done < $file
