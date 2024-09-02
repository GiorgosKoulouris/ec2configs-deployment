{{- define "backend.calcValue.DB_HOST" -}}
{{- if .Values.database.create -}}
"{{ .Values.database.name }}-svc"
{{- else -}}
"{{ .Values.backend.DB_HOST }}"
{{- end -}}
{{- end -}}

{{- define "backend.calcValue.DB_PORT" -}}
{{- if .Values.database.create -}}
{{ .Values.database.servicePort }}
{{- else -}}
"{{ .Values.backend.DB_PORT }}"
{{- end -}}
{{- end -}}

{{- define "frontend.calcValue.backendURL" -}}
"https://{{ .Values.ingress.domain }}/api"
{{- end -}}

{{- define "imageIDs.frontend" -}}
"{{ .Values.frontend.image }}:{{ .Values.appVersion }}"
{{- end -}}
{{- define "imageIDs.backend" -}}
"{{ .Values.backend.image }}:{{ .Values.appVersion }}"
{{- end -}}
{{- define "imageIDs.database" -}}
"{{ .Values.database.image }}:{{ .Values.appVersion }}"
{{- end -}}
{{- define "imageIDs.terraform" -}}
"{{ .Values.jobs.images.tf }}:{{ .Values.appVersion }}"
{{- end -}}
{{- define "imageIDs.python" -}}
"{{ .Values.jobs.images.py }}:{{ .Values.appVersion }}"
{{- end -}}