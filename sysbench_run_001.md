# One run of sysbench

* 16 threads
* VM type: (EC2) r4.xlarge

```
mysql/3ea109ae-48ba-4d7d-b74f-d34c33ff5043:~$ ./run_sysbench.sh
** Generating 5000000 rows of data **
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Creating table 'sbtest1'...
Inserting 5000000 records into 'sbtest1'
Creating a secondary index on 'sbtest1'...
Done.

** Running the benchmark itself **
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Running the test with following options:
Number of threads: 16
Initializing random number generator from current time


Initializing worker threads...

Threads started!

SQL statistics:
    queries performed:
        read:                            436632
        write:                           124752
        other:                           62376
        total:                           623760
    transactions:                        31188  (519.64 per sec.)
    queries:                             623760 (10392.81 per sec.)
    ignored errors:                      0      (0.00 per sec.)
    reconnects:                          0      (0.00 per sec.)

General statistics:
    total time:                          60.0163s
    total number of events:              31188

Latency (ms):
         min:                                    9.15
         avg:                                   30.78
         max:                                  178.86
         95th percentile:                       57.87
         sum:                               959961.42

Threads fairness:
    events (avg/stddev):           1949.2500/34.55
    execution time (avg/stddev):   59.9976/0.00

Done.

** Cleaning up **
sysbench 1.0.17 (using bundled LuaJIT 2.1.0-beta2)

Dropping table 'sbtest1'...
Done.

```

* From the audit logs:

```
"Execute","2697100_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15705",0,"INSERT INTO sbtest1 (id, k, c, pad) VALUES (2506464, 2498871, '61142170231-37725408934-64566897224-13323476880-85322078494-00619751151-32158165485-11535832345-89338354378-61410498887', '09322141361-15144204499-61213471122-93166130690-41390758730')","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697101_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15715",0,"SELECT c FROM sbtest1 WHERE id=2524515","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697095_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15713",0,"SELECT c FROM sbtest1 WHERE id BETWEEN 2519655 AND 2519754 ORDER BY c","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697102_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15706",0,"INSERT INTO sbtest1 (id, k, c, pad) VALUES (2505309, 2514313, '61613924859-91649226518-59774757815-91318427691-45809520559-58351783754-39581845015-05200718612-03391204668-00606171334', '49596960546-53263799870-08780472682-20510381643-10700343749')","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697103_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15709",0,"SELECT c FROM sbtest1 WHERE id=2521358","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697104_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15715",0,"SELECT c FROM sbtest1 WHERE id=2512222","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697105_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15712",0,"SELECT DISTINCT c FROM sbtest1 WHERE id BETWEEN 2491214 AND 2491313 ORDER BY c","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697106_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15713",0,"SELECT DISTINCT c FROM sbtest1 WHERE id BETWEEN 2488089 AND 2488188 ORDER BY c","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697107_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15709",0,"SELECT c FROM sbtest1 WHERE id=2507560","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697108_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15715",0,"SELECT c FROM sbtest1 WHERE id=2521104","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697109_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15717",0,"COMMIT","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697110_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15712",0,"UPDATE sbtest1 SET k=k+1 WHERE id=1942948","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697111_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15715",0,"SELECT c FROM sbtest1 WHERE id BETWEEN 2122889 AND 2122988","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697112_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15712",0,"UPDATE sbtest1 SET c='66450617048-73660581625-31218908597-94104280774-12333983994-72122233549-97325879258-85127106532-74677653942-26207427908' WHERE id=2509734","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697113_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15709",0,"SELECT c FROM sbtest1 WHERE id=2505987","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697114_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15713",0,"UPDATE sbtest1 SET k=k+1 WHERE id=2008051","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697115_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15712",0,"DELETE FROM sbtest1 WHERE id=2504686","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
"Execute","2697116_2019-06-19T06:14:39","2019-06-20T03:17:13 UTC","error","15715",0,"SELECT SUM(k) FROM sbtest1 WHERE id BETWEEN 2523850 AND 2523949","3250a895faec44ce803f93a3418845d7[3250a895faec44ce803f93a3418845d7] @  [127.0.0.1]","","","127.0.0.1","service_instance_db"
```

