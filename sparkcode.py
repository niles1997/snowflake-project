from pyspark.sql import *
from pyspark.sql.functions import *

spark = SparkSession.builder.master("local[*]").appName("test").getOrCreate()

data = 's3://raw--bucket/inputdata/asl.csv'
df = spark.read.format('csv').option('header', 'true').option('inferSchema','true').load(data)
res=df.withColumn('agegroup',
                  when(col('age')<20,'kid')
                  .when(col('age')>50,'senior')
                  .when(col('age').isin(20,25),'adult')
                  .otherwise('Male'))
res.write.format('csv').option('header', 'true').save('s3://output-landingbucket/outputdata/snowfile')
print('done')
