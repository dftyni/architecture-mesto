docker compose exec -it shard1-repl1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
  { 
    _id: "shard1", 
    members: [
      {
        _id: 0,
        host: "shard1-repl1:27018"
      },
      {
        _id: 1,
        host: "shard1-repl2:27019"
      },
    ]
  }
)
exit()
EOF

docker compose exec -it shard2-repl1 mongosh --port 27020 --quiet <<EOF
rs.initiate(
  {
    _id: "shard2",
    members: [
      {
        _id: 0,
        host: "shard2-repl1:27020"
      },
      {
        _id: 1,
        host: "shard2-repl2:27021"
      },
    ]
  }
)
exit()
EOF