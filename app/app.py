from flask import Flask, request
from redis.cluster import RedisCluster
import os

app = Flask(__name__)

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))    # default 6379
REDIS_USERNAME = os.getenv("REDIS_USERNAME")
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD")

# Validate required variables
missing = [v for v in ["REDIS_HOST", "REDIS_USERNAME", "REDIS_PASSWORD"] if os.getenv(v) is None]
if missing:
    raise ValueError(f"Missing environment variables: {', '.join(missing)}")


# Create Redis client
r = RedisCluster(
    host=REDIS_HOST,
    port=REDIS_PORT,
    username=REDIS_USERNAME,
    password=REDIS_PASSWORD,
    decode_responses=True,
    ssl=True, ssl_cert_reqs="none",

)

@app.route("/")
def index():

    # Global counter key
    redis_key = "total_page_visits"

    # Increment global counter
    count = r.incr(redis_key)

    return f"This webpage has been visited {count} times.\n"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)