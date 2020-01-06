oc delete project iaoiui-kube
oc delete -f  manifests/prometheus-roleSpecificNamespaces.yaml
oc delete -f  manifests/prometheus-roleBindingSpecificNamespaces.yaml
