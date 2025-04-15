docker compose exec -T <service-name> mongosh --port <mongo port> --quiet <<EOF
<mongosh commands here>
EOF