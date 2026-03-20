{{/*
Helper to render a Secret-based environment variable.
Usage: {{ include "wallet-gateway.render.secretEnv" (dict "root" $ "envName" .auth.clientSecret) }}
*/}}
{{- define "wallet-gateway.render.secretEnv" -}}
{{- $root := .root -}}
{{- $envName := .envName -}}
{{- if hasKey $root.Values.oauthSecrets $envName -}}
{{- $mapping := index $root.Values.oauthSecrets $envName -}}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ $mapping.secretName }}
      key: {{ $mapping.secretKey }}
{{- else -}}
{{- fail (printf "Environment variable '%s' is requested in config but not defined in oauthSecrets" $envName) -}}
{{- end -}}
{{- end -}}
