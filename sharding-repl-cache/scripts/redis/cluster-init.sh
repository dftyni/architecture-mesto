docker compose exec -it redis_1 sh --quiet <<EOF
echo "yes" | redis-cli --cluster create
    173.19.0.21:6379   
    173.19.0.22:6379   
    173.19.0.23:6379   
    173.19.0.24:6379   
    173.19.0.25:6379   
    173.19.0.26:6379   
    --cluster-replicas 1 
EOF

# Probably it would be better to one-line...
# echo "yes" | redis-cli --cluster create 173.19.0.21:6379 173.19.0.22:6379 173.19.0.23:6379 173.19.0.24:6379 173.19.0.25:6379 173.19.0.26:6379 --cluster-replicas 1