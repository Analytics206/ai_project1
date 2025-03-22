import psycopg2

conn = psycopg2.connect(
    dbname="mydb",
    user="admin",
    password="password",
    host="postgres",
    port="5432"
)

cur = conn.cursor()

# Create a table
cur.execute("CREATE TABLE IF NOT EXISTS test (id SERIAL PRIMARY KEY, message TEXT)")

# Insert data
cur.execute("INSERT INTO test (message) VALUES (%s)", ("Hello, PostgreSQL!",))
conn.commit()

# Query data
cur.execute("SELECT * FROM test")
rows = cur.fetchall()
for row in rows:
    print("Query result:", row)

cur.close()
conn.close()