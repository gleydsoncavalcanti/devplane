{{- define "devplane-application.name" -}}
{{- default .Values.app.name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "devplane-application.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "devplane-application.name" . | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "devplane-application.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "devplane-application.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
devplane.io/app: {{ .Values.app.name | quote }}
{{- end }}

{{- define "devplane-application.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devplane-application.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "devplane-application.postgresName" -}}
{{ include "devplane-application.fullname" . }}-postgres
{{- end }}
