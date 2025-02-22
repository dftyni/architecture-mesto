rs.initiate(
    {
        _id: "config_server",
        configsvr: true,
        version: 1,
        members: [
            { _id: 0, host: "configSrv:27017" }
        ]
    }
);