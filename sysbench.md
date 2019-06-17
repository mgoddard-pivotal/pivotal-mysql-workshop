# Notes on running Sysbench on a MySQL VM

## Preparations

* BOSH SSH into a single node MySQL VM

* Download the sysbench files
  - [sysbench install files](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_files.tar.gz)
    Untar this file in / as root
  - [sysbench lib deps](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_libs.tar.gz)
    Untar this file in /tmp, then cd into the new directory, and `export LD_LIBRARY_PATH=$PWD`

## Running: read/write

* Run sysbench to generated the data set:
  ```
  $ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
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
  $ sysbench --mysql-host=127.0.0.1 --db-driver=mysql --mysql-db=service_instance_db \
    --mysql-user=44595ed22e1e42f49192251d59ff8c2f --mysql-password=mcwdz7psx97j38a4 \
    /usr/share/sysbench/oltp_read_write.lua cleanup
  ```

## Running: read-only

* Run sysbench to generated the data set:
  ```
  $ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
    --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_only.lua prepare
  ```
* Run the benchmark itself:
  ```
  $ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
    --time=60 --threads=8 \
    --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_only.lua run
  ```

* Clean up after you're satisfied with the results:
  ```
  $ sysbench --mysql-host=127.0.0.1 --db-driver=mysql --mysql-db=service_instance_db \
    --mysql-user=44595ed22e1e42f49192251d59ff8c2f --mysql-password=mcwdz7psx97j38a4 \
    /usr/share/sysbench/oltp_read_only.lua cleanup
  ```

## Full list of benchmarks

```
/usr/share/sysbench/oltp_delete.lua
/usr/share/sysbench/oltp_insert.lua
/usr/share/sysbench/oltp_point_select.lua
/usr/share/sysbench/oltp_read_only.lua
/usr/share/sysbench/oltp_read_write.lua
/usr/share/sysbench/oltp_update_index.lua
/usr/share/sysbench/oltp_update_non_index.lua
/usr/share/sysbench/oltp_write_only.lua
```

