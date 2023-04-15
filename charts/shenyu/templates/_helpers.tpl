{{- define "shenyu.h2.url" }}
    {{-  .Values.dataSource.h2.url | default "jdbc:h2:mem:~/shenyu;DB_CLOSE_DELAY=-1;MODE=MySQL;" }}
{{- end -}}

{{- define "shenyu.mysql.url" -}}
{{- with .Values.dataSource.mysql -}}
    {{- if .urlOverride -}}
        {{- .urlOverride | quote -}}
    {{- else -}}
        jdbc:mysql://{{ required ".dataSource.mysql.ip is required" .ip }}:{{ .port }}/{{ required "" .database | default "shenyu" }}?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=Asia/Shanghai&zeroDateTimeBehavior=convertToNull
    {{- end }}
{{- end }}
{{- end -}}

{{- define "shenyu.pg.url" -}}
{{- with .Values.dataSource.pg -}}
    {{- if .urlOverride -}}
        {{- .urlOverride -}}
    {{- else -}}
        jdbc:postgresql://{{ .ip }}:{{ .port }}/{{ .database | default "shenyu" }}
    {{- end }}
{{- end }}
{{- end -}}

{{- define "shenyu.oracle.url" -}}
{{- with .Values.dataSource.oracle -}}
    {{- if .urlOverride -}}
        {{- .urlOverride -}}
    {{- else -}}
        jdbc:oracle:thin:@{{ .ip }}:{{ .port }}/{{ .serviceName | default "shenyu" }}
    {{- end }}
{{- end }}
{{- end -}}
