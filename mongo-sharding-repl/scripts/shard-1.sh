docker compose exec -T shard1-primary mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-primary:27018" },
        { _id : 1, host : "shard1-secondary1:27019" },
        { _id : 2, host : "shard1-secondary2:27020" },
      ]
    }
);
exit();
EOF