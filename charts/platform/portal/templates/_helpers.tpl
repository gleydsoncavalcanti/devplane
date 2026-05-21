{{- define "devplane-portal.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "devplane-portal.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- include "devplane-portal.name" . | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "devplane-portal.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{ include "devplane-portal.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "devplane-portal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "devplane-portal.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
