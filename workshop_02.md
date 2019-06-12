# Workshop to explore various topics related to running the Pivotal MySQL database as a service

## Part 2

### Setup – HA cluster (Galera)
* Create an instance of an HA MySQL DB
  We can get this done using the Apps Manager GUI, or we can use the command line, as shown here:
  ```
  $ cf create-service p.mysql db-ha-galera ha-mysql
  Creating service instance ha-mysql in org pde / space dev as mgoddard...
  OK

  Create in progress. Use 'cf services' or 'cf service ha-mysql' to check operation status.

  $ cf services
  Getting services in org pde / space dev as mgoddard...

  name           service   plan           bound apps     last operation       broker                   upgrade available
  db-small-dev   p.mysql   single-node    spring-music   create succeeded     dedicated-mysql-broker
  ha-mysql       p.mysql   db-ha-galera                  create in progress   dedicated-mysql-broker

  $ cf services
  Getting services in org pde / space dev as mgoddard...

  name           service   plan           bound apps     last operation     broker                   upgrade available
  db-small-dev   p.mysql   single-node    spring-music   create succeeded   dedicated-mysql-broker
  ha-mysql       p.mysql   db-ha-galera                  create succeeded   dedicated-mysql-broker
  ```

### Database client operations

* Create accounts on it: this is done via a service binding.  You do that like so:
  ```
  $ cf bs spring-music ha-mysql
  ```
  You can then view the credentials for this service binding.  The `VCAP_SERVICES` environment
  variable holds the credentials the app will use to access the service instance:
  ```
  $ cf env spring-music
  Getting env variables for app spring-music in org pde / space dev as mgoddard...
  OK

  System-Provided:
  {
   "VCAP_SERVICES": {
    "p.mysql": [
     {
      "binding_name": null,
      "credentials": {
       "hostname": "q-n3s3y1.q-g222.bosh",
  ... [redacted for brevity]

  ```
