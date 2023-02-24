import os
import sys
from datetime import datetime, timedelta
from typing import Dict, Union
from pymongo import MongoClient


def get_config() -> Dict[str, Union[str, int, float]]:
    """
    Read the configuration values from environment variables.

    Returns:
        A dictionary containing the configuration values.
    """
    required_vars = {
        "MONGO_HOST": str,
        "MONGO_PORT": int,
        "MONGO_DBNAME": str,
        "MONGO_USERNAME": str,
        "MONGO_PASSWORD": str,
        "MONGO_DEADLINE": float,
    }
    config = {k.lower(): required_vars[k](
        os.environ[k]) for k in required_vars}
    return config


def main() -> None:
    """
Connect to MongoDB, authenticate, and remove old documents from the database.
    """
    config = get_config()

    mongo = MongoClient(**config)
    db = mongo[config["mongo_dbname"]]
    db.authenticate(**config)

    history_timestamp = int(
        (datetime.now() -
         timedelta(days=int(config["mongo_deadline"]))).timestamp() * 1000
    )
    collections = db.list_collection_names()
    collections_to_clean = [
        c for c in collections if "transaction" in c or "block" in c or "contract" in c
    ]
    for collection in collections_to_clean:
        db[collection].delete_many({"timeStamp": {"$lt": history_timestamp}})


if __name__ == "__main__":
    try:
        print("Init: Running a scheduled database clean up job")
        main()
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
