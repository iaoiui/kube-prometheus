for ns in `kubectl get ns --field-selector status.phase=Terminating -o name | cut -d/ -f2`; 
do
  echo "apiservice under namespace $ns"
  kubectl get apiservice -o json |jq --arg ns "$ns" '.items[] |select(.spec.service.namespace != null) | select(.spec.service.namespace == $ns) | .metadata.name ' --raw-output
  echo "api resources under namespace $ns"
  for resource in `kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -o name -n $ns`; 
  do 
    echo $resource
  done;
done

for ns in `kubectl get ns --field-selector status.phase=Terminating -o name | cut -d/ -f2`; 
do
    export NS=$ns
    kubectl create ns $NS --dry-run -ojson > /tmp/ns.json
    curl -k -H "Content-Type: application/json" -X PUT --data-binary @/tmp/ns.json http://localhost:8080/api/v1/namespaces/$NS/finalize
done

