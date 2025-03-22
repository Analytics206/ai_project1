from pymongo import MongoClient

client = MongoClient("mongodb://admin:password@mongodb:27017")
db = client.mydb
collection = db.test

# Insert data
collection.insert_one({"message": "Hello, MongoDB!"})

# Query data
result = collection.find_one({"message": "Hello, MongoDB!"})
print("Query result:", result)