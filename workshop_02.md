# Workshop to explore various topics related to running the Pivotal MySQL database as a service

## Part 2

### Setup – HA cluster (Galera)
* Create an instance of an HA MySQL DB
  We can do this using the command line:
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
  ```
  or via the Apps Manager GUI.

### Database client operations

* Create tables/accounts on it

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

