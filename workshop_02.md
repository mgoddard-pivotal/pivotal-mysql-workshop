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
     ... [redacted]
    ```
  - Next, set up an SSH tunnel to the app instance which is bound to this DB instance:
    ```
    $ cf ssh -L 0.0.0.0:13306:q-n3s3y1.q-g204.bosh:3306 spring-music
    vcap@550dfdb5-71aa-4325-4b9d-830a:~$
    ```
  - Finally, connect to the DB instance using the credentials provided in the service key,
    and note that it's possible to connect from other machines on the same network as the
    one from which the SSH tunnel was initiated, in which case the `-h 0` would be modified
    to specify the IP address of this host:
    ```
    $ mysql -u 98d0c215c22942138a8ae22ebbfadceb -h 0 -p -P 13306 service_instance_db
    Enter password:
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
  - At this point, you are able to create tables, etc.:
    ```
    mysql> create table user (id int not null auto_increment, first varchar(255), last varchar(255), primary key (id));
    Query OK, 0 rows affected (0.11 sec)

    mysql> desc user;
    +-------+--------------+------+-----+---------+----------------+
    | Field | Type         | Null | Key | Default | Extra          |
    +-------+--------------+------+-----+---------+----------------+
    | id    | int(11)      | NO   | PRI | NULL    | auto_increment |
    | first | varchar(255) | YES  |     | NULL    |                |
    | last  | varchar(255) | YES  |     | NULL    |                |
    +-------+--------------+------+-----+---------+----------------+
    3 rows in set (0.10 sec)

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

* This is an opinionated offering, the tile, but we can use indexes, compression, and choice of instance type
for tuning to workload requirements.
* Create a huge table (don’t create index)
* Inject 1 million rows
* Perform a select with where clause – full table scan
* Facility to show the DB activities, breakdown CPU / Memory / IO info, execution plan, tuning required etc.
* Create the index as suggested
* Run query again
* Facility to show the DB activities, breakdown CPU / Memory / IO info, execution plan, tuning required etc. of the tuned query
* Index rebuild if applicable
* Table rebuild if applicable

