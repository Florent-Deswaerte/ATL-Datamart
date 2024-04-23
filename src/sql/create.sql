

CREATE TABLE Payement_type(
   Id_Payement_type SERIAL,
   tittle VARCHAR(255),
   PRIMARY KEY(Id_Payement_type)
);

CREATE TABLE Store_and_forward(
   Id_Store_and_forward SERIAL,
   tittle VARCHAR(255),
   shortcut VARCHAR(1),
   PRIMARY KEY(Id_Store_and_forward)
);

CREATE TABLE Company(
   Id_Vendor SERIAL,
   tittle VARCHAR(255),
   PRIMARY KEY(Id_Vendor)
);

CREATE TABLE Taxi_zone(
   Id_Taxi_zone SERIAL,
   tittle VARCHAR(255),
   PRIMARY KEY(Id_Taxi_zone)
);

CREATE TABLE Rate(
   Id_Rate SERIAL,
   tittle VARCHAR(255),
   PRIMARY KEY(Id_Rate)
);

CREATE TABLE mta(
   Id_mta SERIAL,
   tittle VARCHAR(255),
   amount DECIMAL(15,2),
   PRIMARY KEY(Id_mta)
);

CREATE TABLE Trip(
   Id_Trip SERIAL,
   passenger_count DECIMAL(15,1),
   trip_distance DECIMAL(15,1),
   tpep_pickup_datetime TIMESTAMP,
   tpep_dropoff_datetime TIMESTAMP,
   total_amount DECIMAL(15,2),
   tolls_amount VARCHAR(50),
   tip_amount DECIMAL(15,2),
   congestion_surcharge DECIMAL(15,2),
   airport_fee VARCHAR(255),
   improvement_surcharge DECIMAL(15,2),
   fare_amount DECIMAL(15,2),
   extra DECIMAL(15,2),
   Id_mta INT NULL,
   Id_Payement_type INT NULL,
   Id_Rate INT NULL,
   Id_Taxi_zone INT NULL,
   Id_Taxi_zone_1 INT NULL,
   Id_Vendor INT NULL,
   Id_Store_and_forward INT NULL,
   PRIMARY KEY(Id_Trip),
   FOREIGN KEY(Id_mta) REFERENCES mta(Id_mta),
   FOREIGN KEY(Id_Payement_type) REFERENCES Payement_type(Id_Payement_type),
   FOREIGN KEY(Id_Rate) REFERENCES Rate(Id_Rate),
   FOREIGN KEY(Id_Taxi_zone) REFERENCES Taxi_zone(Id_Taxi_zone),
   FOREIGN KEY(Id_Taxi_zone_1) REFERENCES Taxi_zone(Id_Taxi_zone),
   FOREIGN KEY(Id_Vendor) REFERENCES Company(Id_Vendor),
   FOREIGN KEY(Id_Store_and_forward) REFERENCES Store_and_forward(Id_Store_and_forward)
);

INSERT INTO Company (tittle)
VALUES 
    ('Creative Mobile Technologies, LLC'),
    ('VeriFone Inc.');

INSERT INTO Rate (tittle)
VALUES 
    ('Standard rate'),
    ('JFK'),
    ('Newark'),
    ('Nassau or Westchester'),
    ('Negotiated fare'),
    ('Group ride');

INSERT INTO mta (tittle, amount)
VALUES 
    ('max', 0.5),
    ('null', 0),
    ('minus', -0.5);

INSERT INTO Store_and_forward (shortcut, tittle)
VALUES 
    ('Y', 'store and forward trip'),
    ('N', 'not a store and forward trip');

INSERT INTO Payement_type (tittle)
VALUES 
    ('Credit card'),
    ('Cash'),
    ('No charge'),
    ('Dispute'),
    ('Unknown'),
    ('Voided trip');

DO $$
DECLARE 
    i integer;
BEGIN
    FOR i IN 1..300
    LOOP
        INSERT INTO Taxi_zone (tittle)
        VALUES ('zone_' || i);
    END LOOP;
END $$;