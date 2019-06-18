# Notes on running Sysbench on a MySQL VM

## Preparations

* BOSH SSH into a single node MySQL VM

* Download the sysbench files
  - [sysbench install files](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_files.tar.gz)
    Untar this file in / as root
  - [sysbench lib deps](https://hooli-roof.s3.amazonaws.com/sysbench/sysbench_libs.tar.gz)
    Untar this file in your `$HOME` directory (**not /tmp**), then cd into the new directory,
    and `export LD_LIBRARY_PATH=$PWD`

* Edit [this script](./run_sysbench.sh) to suit your environment and test requirement, then run
  it on the MySQL VM (again, in `$HOME`).

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

## Example of an end-to-end benchmark run
```
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
>     --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
>     --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_write.lua prepare
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Creating table 'sbtest1'...
Inserting 1000000 records into 'sbtest1'
Creating a secondary index on 'sbtest1'...
mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ sysbench --mysql-host=127.0.0.1 --table_size=1000000 \
>     --db-driver=mysql --mysql-db=service_instance_db --mysql-user=44595ed22e1e42f49192251d59ff8c2f \
>     --time=60 --threads=8 \
>     --mysql-password=mcwdz7psx97j38a4 /usr/share/sysbench/oltp_read_write.lua run
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Running the test with following options:
Number of threads: 8
Initializing random number generator from current time


Initializing worker threads...

Threads started!

SQL statistics:
    queries performed:
        read:                            237510
        write:                           67858
        other:                           33929
        total:                           339297
    transactions:                        16964  (282.59 per sec.)
    queries:                             339297 (5652.00 per sec.)
    ignored errors:                      1      (0.02 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          60.0293s
    total number of events:              16964

Latency (ms):
         min:                                    8.67
         avg:                                   28.30
         max:                                  159.94
         95th percentile:                       46.63
         sum:                               480084.03

Threads fairness:
    events (avg/stddev):           2120.5000/14.26
    execution time (avg/stddev):   60.0105/0.01

mysql/c674fd34-978e-4b86-8abe-cd6966ce248f:~$ sysbench --mysql-host=127.0.0.1 --db-driver=mysql --mysql-db=service_instance_db     --mysql-user=44595ed22e1e42f49192251d59ff8c2f --mysql-password=mcwdz7psx97j38a4     /usr/share/sysbench/oltp_read_write.lua cleanup
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Dropping table 'sbtest1'...

```
