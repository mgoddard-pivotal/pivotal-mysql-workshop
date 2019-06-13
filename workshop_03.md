# Workshop to explore various topics related to running the Pivotal MySQL database as a service

## Part 3

### Database installation & configuration

Setup in a cluster; e.g. leader/follower or Galera cluster

Refer to [this section](./workshop_02.md#setup-galera-ha-cluster).

### Data Migration after installation

Export data from Postgres and import into MySQL.

### Backup and Recovery

### Performance tuning

### DB Monitoring (PMM from Percona is on the roadmap)

### Security (Local account, AD or LDAP)

- Role
- Profile
- Privileges

This is automatically handled by the platform.  When a DB instance is created using
```
$ cf create-service db-service silver mydb
```
a DB role is created with privileges on that DB instance.

### Partition table

### Triggers
- See https://dev.mysql.com/doc/refman/8.0/en/trigger-syntax.html

### Specific data types

![MySQL vs. Oracle Numeric Types](./mysql_oracle_numeric_types.png)

Ref. https://docs.oracle.com/cd/E12151_01/doc.150/e12155/oracle_mysql_compared.htm#BABGACIF

* LOB
  - See https://dev.mysql.com/doc/refman/8.0/en/blob.html
* XML
  - Built-in XML type and functions: https://dev.mysql.com/doc/refman/8.0/en/xml-functions.html
  - Consider an XML to JSON conversion (e.g. https://pypi.org/project/xmljson/), enabling the use of a richer set of JSON operators?
  - Support long and complex XML sql queries
* RAW
  - In MySQL, this is either BIT or BLOB
* LONG RAW
  - In MySQL, this is BLOB or LONGBLOB 
* ROWID & UROWID
  - MySQL doesn’t have this feature, but there are ways to emulate it.
  - Ref. https://stackoverflow.com/questions/2728413/equivalent-of-oracle-s-rowid-in-mysql

### Troubleshooting with logs

### Support feature for installing DB in physical or virtual environment

### Patch release frequency
- Quarterly releases
- Fast turnaround for CVEs

### Patching methods
- Ref. https://docs.pivotal.io/p-mysql/2-5/upgrade.html


