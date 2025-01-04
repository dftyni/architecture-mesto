docker compose exec -T shard1-mongodb1 mongosh <<EOF
rs.initiate({_id: "shard1", members: [
  {_id: 0, host: "shard1-mongodb1"},
  {_id: 1, host: "shard1-mongodb2"},
  {_id: 2, host: "shard1-mongodb3"}
]});
exit();
EOF