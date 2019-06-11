# Workshop to explore various topics related to running the Pivotal MySQL database as a service

What follows is a set of demos / exercises which occur in random order.
We'll restructure as needed to organize into themes, if that makes sense.

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

MyBatis (leave this to local team)

Alternatively, we can use MyBatis as our persistence framework.  Note that [Spring Initializr](https://start.spring.io)
has support for MyBatis.
Here are a couple of references which may be of help:

* https://github.com/mybatis/spring-boot-starter/wiki/Quick-Start
* http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/


