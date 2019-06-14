# Accessing MySQL DB instance logs

## Preliminary steps:

* Get the GUID value corresponding to the service instance you want logs for:
```
$ cf services
Getting services in org pde / space dev as mgoddard...

name          service   plan           bound apps               last operation     broker                   upgrade available
ha-mysql      p.mysql   db-ha-galera   image-resizing-service   create succeeded   dedicated-mysql-broker
small-mysql   p.mysql   single-node    spring-music             create succeeded   dedicated-mysql-broker

$ cf service small-mysql --guid
41ea219f-1843-453e-b0fd-9845d4493956
```

* SSH into the Ops Man VM
* Setting up a BOSH alias
* Logging in

## Steps carried out from within that SSH session (into Ops Man):

```
ubuntu@ip-10-0-0-241:~$ bosh -e hooli -d service-instance_41ea219f-1843-453e-b0fd-9845d4493956 vms
Using environment '10.0.16.5' as user 'director' (bosh.*.read, openid, bosh.*.admin, bosh.read, bosh.admin)

Task 3989. Done

Deployment 'service-instance_41ea219f-1843-453e-b0fd-9845d4493956'

Instance                                    Process State  AZ          IPs        VM CID               VM Type   Active
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f  running        us-west-2c  10.0.10.6  i-0e103efae2be5de55  m4.large  true

1 vms

Succeeded
ubuntu@ip-10-0-0-241:~$ bosh -e hooli -d service-instance_41ea219f-1843-453e-b0fd-9845d4493956 ssh mysql/c674fd34-978e-4b86-8abe-cd6966ce248f
Using environment '10.0.16.5' as user 'director' (bosh.*.read, openid, bosh.*.admin, bosh.read, bosh.admin)

Using deployment 'service-instance_41ea219f-1843-453e-b0fd-9845d4493956'

Task 3990. Done
Unauthorized use is strictly prohibited. All access and activity
is subject to logging and monitoring.
Welcome to Ubuntu 16.04.5 LTS (GNU/Linux 4.15.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

Last login: Fri Jun 14 13:43:54 2019 from 10.0.0.241
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ set -o vi
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ ps -ef | grep mysql
bosh_6f+   916   891  0 13:44 pts/0    00:00:00 grep --color=auto mysql
vcap      9458     1  0 00:14 ?        00:00:51 /var/vcap/packages/percona-server/bin/mysqld --defaults-file=/var/vcap/jobs/mysql/config/my.cnf --init-file=/var/vcap/jobs/mysql/scripts/init.sql --daemonize
vcap      9513     1  0 00:14 ?        00:00:00 /var/vcap/packages/mysql-agent/bin/mysql-agent /var/vcap/jobs/mysql-agent/config/mysql-agent.yml
vcap      9562     1  0 00:14 ?        00:00:52 /var/vcap/packages/mysql-metrics/bin/mysql-metrics -c=/var/vcap/jobs/mysql-metrics/config/mysql-metrics-config.yml -l=/var/vcap/sys/log/mysql-metrics/mysql-metrics.log
vcap      9583     1  0 00:14 ?        00:00:01 /var/vcap/packages/streaming-mysql-backup-tool/bin/streaming-mysql-backup-tool -configPath=/var/vcap/jobs/streaming-mysql-backup-tool/config/streaming-mysql-backup-tool.yml
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ id
uid=1001(bosh_6f93cc29461444e) gid=1003(bosh_6f93cc29461444e) groups=1003(bosh_6f93cc29461444e),999(admin),1000(vcap),1001(bosh_sshers),1002(bosh_sudoers)
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ sudo su -
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~# set -o vi
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~# lsof -p 9458 | grep -i log
mysqld  9458 vcap    1w   REG             202,18      8190 1048614 /var/vcap/data/sys/log/mysql/mysql.err.log
mysqld  9458 vcap    2w   REG             202,18      8190 1048614 /var/vcap/data/sys/log/mysql/mysql.err.log
mysqld  9458 vcap    5uW  REG             202,81 268435456  131077 /var/vcap/store/mysql/data/ib_logfile0
mysqld  9458 vcap   10uW  REG             202,81 268435456  131078 /var/vcap/store/mysql/data/ib_logfile1
mysqld  9458 vcap   28w   REG             202,18       384 1048615 /var/vcap/data/sys/log/mysql/mysql_slow_query.log
mysqld  9458 vcap   49uW  REG             202,81     98304  131153 /var/vcap/store/mysql/data/mysql/slave_relay_log_info.ibd
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~#
```

