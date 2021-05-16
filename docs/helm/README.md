# Kimai

[Kimai](https://kimai.org/)  is a free & open source timetracker. It tracks work time and prints out a summary of your activities on demand. Yearly, monthly, daily, by customer, by project … Its simplicity is its strength.

## TL;DR

```console
git clone https://github.com/tobybatch/kimai2.git
helm install kimai kimai2/docs/helm
```

## Introduction

This chart bootstraps a [Kimai2](https://github.com/tobybatch/kimai2) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It also packages the [Bitnami MariaDB chart](https://github.com/bitnami/charts/tree/master/bitnami/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the Kimai application.

This chart has been tested to work with NGINX Ingress and cert-manager on top of the [MicroK8s](https://microk8s.io/).

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `kimai`:

```console
helm install kimai kimai2/docs/helm
```

The command deploys Kimai on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `kimai` deployment:

```console
helm delete kimai
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `nameOverride`      | String to partially override common.names.fullname | `nil`           |
| `fullnameOverride`  | String to fully override common.names.fullname     | `nil`           |

### Kimai Image parameters

| Name                | Description                                          | Value                 |
| ------------------- | ---------------------------------------------------- | --------------------- |
| `image.repository`  | Kimai image repository                               | `kimai/kimai2`        |
| `image.tag`         | Kimai image tag (immutable tags are recommended)     | `apache` |
| `image.pullPolicy`  | Kimai image pull policy                              | `IfNotPresent`        |
| `imagePullSecrets`  | Kimai image pull secrets                             | `[]`                  |

### Kimai Configuration parameters

| Name                                   | Description                           | Value                |
| -------------------------------------- | ------------------------------------- | -------------------- |
| `kimaiAdminEmail`                      | Email for the superadmin account      | `admin@kimai.local`  |
| `kimaiAdminPassword`                   | Password for the superadmin account   | `changemeplease`     |
| `kimaiEnvironment`                     | Kimai environment name                | `prod`               |

### Kimai deployment parameters

| Name                                    | Description                                                | Value           |
| --------------------------------------- | -----------------------------------------------------------| --------------- |
| `replicaCount`                          | Number of Kimai replicas to deploy                         | `1`             |
| `updateStrategy.type`                   | Kimai deployment strategy type                             | `RollingUpdate` |
| `updateStrategy.rollingUpdate`          | Kimai deployment rolling update configuration parameters   | `{}`            |
| `schedulerName`                         | Alternate scheduler                                        | `nil`           |
| `serviceAccountName`                    | ServiceAccount name                                        | `default`       |
| `hostAliases`                           | Kimai pod host aliases                                     | `[]`            |
| `podAnnotations`                        | Annotations for Kimai pods                                 | `{}`            |

### Traffic Exposure Parameters

| Name                               | Description                                                                      | Value          |
| ---------------------------------- | ---------------------------------------------------------------------------------| -------------- |
| `service.type`                     | Kimai service type                                                               | `ClusterIP`    |
| `service.port`                     | Kimai service HTTP port                                                          | `80`           |
| `ingress.enabled`                  | Enable ingress record generation for Kimai                                       | `false`        |
| `ingress.certManager`              | Add the corresponding annotations for cert-manager integration                   | `false`        |
| `ingress.hostname`                 | Default host for the ingress record                                              | `Kimai.local`  |
| `ingress.annotations`              | Additional custom annotations for the ingress record                             | `{}`           |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter    | `false`        |
| `ingress.secrets`                  | Custom TLS certificates as secrets                                               | `[]`           |

### Persistence Parameters

| Name                                          | Description                                                | Value             |
| --------------------------------------------- | -----------------------------------------------------------| ----------------- |
| `persistence.enabled`                         | Enable persistence using Persistent Volume Claims          | `true`            |
| `persistence.storageClass`                    | Persistent Volume storage class                            | `nil`             |
| `persistence.accessModes`                     | Persistent Volume access modes                             | `[ReadWriteOnce]` |
| `persistence.size`                            | Persistent Volume size                                     | `4Gi`             |
| `persistence.existingClaim`                   | The name of an existing PVC to use for persistence         | `nil`             |

### Database Parameters

| Name                                       | Description                                                               | Value             |
| ------------------------------------------ | ------------------------------------------------------------------------- | ----------------- |
| `mariadb.enabled`                          | Deploy a MariaDB server to satisfy the applications database requirements | `true`            |
| `mariadb.architecture`                     | MariaDB architecture. Allowed values: `standalone` or `replication`       | `standalone`      |
| `mariadb.auth.rootPassword`                | MariaDB root password                                                     | `changeme`        |
| `mariadb.auth.database`                    | MariaDB custom database                                                   | `kimai`           |
| `mariadb.auth.username`                    | MariaDB custom user name                                                  | `kimai`           |
| `mariadb.auth.password`                    | MariaDB custom user password                                              | `kimai`           |
| `mariadb.primary.persistence.enabled`      | Enable persistence on MariaDB using PVC(s)                                | `true`            |
| `mariadb.primary.persistence.storageClass` | Persistent Volume storage class                                           | `nil`             |
| `mariadb.primary.persistence.accessModes`  | Persistent Volume access modes                                            | `[ReadWriteOnce]` |
| `mariadb.primary.persistence.size`         | Persistent Volume size                                                    | `4Gi`             |

The above parameters map to the env variables defined in [tobybatch/kimai2](https://github.com/tobybatch/kimai2). For more information please refer to the [tobybatch/kimai2](https://github.com/tobybatch/kimai2) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set KimaiUsername=admin \
  --set KimaiPassword=password \
  --set mariadb.auth.rootPassword=secretpassword \
    kimai2/docs/helm
```

The above command sets the Kimai administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install kimai -f values.yaml kimai2/docs/helm
```