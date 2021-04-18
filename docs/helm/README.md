# kimai-helmchart

In order to allow an easy deployment on Kubernetes, we provide a Helm chart (https://helm.sh). The chart allows a parameterized deployment of Kimai on Kubernetes, using the Docker images also used for the standard docker deployment. This Helm chart only allows the deployment with Apache and MySQL.

# Chart Documentation

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

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