* Create tables/accounts on it
Here is a [Reference](https://docs.cloudfoundry.org/devguide/deploy-apps/ssh-services.html#ssh-tunnel)
on using an SSH tunnel to access a DB instance.
  - Create a service key for the DB instance:
    ```
    $ cf create-service-key db-small-dev db-small-dev-key
    Creating service key db-small-dev-key for service instance db-small-dev as mgoddard...
    OK

    ```
  - Then, retrieve the service key:
    ```
    $ cf service-key db-small-dev db-small-dev-key
    Getting key db-small-dev-key for service instance db-small-dev as mgoddard...

    {
     "hostname": "q-n3s3y1.q-g204.bosh",
     "jdbcUrl": "jdbc:mysql://q-n3s3y1.q-g204.bosh:3306/service_instance_db?user=98d0c215c22942138a8ae22ebbfadceb\u0026password=y3ntlbym9c1z1dyx\u0026useSSL=false",
     "name": "service_instance_db",
     "password": "y3ntlbym9c1z1dyx",
     "port": 3306,
     "uri": "mysql://98d0c215c22942138a8ae22ebbfadceb:y3ntlbym9c1z1dyx@q-n3s3y1.q-g204.bosh:3306/service_instance_db?reconnect=true",
     "username": "98d0c215c22942138a8ae22ebbfadceb"
    }
    ```
  - Using the value from the `hostname` field along with the name of the bound app, set up an SSH tunnel
    to the app instance which is bound to this DB instance (NOTE: port `13306` will be the port we use on
    this end of the tunnel):
    ```
    $ cf ssh -L 0.0.0.0:13306:q-n3s3y1.q-g204.bosh:3306 spring-music
    vcap@550dfdb5-71aa-4325-4b9d-830a:~$
    ```
  - Finally, connect to the DB instance using the credentials provided in the service key,
    and note that it's possible to connect from other machines on the same network as the
    one from which the SSH tunnel was initiated, in which case the `-h 0` would be modified
    to specify the IP address of this host:
    ```
    $ export MYSQL_PWD=y3ntlbym9c1z1dyx # Bad for security, but ok for this demo
    $ mysql -u 98d0c215c22942138a8ae22ebbfadceb -h 0 -P 13306 service_instance_db
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A

    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 37556
    Server version: 5.7.23-23-log MySQL Community Server (GPL)

    Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>
    ```
  - At this point, you are able to create tables, etc.  Let's go ahead and create some tables
    we'll use later on.  The DDL is available [here](./osm_tables.sql).
    ```
    mysql> DROP TABLE IF EXISTS osm;
    Query OK, 0 rows affected, 1 warning (0.11 sec)

    mysql> CREATE TABLE osm /* MySQL */
        -> (
        ->   id BIGINT PRIMARY KEY
        ->   , date_time DATETIME
        ->   , uid BIGINT
        ->   , lat DOUBLE PRECISION
        ->   , lon DOUBLE PRECISION
        ->   , name TEXT
        -> ) ENGINE=INNODB;
    Query OK, 0 rows affected (0.11 sec)

    mysql>
    mysql> -- Intermediate table, for loading
    mysql> DROP TABLE IF EXISTS osm_load;
    Query OK, 0 rows affected, 1 warning (0.10 sec)

    mysql> CREATE TABLE osm_load /* MySQL */
        -> (
        ->   id BIGINT PRIMARY KEY
        ->   , date_time TEXT /* DATETIME */
        ->   , uid BIGINT
        ->   , lat DOUBLE PRECISION
        ->   , lon DOUBLE PRECISION
        ->   , name TEXT
        -> ) ENGINE=INNODB;
    Query OK, 0 rows affected (0.11 sec)

    mysql>
    mysql> DROP TABLE IF EXISTS osm_k_v;
    Query OK, 0 rows affected, 1 warning (0.11 sec)

    mysql> CREATE TABLE osm_k_v
        -> (
        ->   id BIGINT
        ->   , k VARCHAR(64)
        ->   , v VARCHAR(512)
        ->   , FOREIGN KEY (id) REFERENCES osm(id) ON DELETE CASCADE
        -> ) ENGINE=INNODB;
    Query OK, 0 rows affected (0.12 sec)

    mysql>
    ```

### High Availability

* Online operations where applicable.  If one node is unavailable, the other node takes over (e.g. maintenance, failure, etc.).
* Create/drop/add the read only DB (HA or DR within the same setup) – Availability Zone
* Transparent to apps on primary instance
* Ease of doing so, and the considerations
* Demonstrate the read/write and read-only directed according to port usage
* Either do it via application or via the psql client
* Inject activity and check if the WAL is near instantaneous even when in Async mode
* To verify what happens if a misconfigured write is directed on the read only instance

### Patching/upgrade using BOSH framework

* Demonstrate the role change (read/write instance becomes read, read instance becomes read/write)
* Inject activities
* Role change
* Impact ?
* Demonstrate the Patch/Upgrade of the PostgreSQL (read only instance)
* How fast is the role switch?
* How transparent is the role switch?
* Follow-up patching of the new read instance (after the role switch)
* Demonstrate the Patch/Upgrade of the PostgreSQL (read/write instance)
* How fast is the patching/upgrade?
* How transparent is patching/upgrade?
* Follow-up patching  on the read instance
* Role switch after patching

### Backup & Restore

* Demonstrate the backup & recovery
* Do a full backup
* Inject activities into the DB
* Data is logically corrupted eg accidentally deleted
* Perform point-in-time recovery to prior the deletion

### Demonstrate the monitoring and performance tuning

This is an opinionated offering, the tile, but we can use indexes, compression, and choice of instance type
for tuning to workload requirements.  Also, the notion of
[workload profiles](https://docs.pivotal.io/p-mysql/2-5/change-default.html#workload) may be useful here.

For this part, we will use a `mysql` command line client and the SSH tunnel created earlier (see above).
This will run smoother if we use two terminals.  In one, we'll log in using the `mysql` client, and stay
logged in (just like in the earlier section):
```
$ export MYSQL_PWD=y3ntlbym9c1z1dyx
$ mysql -u 98d0c215c22942138a8ae22ebbfadceb -h 0 -P 13306 service_instance_db

```
* Create a huge table (don’t create index): we did this earlier (see above).
* Inject 1 million rows: in a second terminal, adjust [this script](./load_osm_data_mysql.sh) as necessary,
  then run it:
  ```
  $ ./load_osm_data_mysql.sh
  ```
* Perform a select with where clause – full table scan
* Facility to show the DB activities, breakdown CPU / Memory / IO info, execution plan, tuning required etc.
  For this, we can install the [cf CLI plugin](https://github.com/cloudfoundry/log-cache-cli) for
  [Log Cache](https://github.com/cloudfoundry/log-cache).  Here is an example of using it to tail (with the `-f`
  option) the logs from the MySQL DB instance _db-small-dev_:
  ```
  $ cf tail -f db-small-dev
  ```
* Create the index as suggested
* Run query again
* Facility to show the DB activities, breakdown CPU / Memory / IO info, execution plan, tuning required etc. of the tuned query
* Index rebuild if applicable
* Table rebuild if applicable

