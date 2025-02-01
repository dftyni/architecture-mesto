# templates/nginx.conf.tpl

upstream backend {
  {{ range service "pymongo_api" }}
  server {{ .Address }}:{{ .Port }};
  {{ end }}
}

server {
  listen 80;

  location / {
    proxy_pass http://backend;
  }

  location /health {
      return 200 'OK';
  }
}