local k = import 'ksonnet/ksonnet.beta.3/k.libsonnet';
local pvc = k.core.v1.persistentVolumeClaim;
local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') + {
    _config+:: {
      namespace: 'iaoiui-kube',
      # To modify Cluster Role of prometheus 
      prometheus+: {
        replicas: 1,
        name: 'k8s-kubep'
      },
      # To modify Cluster Role of prometheus adapter
      prometheusAdapter+: {
        name: 'prometheus-adapter-kubep'
      }
    },
    
    prometheus+:: {
      prometheus+: {
        spec+: {  // https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#prometheusspec
          // If a value isn't specified for 'retention', then by default the '--storage.tsdb.retention=24h' arg will be passed to prometheus by prometheus-operator.
          // The possible values for a prometheus <duration> are:
          //  * https://github.com/prometheus/common/blob/c7de230/model/time.go#L178 specifies "^([0-9]+)(y|w|d|h|m|s|ms)$" (years weeks days hours minutes seconds milliseconds)
          retention: '30d',

          // Reference info: https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/storage.md
          // By default (if the following 'storage.volumeClaimTemplate' isn't created), prometheus will be created with an EmptyDir for the 'prometheus-k8s-db' volume (for the prom tsdb).
          // This 'storage.volumeClaimTemplate' causes the following to be automatically created (via dynamic provisioning) for each prometheus pod:
          //  * PersistentVolumeClaim (and a corresponding PersistentVolume)
          //  * the actual volume (per the StorageClassName specified below)
          storage: {  // https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#storagespec
            volumeClaimTemplate:  // (same link as above where the 'pvc' variable is defined)
              pvc.new() +  // http://g.bryan.dev.hepti.center/core/v1/persistentVolumeClaim/#core.v1.persistentVolumeClaim.new

              pvc.mixin.spec.withAccessModes('ReadWriteOnce') +

              // https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.11/#resourcerequirements-v1-core (defines 'requests'),
              // and https://kubernetes.io/docs/concepts/policy/resource-quotas/#storage-resource-quota (defines 'requests.storage')
              pvc.mixin.spec.resources.withRequests({ storage: '10Gi' }) +

              // A StorageClass of the following name (which can be seen via `kubectl get storageclass` from a node in the given K8s cluster) must exist prior to kube-prometheus being deployed.
              pvc.mixin.spec.withStorageClassName('managed-nfs-storage'),

            // The following 'selector' is only needed if you're using manual storage provisioning (https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/storage.md#manual-storage-provisioning).
            // And note that this is not supported/allowed by AWS - uncommenting the following 'selector' line (when deploying kube-prometheus to a K8s cluster in AWS) will cause the pvc to be stuck in the Pending status and have the following error:
            //  * 'Failed to provision volume with StorageClass "ssd": claim.Spec.Selector is not supported for dynamic provisioning on AWS'
            //pvc.mixin.spec.selector.withMatchLabels({}),
          },  // storage
        },  // spec
      },  // prometheus
    },  // prometheus
 };


{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
