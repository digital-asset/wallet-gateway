{{/*
Helper to render a Secret-based environment variable.
*/}}
{{- define "wallet-gateway.render.secretEnv" -}}
{{- $root := .root -}}
{{- $envName := .envName -}}
{{- /* Look up the envName in the oauthSecrets map */ -}}
{{- if hasKey $root.Values.oauthSecrets $envName -}}
  {{- $mapping := index $root.Values.oauthSecrets $envName -}}
  {{- if and $mapping.secretRef $mapping.secretRef.name $mapping.secretRef.key -}}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ $mapping.secretRef.name | quote }}
      key: {{ $mapping.secretRef.key | quote }}
  {{- end -}}
{{- else -}}
  {{- fail (printf "Environment variable '%s' is requested in config but not defined in oauthSecrets" $envName) -}}
{{- end -}}
{{- end -}}
