docker compose exec -T shard2-mongodb1 mongosh <<EOF
rs.initiate({_id: "shard2", members: [
  {_id: 0, host: "shard2-mongodb1"},
  {_id: 1, host: "shard2-mongodb2"},
  {_id: 2, host: "shard2-mongodb3"}
]});
exit();
EOF