docker compose exec -T shard2-primary mongosh --port 27021 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-primary:27021" },
        { _id : 1, host : "shard2-secondary1:27022" },
        { _id : 2, host : "shard2-secondary2:27023" },
      ]
    }
);
exit();
EOF