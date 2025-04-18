from pyspark.sql import SparkSession

def main():
    # Initialize Spark session
    spark = SparkSession.builder \
        .appName("ReadFromHDFS") \
        .master("local[*]") \
        .config("spark.hadoop.fs.defaultFS", "hdfs://localhost:9000") \
        .getOrCreate()

    # Example: Read a simple text file from HDFS
    rdd = spark.sparkContext.textFile("hdfs://localhost:9000/test/hello.txt")
    print("Contents of hello.txt from HDFS:")
    for line in rdd.collect():
        print(line)

    # Example: Read CSV from HDFS (if available)
    #try:
    #    df = spark.read.csv("hdfs://localhost:9000/packets/flows.csv", header=True, inferSchema=True)
    #    print("Preview of flows.csv:")
    #    df.show(5)
    #except Exception as e:
    #    print("Could not read CSV:", e)

    # Stop Spark
    spark.stop()

if __name__ == "__main__":
    main()
