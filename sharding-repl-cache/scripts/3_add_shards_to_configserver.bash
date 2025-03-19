#!/bin/bash


# Создаем шарды:

docker exec -it shard1-r1 mongosh --port 27021

> rs.initiate(
  {
    _id : "shard1",
    members: [
      { _id : 0, host : "shard1-r1:27021" },
      { _id : 1, host : "shard1-r2:27022" },
      { _id : 2, host : "shard1-r3:27023" },
    ]
  }
);
exit();

docker exec -it shard2-r1 mongosh --port 27031

rs.initiate(
  {
    _id : "shard2",
    members: [
      { _id : 0, host : "shard2-r1:27031" },
      { _id : 1, host : "shard2-r2:27032" },
      { _id : 2, host : "shard2-r3:27033" },
    ]
  }
);

> exit();
