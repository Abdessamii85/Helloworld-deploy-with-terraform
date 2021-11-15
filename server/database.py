import mysql.connector, boto3, sys, os

ENDPOINT="MYDATABASE"
PORT="MYPORT"
USR="MYUSR"
REGION="us-west-1"
DBNAME="MYINSTANCE"
os.environ['LIBMYSQL_ENABLE_CLEARTEXT_PLUGIN'] = '1'
PASS="MYPASSWORD"

session = boto3.Session(profile_name='default')
client = session.client('rds')

token = client.generate_db_auth_token(DBHostname=ENDPOINT, Port=PORT, DBUsername=USR, Region=REGION)

try:
    conn =  mysql.connector.connect(host=ENDPOINT, user=USR, passwd=token, port=PORT, database=DBNAME, ssl_ca='[full path]rds-combined-ca-bundle.pem')
    cur = conn.cursor()
    cur.execute("""SELECT now()""")
         # Creating a new  table
        logging.info('Creating tables if not exists')
        c.execute('CREATE TABLE IF NOT EXISTS user_test (username TEXT PRIMARY KEY, date_of_birth TEXT NOT NULL)')
        c.execute('INSERT INTO user_test(username,date_of_birth) VALUES ("Charlie","1990-02-09")')
        DB.conn.commit()

        c.execute('PRAGMA synchronous=FULL')   
    query_results = cur.fetchall()
    print(query_results)
except Exception as e:
    print("Database connection failed due to {}".format(e))    

