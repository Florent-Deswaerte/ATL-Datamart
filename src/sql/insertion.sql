CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP SERVER IF EXISTS remote_server CASCADE;

CREATE SERVER IF NOT EXISTS remote_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', port '5432', dbname 'nyc_warehouse');

CREATE USER MAPPING FOR user
SERVER remote_server
OPTIONS (user 'postgres', password 'admin');

CREATE FOREIGN TABLE nyc_raw (
    vendorid int4 NULL,
    tpep_pickup_datetime timestamp NULL,
    tpep_dropoff_datetime timestamp NULL,
    passenger_count float8 NULL,
    trip_distance float8 NULL,
    ratecodeid float8 NULL,
    store_and_fwd_flag text NULL,
    pulocationid int4 NULL,
    dolocationid int4 NULL,
    payment_type int8 NULL,
    fare_amount float8 NULL,
    extra float8 NULL,
    mta_tax float8 NULL,
    tip_amount float8 NULL,
    tolls_amount float8 NULL,
    improvement_surcharge float8 NULL,
    total_amount float8 NULL,
    congestion_surcharge float8 NULL,
    airport_fee float8 NULL
)
SERVER remote_server
OPTIONS (schema_name 'public', table_name 'nyc_raw');


INSERT INTO Trip (
    passenger_count, 
    trip_distance, 
    tpep_pickup_datetime, 
    tpep_dropoff_datetime, 
    total_amount, 
    tolls_amount, 
    tip_amount, 
    airport_fee, 
    congestion_surcharge, 
    improvement_surcharge, 
    fare_amount, 
    extra, 
    Id_mta, 
    Id_Payement_type, 
    Id_Rate, 
    Id_Taxi_zone, 
    Id_Taxi_zone_1, 
    Id_Vendor, 
    Id_Store_and_forward
)
SELECT 
    nr.passenger_count, 
    nr.trip_distance, 
    nr.tpep_pickup_datetime, 
    nr.tpep_dropoff_datetime, 
    nr.total_amount, 
    nr.tolls_amount, 
    nr.tip_amount, 
    nr.airport_fee, 
    nr.congestion_surcharge, 
    nr.improvement_surcharge, 
    nr.fare_amount, 
    nr.extra, 
    (SELECT Id_mta FROM mta WHERE amount = nr.mta_tax), 
    (SELECT Id_Payement_type FROM Payement_type WHERE Id_Payement_type = nr.payment_type), 
    (SELECT Id_Rate FROM Rate WHERE Id_Rate = nr.ratecodeid), 
    nr.pulocationid, 
    nr.dolocationid, 
    (SELECT Id_Vendor FROM Company WHERE Id_Vendor = nr.vendorid), 
    (SELECT Id_Store_and_forward FROM Store_and_forward WHERE shortcut = nr.store_and_fwd_flag)
FROM nyc_raw as nr
LIMIT 1000;