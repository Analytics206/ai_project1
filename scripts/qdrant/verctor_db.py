from qdrant_client import QdrantClient
from qdrant_client.models import VectorParams, Distance

client = QdrantClient(host="qdrant", port=6333)

# Create a collection
client.create_collection(
    collection_name="test_collection",
    vectors_config=VectorParams(size=4, distance=Distance.COSINE)
)

# Insert a vector
client.upsert(
    collection_name="test_collection",
    points=[
        {
            "id": 1,
            "vector": [0.1, 0.2, 0.3, 0.4],
            "payload": {"message": "Hello, Qdrant!"}
        }
    ]
)

# Query the vector
result = client.search(
    collection_name="test_collection",
    query_vector=[0.1, 0.2, 0.3, 0.4],
    limit=1
)

print("Query result:", result)