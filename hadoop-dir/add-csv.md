📁 Step-by-Step: Add a CSV File to HDFS

Let’s say you have a file called flows.csv in your local machine:
✅ 1. Start HDFS (if not running)

Make sure HDFS is up:
```bash
start-dfs.sh
```
Check processes with:
```bash
jps
```
Look for: NameNode, DataNode, etc.
✅ 2. Create a Directory in HDFS (optional)

This helps keep files organized:
```bash
hdfs dfs -mkdir -p /packets
```
✅ 3. Put the CSV File into HDFS

Let’s say flows.csv is in your home folder:
```bash
hdfs dfs -put ~/flows.csv /packets/
```
You can also use an absolute path:
```bash
hdfs dfs -put /home/youruser/data/flows.csv /packets/
```
✅ 4. Confirm It's There
```bash
hdfs dfs -ls /packets
```
You should see:

Found 1 items
-rw-r--r--   1 youruser supergroup    123456 2025-04-18 08:00 /packets/flows.csv

✅ 5. Test Read from PySpark (Optional)

In your PySpark script or shell:

```python
df = spark.read.csv("hdfs://localhost:9000/packets/flows.csv", header=True, inferSchema=True)
df.show(5)
```
