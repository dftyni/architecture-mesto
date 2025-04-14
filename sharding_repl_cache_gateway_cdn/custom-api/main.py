from fastapi import FastAPI
import os
from pymongo import MongoClient
import redis
import json

app = FastAPI()

INSTANCE_NAME = os.getenv("INSTANCE_NAME", "default")

MONGODB_URL = os.environ["MONGODB_URL"]
MONGODB_DATABASE_NAME = os.environ["MONGODB_DATABASE_NAME"]
REDIS_URL = os.environ.get("REDIS_URL")

mongo_client = MongoClient(MONGODB_URL)
db = mongo_client[MONGODB_DATABASE_NAME]

r = redis.Redis.from_url(REDIS_URL) if REDIS_URL else None

@app.get("/helloDoc/users")
def get_users():
    key = f"users:{MONGODB_DATABASE_NAME}:helloDoc"
    if r:
        cached = r.get(key)
        if cached:
            return {
                "instance": INSTANCE_NAME,
                "cached": True,
                "data": json.loads(cached)
            }

    data = list(db.helloDoc.find({}, {"_id": 0}))
    if r:
        r.set(key, json.dumps(data), ex=60)

    return {
        "instance": INSTANCE_NAME,
        "cached": False,
        "data": data
    }
