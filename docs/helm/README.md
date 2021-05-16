# Kimai

[Kimai](https://kimai.org/)  is a free & open source timetracker. It tracks work time and prints out a summary of your activities on demand. Yearly, monthly, daily, by customer, by project … Its simplicity is its strength.

## TL;DR

```console
$ git clone https://github.com/tobybatch/kimai2.git
$ helm install kimai kimai2/docs/helm
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
$ helm install kimai kimai2/docs/helm
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






A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| default.storageClass | string | `nil` | Possibility to override the storage class. If left empty, your default storage class will be used |
| images.mysql.name | string | `"mysql"` | Image name for MySQL |
| images.mysql.tag | string | `"5.7"` | Image tag for MySQL |
| ingress.defaultDomain | string | `"local"` | Default domain for ingress definitions. Can be overridden by the component specific settings |
| ingress.kimai.domain | string | `nil` | Optional possibility to declare a specific domain for Kimai |
| ingress.kimai.hostName | string | `nil` | Host name for Kimai. Defaults to kimai |
| ingress.kimai.tlsSecret | string | `"add-you-own-here"` | Certificate for Kimai |
| kimai.database | object | `{"databaseName":"kimai","kimaiPassword":"kimai","kimaiUser":"kimai"}` | Configuration of the database for Kimai |
| kimai.database.databaseName | string | `"kimai"` | MySQL database name for Kimai |
| kimai.database.kimaiPassword | string | `"kimai"` | MySQL database password for Kimai |
| kimai.database.kimaiUser | string | `"kimai"` | MySQL database user for Kimai |
| kimai.initialization.admin.email | string | `"admin@kimai.local"` | Email for the superadmin account |
| kimai.initialization.admin.password | string | `"changemeplease"` | Password for the superadmin account |
| kimai.nameOverride | string | `nil` | Possibility to override the name of the Kimai component |
| kimai.pvc.var.size | string | `"4Gi"` | Size for the PVC var for Kimai |
| kimai.resources.limits.cpu | string | `"1000m"` |  |
| kimai.resources.limits.memory | string | `"512Mi"` |  |
| kimai.resources.requests.cpu | string | `"500m"` |  |
| kimai.resources.requests.memory | string | `"256Mi"` |  |
| kimai.version | string | `"master"` | Kimai version. This is used to determine which tag should be used for Kimai itself. If you change this, ensure, that the corresponding tag already exists at Docker Hub. The tag is formed following the pattern `apache-debian-<kimai.version>-prod`. |
| metadata.applicationName | string | `"kimai"` | Name for the whole application. Used at different places for labels and naming of components. |
| mysql.nameOverride | string | `nil` | Possibility to override the name of the Kimai components |
| mysql.pvc.data.size | string | `"4Gi"` | Size for the PVC data for MySQL |
| mysql.resources.limits.cpu | string | `"2000m"` |  |
| mysql.resources.limits.memory | string | `"4096Mi"` |  |
| mysql.resources.requests.cpu | string | `"1000m"` |  |
| mysql.resources.requests.memory | string | `"512Mi"` |  |
| mysql.rootPassword | string | `"changemeplease"` | Password for the MySQL root user |
