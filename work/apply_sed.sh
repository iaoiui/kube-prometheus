#- [x] vendor/kube-prometheus/node-exporter/node-exporter.libsonnet
sed vendor/kube-prometheus/node-exporter/node-exporter.libsonnet -e "s/clusterRoleBinding.mixin.metadata.withName('node-exporter')/clusterRoleBinding.mixin.metadata.withName('node-exporter-kubep')/" -i
sed vendor/kube-prometheus/node-exporter/node-exporter.libsonnet -e "s/clusterRoleBinding.mixin.roleRef.withName('node-exporter')/clusterRoleBinding.mixin.roleRef.withName('node-exporter-kubep')/" -i 
sed vendor/kube-prometheus/node-exporter/node-exporter.libsonnet -e "s/clusterRole.mixin.metadata.withName('node-exporter')/clusterRole.mixin.metadata.withName('node-exporter-kubep')/" -i

#- [x] vendor/kube-prometheus/kube-state-metrics/kube-state-metrics.libsonnet
sed vendor/kube-prometheus/kube-state-metrics/kube-state-metrics.libsonnet -e "s/clusterRoleBinding.mixin.metadata.withName('kube-state-metrics')/clusterRoleBinding.mixin.metadata.withName('kube-state-metrics-kubep')/g" -i
sed vendor/kube-prometheus/kube-state-metrics/kube-state-metrics.libsonnet -e "s/clusterRoleBinding.mixin.roleRef.withName('kube-state-metrics')/clusterRoleBinding.mixin.roleRef.withName('kube-state-metrics-kubep')/g" -i
sed vendor/kube-prometheus/kube-state-metrics/kube-state-metrics.libsonnet -e "s/clusterRole.mixin.metadata.withName('kube-state-metrics')/clusterRole.mixin.metadata.withName('kube-state-metrics-kubep')/" -i

#- [x] vendor/prometheus-operator/prometheus-operator.libsonnet
sed vendor/prometheus-operator/prometheus-operator.libsonnet -e "s/clusterRoleBinding.mixin.metadata.withName('prometheus-operator')/clusterRoleBinding.mixin.metadata.withName('prometheus-operator-kubep')/g" -i 
sed vendor/prometheus-operator/prometheus-operator.libsonnet -e "s/clusterRoleBinding.mixin.roleRef.withName('prometheus-operator')/clusterRoleBinding.mixin.roleRef.withName('prometheus-operator-kubep')/g" -i 
sed vendor/prometheus-operator/prometheus-operator.libsonnet -e "s/clusterRole.mixin.metadata.withName('prometheus-operator')/clusterRole.mixin.metadata.withName('prometheus-operator-kubep')/g" -i

#- [x] vendor/kube-prometheus/prometheus-adapter/prometheus-adapter.libsonnet
sed vendor/kube-prometheus/prometheus-adapter/prometheus-adapter.libsonnet -e "s/name: 'v1beta1.metrics.k8s.io'/name: 'v1beta1.metrics.k8s.io.kubep'/g" -i 
sed vendor/kube-prometheus/prometheus-adapter/prometheus-adapter.libsonnet -e "s/group: 'metrics.k8s.io'/group: 'metrics.k8s.io.kubep'/g" -i 
sed vendor/kube-prometheus/prometheus-adapter/prometheus-adapter.libsonnet -e "s/policyRule.withApiGroups(['metrics.k8s.io'])/policyRule.withApiGroups(['metrics.k8s.io.kubep'])/g" -i

