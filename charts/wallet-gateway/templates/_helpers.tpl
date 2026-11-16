{{/*
Render a Secret-based environment variable for envName.
The mapping is looked up in oauthSecrets.
If there is no mapping, the render fails when required is set.
*/}}
{{- define "wallet-gateway.render.secretEnv" -}}
{{- $root := .root -}}
{{- $envName := .envName -}}
{{- /* Look up the envName in the oauthSecrets map */ -}}
{{- $mapping := index ($root.Values.oauthSecrets | default (dict)) $envName -}}
{{- if $mapping -}}
  {{- if and $mapping.secretRef $mapping.secretRef.name $mapping.secretRef.key -}}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ $mapping.secretRef.name | quote }}
      key: {{ $mapping.secretRef.key | quote }}
  {{- end -}}
{{- else if .required -}}
  {{- fail (printf "Environment variable '%s' is requested in config but not defined in oauthSecrets" $envName) -}}
{{- end -}}
{{- end -}}
