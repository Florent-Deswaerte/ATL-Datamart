from minio import Minio
import urllib.request as request
import pandas as pd
from io import BytesIO
import sys
from dateutil.relativedelta import relativedelta
import datetime
import os

def main():
    write_data_minio()
    
path_storage = './data/raw'

default_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_"
ext = ".parquet"
    
months = [
    "2023-11",
    "2023-12"
]

def grab_data() -> None:
    for i, month in enumerate(months):
        url = f'{default_url}{month}{ext}'
        response = request.urlopen(url)
        df = pd.read_parquet(BytesIO(response.read()))
        df.to_parquet(f'{path_storage}/data_{month}.parquet')
        print(df.head())
        
def grab_data_minus_x(month_ago) -> None:
    date_x_months_ago = datetime.datetime.now() - relativedelta(months=month_ago)
    month = date_x_months_ago.strftime("%Y-%m")
    url = f'{default_url}{month}{ext}'
    response = request.urlopen(url)
    df = pd.read_parquet(BytesIO(response.read()))
    df.to_parquet(f'{path_storage}/data_{month}.parquet')
    print(df.head())
    
def write_data_minio():
    client = Minio(
        "localhost:9000",
        secure=False,
        access_key="minio",
        secret_key="minio123"
    )
    bucket: str = "nycyellowtaxi"
    found = client.bucket_exists(bucket)
    if not found:
        client.make_bucket(bucket)
    else:
        print("Bucket : " + bucket + ", already exists")
        
    for filename in os.listdir(path_storage):
        if filename.endswith(ext):
            filepath = os.path.join(path_storage, filename)
            client.fput_object(bucket, filename, filepath)
            print(f"Uploaded {filename} to bucket {bucket}")

if __name__ == '__main__':
    sys.exit(main())