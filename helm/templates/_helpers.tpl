{{/*
Expand the name of the Kimai component.
*/}}
{{- define "kimai.name" -}}
{{- default "kimai" .Values.kimai.nameOverride }}
{{- end }}

{{/*
Expand the name of the MySQL component.
*/}}
{{- define "mysql.name" -}}
{{- default "mysql" .Values.mysql.nameOverride }}
{{- end }}

{{/*
Create the database URL. For the time being, this supports only an integrated MySQL
*/}}
{{- define "application.databaseUrl" -}}
{{- if eq .Values.kimai.database.type "mysql" -}}
mysql://{{ .Values.kimai.database.kimaiUser }}:{{ .Values.kimai.database.kimaiPassword }}@additional-{{ include "mysql.name" . }}/{{ .Values.kimai.database.databaseName }}
{{- else -}}
This is rubbish
{{- end -}}
{{- end }}

{{/*
Create the database URL. For the time being, this supports only an integrated MySQL
*/}}
{{- define "kimai.imageTag" -}}
{{ .Values.kimai.flavor }}-{{ .Values.kimai.version }}-{{ .Values.kimai.environment }}
{{- end }}


{{- define "kimai-helmchart.ingress.fqdn.kimai" -}}
{{- if .Values.ingress.kimai.domain -}}
{{ default "kimai" .Values.ingress.kimai.name }}.{{ .Values.ingress.kimai.domain }}
{{- else -}}
{{ default "kimai" .Values.ingress.kimai.name }}.{{ .Values.ingress.defaultDomain }}
{{- end -}}
{{- end }}
