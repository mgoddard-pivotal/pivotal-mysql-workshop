# Workshop to explore various topics related to running the Pivotal MySQL database as a service

## Part 1

### Demonstrate ability to identify application session
```
mysql> SELECT connection_id();
+-----------------+
| connection_id() |
+-----------------+
|           16681 |
+-----------------+
1 row in set (0.10 sec)
```

### Create and connect application to read/write from/to DB with various ORM with JDBC

The [_Spring Music_ demo app](https://github.com/cloudfoundry-samples/spring-music) uses
[Spring Data JPA](https://www.baeldung.com/the-persistence-layer-with-spring-data-jpa) for persistence,
and makes an easy demo for this workshop since it supports several databases, including MySQL.
It has an accessible section on
[how to run in Cloud Foundry](https://github.com/cloudfoundry-samples/spring-music#running-the-application-on-cloud-foundry),
and we can follow the procedure outlined there.

Alternatively, we can use MyBatis as our persistence framework.  Note that [Spring Initializr](https://start.spring.io)
has support for MyBatis.
Here are a couple of references which may be of help:

* https://github.com/mybatis/spring-boot-starter/wiki/Quick-Start
* http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/

### CLI support for scripting

If you have the [`cf` CLI](https://github.com/cloudfoundry/cli/releases) installed, and have created
a MySQL instance (in this example, the instance is named _db-small-dev_), you can access this instance
for CLI interaction, including scripting, like this:
```
$ cf mysql db-small-dev < beer_ddl.sql
```

### Demonstrate ability and performance to handle concurrent read/write from application

Here are the scenarios we seek to address:

* Concurrent read and write
* Concurrent read and when there is heavy writing
* Concurrent write and when there is heavy reading
* Concurrent heavy read and heavy write

Pivotal MySQL offers three [workload profiles](https://docs.pivotal.io/p-mysql/2-5/change-default.html#workload)
for tuning to accommodate scenarios like this.  Examples of applying one of these workload profiles can be seen
[here](https://docs.pivotal.io/p-mysql/2-5/change-default.html#defaults).  The three options for `workload` are
`mixed`, `read-heavy`, and `write-heavy`, and these can be applied either at service creation time (see below)
or via `update-service`:
```
$ cf create-service p.mysql dev-db-medium dev-002 -c '{ "workload": "write-heavy" }'
```

The Pivotal MySQL team uses sysbench to benchmark MySQL.  The approach is documented
[here](https://www.howtoforge.com/how-to-benchmark-your-system-cpu-file-io-mysql-with-sysbench#-mysql-benchmark)
and the project's GitHub repo is [here](https://github.com/akopytov/sysbench).  It looks like there is a
[Docker image](https://hub.docker.com/r/perconalab/sysbench/) available, so we could try running it this way,
pushing the Docker image to PCF.  TODO

### Demonstrate ability and performance of transaction rollback

This part inserts data into the _beer_ table created above, so ensure you have run that step before working
this section.  This part should be run with two terminals, one is left connected to the DB so that the table
can be queried, and the other is used to run the `.sql` files.

In on terminal:
```
$ cf mysql db-small-dev
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19313
Server version: 5.7.23-23-log MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> desc beer;
+-------------------+-------------+------+-----+---------+-------+
| Field             | Type        | Null | Key | Default | Extra |
+-------------------+-------------+------+-----+---------+-------+
| idx               | int(11)     | YES  |     | NULL    |       |
| beer_abv          | float       | YES  |     | NULL    |       |
| beer_id           | int(11)     | YES  |     | NULL    |       |
| brewer_id         | int(11)     | YES  |     | NULL    |       |
| beer_name         | varchar(64) | YES  |     | NULL    |       |
| beer_style        | varchar(64) | YES  |     | NULL    |       |
| appearance        | float       | YES  |     | NULL    |       |
| aroma             | float       | YES  |     | NULL    |       |
| overall           | float       | YES  |     | NULL    |       |
| palate            | float       | YES  |     | NULL    |       |
| taste             | float       | YES  |     | NULL    |       |
| review_text       | text        | YES  |     | NULL    |       |
| time_struct       | json        | YES  |     | NULL    |       |
| time_unix         | datetime    | YES  |     | NULL    |       |
| user_age_sec      | int(11)     | YES  |     | NULL    |       |
| user_birthday_raw | varchar(32) | YES  |     | NULL    |       |
| user_birthdayUnix | int(11)     | YES  |     | NULL    |       |
| user_gender       | varchar(8)  | YES  |     | NULL    |       |
| user_profileName  | varchar(32) | YES  |     | NULL    |       |
+-------------------+-------------+------+-----+---------+-------+
19 rows in set (0.10 sec)

mysql> select count(*) from beer;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set (0.09 sec)

mysql>

```

* Committing with 10000 insert statement in a single transaction. In another terminal, run this:
```
$ curl -O https://hooli-roof.s3.amazonaws.com/beer_ratings/insert_10k_commit.sql
$ cf mysql db-small-dev < insert_10k_commit.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
```

Use the MySQL CLI in the other terminal to verify the data was loaded:
```
mysql> select count(*) from beer;
+----------+
| count(*) |
+----------+
|    10000 |
+----------+
1 row in set (0.10 sec)

mysql>

```

Then, truncate that table and verify it doesn't contain any rows:
```
mysql> truncate table beer;
Query OK, 0 rows affected (0.12 sec)

mysql> select count(*) from beer;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set (0.10 sec)

mysql>
```

* Rollback 10000 statement in a single transaction.  First, edit that `insert_10k_commit.sql` file, changing
the last line from `COMMIT;` to `ROLLBACK;`.  Then, repeat the previous steps (leaving out the file download
step):
```
$ cf mysql db-small-dev < insert_10k_commit.sql
mysql: [Warning] Using a password on the command line interface can be insecure.
```

As before, use the MySQL CLI in the other terminal to verify the data:
```
mysql> select count(*) from beer;
+----------+
| count(*) |
+----------+
|        0 |
+----------+
1 row in set (0.09 sec)

mysql>
```

### Demonstrate transparent impact / level of impact to application during the following:

* Application perform read & write during DB Upgrade / Patching
* Application perform read & write during DB Recovery
* Application perform read & write during DB Swinging (e.g. with leader/follower, taking leader down, promoting
follower to leader)


