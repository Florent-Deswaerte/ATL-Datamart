from sqlalchemy import create_engine, text
import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


def create_database(db_config, db_name):
    conn = psycopg2.connect(
        dbname="postgres",
        user=db_config["dbms_username"],
        password=db_config["dbms_password"],
        host=db_config["dbms_ip"],
        port=db_config["dbms_port"]
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)

    cur = conn.cursor()
    cur.execute(f"CREATE DATABASE {db_name};")

    cur.close()
    conn.close()
    
def execute_sql_file(filename):
    with open(filename, 'r') as file:
        sql = text(file.read())
    with engine.connect() as connection:
        connection.execute(sql)
        connection.commit()
        connection.close()

def connect_and_execute_sql_file(db_config, file):
    global engine
    db_config["database_url"] = (
        f"{db_config['dbms_engine']}://{db_config['dbms_username']}:{db_config['dbms_password']}@"
        f"{db_config['dbms_ip']}:{db_config['dbms_port']}/{db_config['dbms_database']}"
    )
    engine = create_engine(db_config["database_url"])
    execute_sql_file(file)

def main() -> None:
    db_config = {
        "dbms_engine": "postgresql",
        "dbms_username": "postgres",
        "dbms_password": "admin",
        "dbms_ip": "localhost",
        "dbms_port": "15432",
        "dbms_database": "nyc_flacon_warehouse",
    }
    try:
        create_database(db_config, "nyc_flacon_warehouse")
    except Exception as e:
        print(f"Error creating database: {e}")
     
    print("Creating tables")
    connect_and_execute_sql_file(db_config, 'src/sql/create.sql')
    
    print("Inserting data")
    connect_and_execute_sql_file(db_config, 'src/sql/insertion.sql')

if __name__ == '__main__':
    sys.exit(main())