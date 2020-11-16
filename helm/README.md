# kimai-helmchart

# Chart Documentation

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| default.storageClass | string | `nil` | possibility to override the storage class. If left empty, your default storage class will be used |
| images.kimai.name | string | `"kimai/kimai2"` | image name for Kimai. Do not change! |
| images.kimai.tag | string | `nil` | This is generated automaticaly from kimai.version, kimai, flavor and kimai.environment. Do only change this if you know what you are doing! |
| images.mysql.name | string | `"mysql"` | image name for MySQL |
| images.mysql.tag | string | `"5.7"` | image tag for MySQL |
| ingress.defaultDomain | string | `"local"` | default domain for ingress definitions. Can be overridden by the component specific settings |
| ingress.kimai.domain | string | `nil` | optional possibility to declare a specific domain for Kimai |
| ingress.kimai.hostName | string | `nil` | host name for Kimai. Defaults to kimai |
| ingress.kimai.tlsSecret | string | `"add-you-own-here"` | certificate for Kimai |
| kimai.database | object | `{"databaseName":"kimai","kimaiPassword":"kimai","kimaiUser":"kimai"}` | configuration of the database for Kimai |
| kimai.database.databaseName | string | `"kimai"` | MySQL database name for Kimai |
| kimai.database.kimaiPassword | string | `"kimai"` | MySQL database password for Kimai |
| kimai.database.kimaiUser | string | `"kimai"` | MySQL database user for Kimai |
| kimai.flavor | string | `"apache-debian"` | flavor of the image that should be used. Only apache/debian is supported at the moment, so  do not change this. |
| kimai.initialization.admin.email | string | `"admin@kimai.local"` | email for the superadmin account |
| kimai.initialization.admin.password | string | `"changemeplease"` | password for the superadmin account |
| kimai.nameOverride | string | `nil` | possibility to override the name of the Kimai components |
| kimai.pvc.var.size | string | `"4Gi"` | size for the var pvc for Kimai |
| kimai.resources.limits.cpu | string | `"1000m"` |  |
| kimai.resources.limits.memory | string | `"512Mi"` |  |
| kimai.resources.requests.cpu | string | `"500m"` |  |
| kimai.resources.requests.memory | string | `"256Mi"` |  |
| kimai.version | string | `"master"` | Kimai version. This is used to determine which tag should be used for Kimai itself. If you change this, ensure, that the corresponding tag already exists at Docker Hub. |
| metadata.applicationName | string | `"kimai"` | name for the whole application. Used at different places for labels and naming of components. |
| mysql.enabled | bool | `true` | enable/disable the deployment of MySQL. If disabled, you must choose sqlite for kimai.database.type |
| mysql.nameOverride | string | `nil` | possibility to override the name of the Kimai components |
| mysql.pvc.data.size | string | `"4Gi"` | size for the data pvc for MySQL |
| mysql.resources.limits.cpu | string | `"2000m"` |  |
| mysql.resources.limits.memory | string | `"4096Mi"` |  |
| mysql.resources.requests.cpu | string | `"1000m"` |  |
| mysql.resources.requests.memory | string | `"512Mi"` |  |
| mysql.rootPassword | string | `"changemeplease"` | password for the MySQL root user |
