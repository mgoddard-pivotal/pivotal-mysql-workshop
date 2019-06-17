# Notes on running Sysbench on a MySQL VM

* BOSH SSH into a single node MySQL VM

* Download the sysbench files
  - [sysbench install files](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_files.tar.gz)
    Untar this file in / as root
  - [sysbench lib deps](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_libs.tar.gz)
    Untar this file in /tmp, then cd into the new directory, and `export LD_LIBRARY_PATH=$PWD`

* Run sysbench to generated the data set:
  ```
  mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
    --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_write.lua prepare
  ```
* Run the benchmark itself:
  ```
  $ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
    --time=60 --threads=8 \
    --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_write.lua run
  ```

* Clean up after you're satisfied with the results:
  ```
  $ sysbench --test=oltp --db-driver=mysql --mysql-db=service_instance_db \
    --mysql-user=YOUR_MYSQL_USER --mysql-password=YOUR_MYSQL_PASSWD cleanup
  ```

