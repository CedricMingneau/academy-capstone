from pyspark.sql import SparkSession
from pyspark import SparkConf, SparkContext
from pyspark.sql import functions as sqf

import json

from secrets_manager import get_secrets

def create_spark_session() -> SparkSession:
    conf = SparkConf()
    conf.set('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.1.2,net.snowflake:spark-snowflake_2.12:2.9.0-spark_3.1,net.snowflake:snowflake-jdbc:3.13.3')
    conf.set('fs.s3a.aws.credentials.provider', 'com.amazonaws.auth.DefaultAWSCredentialsProviderChain')
    conf.set('fs.s3a.impl', 'org.apache.hadoop.fs.s3a.S3AFileSystem')

    # alternatively:
    # spark = (
    #     SparkSession.builder
    #         .config('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.1.2,net.snowflake:spark-snowflake_2.12:2.9.0-spark_3.1,net.snowflake:snowflake-jdbc:3.13.3')
    #         .config('fs.s3a.aws.credentials.provider', 'com.amazonaws.auth.DefaultAWSCredentialsProviderChain')
    #         .config('fs.s3a.impl', 'org.apache.hadoop.fs.s3a.S3AFileSystem')
    #         .getOrCreate()
    # )

    spark = SparkSession.builder.config(conf=conf).getOrCreate()

    return spark


def read_data():
    return create_spark_session().read.json('s3a://dataminded-academy-capstone-resources/raw/open_aq/data_part_1.json')


def flatten(df):
    return df.select(
        [
            "city", "coordinates.latitude", "coordinates.longitude", "country", 
            "date.local", "date.utc", "entity", "isAnalysis", "isMobile", 
            "location", "locationId", "parameter", "sensorType", "unit", "value"
        ]
    )


# Doesn't do anything...
def cast_to_datetime(df):
    return flattened.select(sqf.to_timestamp("local", "yyyy-MM-dd'T'HH:mm:ss+S"))


def write_to_snowflake(df):
    credentials = get_secrets()
    secret_string = credentials["SecretString"]

    secrets = json.loads(secret_string)

    SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

    sfOptions = {
        "sfURL" : secrets["URL"] + ".snowflakecomputing.com",
        "sfUser" : secrets["USER_NAME"],
        "sfPassword": secrets["PASSWORD"],
        "sfRole": secrets["ROLE"],
        "sfDatabase" : secrets["DATABASE"],
        "sfSchema" : "CEDRIC",
        "sfWarehouse" : secrets["WAREHOUSE"]
    }

    (df.write
        .format(SNOWFLAKE_SOURCE_NAME)
        .options(**sfOptions)
        .option("dbtable", "CEDRIC")
        .mode("overwrite")
        .save())



# show schema
df = read_data()
flattened = flatten(df)

flattened.printSchema()

write_to_snowflake(flattened)
