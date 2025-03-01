# pymongo-api

## Как запустить

Запускаем mongodb и приложение

```shell
docker compose up -d
```

### Включаем шардирование и заполняем данными


Подключитесь к серверу конфигурации и сделайте инициализацию:

```shell
docker exec -it configSrv mongosh --port 27017

> rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
> exit();
```

Инициализируйте шарды:

```shell
docker exec -it shard1-1 mongosh --port 27018

> rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27018" },
        { _id : 1, host : "shard1-2:27019" },
        { _id : 2, host : "shard1-3:27020" }
      ]
    }
);
> exit();

docker exec -it shard2-1 mongosh --port 27021

> rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27021" },
        { _id : 1, host : "shard2-2:27022" },
        { _id : 2, host : "shard2-3:27023" }
      ]
    }
  );
> exit();
```

Проверить состояние реплик можно через команду:

```shell
docker exec -it shard2-1 mongosh --port 27021

> db.adminCommand( { replSetGetStatus: 1 } )
```

<details>
  <summary>Пример ответа:</summary>
  
```json
{
  set: 'shard2',
  date: ISODate('2025-02-26T19:20:52.035Z'),
  myState: 1,
  term: Long('1'),
  syncSourceHost: '',
  syncSourceId: -1,
  heartbeatIntervalMillis: Long('2000'),
  majorityVoteCount: 2,
  writeMajorityCount: 2,
  votingMembersCount: 3,
  writableVotingMembersCount: 3,
  optimes: {
    lastCommittedOpTime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
    lastCommittedWallTime: ISODate('2025-02-26T19:20:46.200Z'),
    readConcernMajorityOpTime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
    appliedOpTime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
    durableOpTime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
    writtenOpTime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
    lastAppliedWallTime: ISODate('2025-02-26T19:20:46.200Z'),
    lastDurableWallTime: ISODate('2025-02-26T19:20:46.200Z'),
    lastWrittenWallTime: ISODate('2025-02-26T19:20:46.200Z')
  },
  lastStableRecoveryTimestamp: Timestamp({ t: 1740597636, i: 1 }),
  electionCandidateMetrics: {
    lastElectionReason: 'electionTimeout',
    lastElectionDate: ISODate('2025-02-26T19:13:55.999Z'),
    electionTerm: Long('1'),
    lastCommittedOpTimeAtElection: { ts: Timestamp({ t: 1740597224, i: 1 }), t: Long('-1') },
    lastSeenWrittenOpTimeAtElection: { ts: Timestamp({ t: 1740597224, i: 1 }), t: Long('-1') },
    lastSeenOpTimeAtElection: { ts: Timestamp({ t: 1740597224, i: 1 }), t: Long('-1') },
    numVotesNeeded: 2,
    priorityAtElection: 1,
    electionTimeoutMillis: Long('10000'),
    numCatchUpOps: Long('0'),
    newTermStartDate: ISODate('2025-02-26T19:13:56.033Z'),
    wMajorityWriteAvailabilityDate: ISODate('2025-02-26T19:13:56.535Z')
  },
  members: [
    {
      _id: 0,
      name: 'shard2-1:27021',
      health: 1,
      state: 1,
      stateStr: 'PRIMARY',
      uptime: 517,
      optime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2025-02-26T19:20:46.000Z'),
      optimeWritten: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeWrittenDate: ISODate('2025-02-26T19:20:46.000Z'),
      lastAppliedWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastDurableWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastWrittenWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      syncSourceHost: '',
      syncSourceId: -1,
      infoMessage: '',
      electionTime: Timestamp({ t: 1740597236, i: 1 }),
      electionDate: ISODate('2025-02-26T19:13:56.000Z'),
      configVersion: 1,
      configTerm: 1,
      self: true,
      lastHeartbeatMessage: ''
    },
    {
      _id: 1,
      name: 'shard2-2:27022',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 427,
      optime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeWritten: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2025-02-26T19:20:46.000Z'),
      optimeDurableDate: ISODate('2025-02-26T19:20:46.000Z'),
      optimeWrittenDate: ISODate('2025-02-26T19:20:46.000Z'),
      lastAppliedWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastDurableWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastWrittenWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastHeartbeat: ISODate('2025-02-26T19:20:50.633Z'),
      lastHeartbeatRecv: ISODate('2025-02-26T19:20:51.506Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'shard2-1:27021',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 1,
      configTerm: 1
    },
    {
      _id: 2,
      name: 'shard2-3:27023',
      health: 1,
      state: 2,
      stateStr: 'SECONDARY',
      uptime: 427,
      optime: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeDurable: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeWritten: { ts: Timestamp({ t: 1740597646, i: 1 }), t: Long('1') },
      optimeDate: ISODate('2025-02-26T19:20:46.000Z'),
      optimeDurableDate: ISODate('2025-02-26T19:20:46.000Z'),
      optimeWrittenDate: ISODate('2025-02-26T19:20:46.000Z'),
      lastAppliedWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastDurableWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastWrittenWallTime: ISODate('2025-02-26T19:20:46.200Z'),
      lastHeartbeat: ISODate('2025-02-26T19:20:50.633Z'),
      lastHeartbeatRecv: ISODate('2025-02-26T19:20:51.506Z'),
      pingMs: Long('0'),
      lastHeartbeatMessage: '',
      syncSourceHost: 'shard2-1:27021',
      syncSourceId: 0,
      infoMessage: '',
      configVersion: 1,
      configTerm: 1
    }
  ],
  ok: 1,
  '$clusterTime': {
    clusterTime: Timestamp({ t: 1740597649, i: 1 }),
    signature: {
      hash: Binary.createFromBase64('AAAAAAAAAAAAAAAAAAAAAAAAAAA=', 0),
      keyId: Long('0')
    }
  },
  operationTime: Timestamp({ t: 1740597646, i: 1 })
}
```
</details><br/>

Аналогично для другой шарды.

Инцициализируйте роутер и наполните его тестовыми данными:

```shell
docker exec -it mongos_router mongosh --port 27024

> sh.addShard( "shard1/shard1-1:27018");
> sh.addShard( "shard1/shard1-2:27019");
> sh.addShard( "shard1/shard1-3:27020");
> sh.addShard( "shard2/shard2-1:27021");
> sh.addShard( "shard2/shard2-2:27022");
> sh.addShard( "shard2/shard2-3:27023");

> sh.enableSharding("somedb");
> sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

> use somedb

> for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})

> db.helloDoc.countDocuments() 
> exit();
```

Сделайте проверку на шардах:
```shell
 docker exec -it mongos_router mongosh --port 27024
 > use somedb;
 > db.helloDoc.getShardDistribution()
 > exit();
 ```

<details>
  <summary>Пример ответа:</summary>
  
  ```json
Shard shard1 at shard1/shard1:27018
{
  data: '22KiB',
  docs: 492,
  chunks: 1,
  'estimated data per chunk': '22KiB',
  'estimated docs per chunk': 492
}
---
Shard shard2 at shard2/shard2:27019
{
  data: '23KiB',
  docs: 508,
  chunks: 1,
  'estimated data per chunk': '23KiB',
  'estimated docs per chunk': 508
}
---
Totals
{
  data: '45KiB',
  docs: 1000,
  chunks: 2,
  'Shard shard1': [
    '49.17 % data',
    '49.2 % docs in cluster',
    '46B avg obj size on shard'
  ],
  'Shard shard2': [
    '50.82 % data',
    '50.8 % docs in cluster',
    '46B avg obj size on shard'
  ]
}
```
</details>

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Если вы запускаете проект на предоставленной виртуальной машине

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs