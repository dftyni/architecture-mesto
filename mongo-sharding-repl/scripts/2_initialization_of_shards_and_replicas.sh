###
# Инициализация шардов и реплик
###

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1:27018" },
        { _id : 1, host : "shard1-1:27021" },
        { _id : 2, host : "shard1-2:27022" },
        { _id : 3, host : "shard1-3:27023" },
      ]
    }
);
exit();
EOF

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 4, host : "shard2:27019" },
        { _id : 5, host : "shard2-1:27024" },
        { _id : 6, host : "shard2-2:27025" },
        { _id : 7, host : "shard2-3:27026" },
      ]
    }
  );
exit();
EOF