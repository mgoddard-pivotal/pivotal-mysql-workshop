#!/bin/bash

user=9c1b47f17bba4f689c8f081aab9ae5e8
passwd=n8pi84yyj21ii6ip
n_rows=1000000

# Options for test_file:
#
# /usr/share/sysbench/oltp_delete.lua
# /usr/share/sysbench/oltp_insert.lua
# /usr/share/sysbench/oltp_point_select.lua
# /usr/share/sysbench/oltp_read_only.lua
# /usr/share/sysbench/oltp_read_write.lua
# /usr/share/sysbench/oltp_update_index.lua
# /usr/share/sysbench/oltp_update_non_index.lua
# /usr/share/sysbench/oltp_write_only.lua
#
test_file="/usr/share/sysbench/oltp_read_write.lua"

echo "** Generating $n_rows rows of data **"
sysbench --mysql-host=127.0.0.1 --table_size=$n_rows \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=$user \
    --mysql-password=$passwd $test_file prepare
echo "Done."
echo ""

echo "** Running the benchmark itself **"
sysbench --mysql-host=127.0.0.1 --table_size=$n_rows \
    --db-driver=mysql --mysql-db=service_instance_db --mysql-user=$user \
    --time=60 --threads=8 \
    --mysql-password=$passwd $test_file run
echo "Done."
echo ""

echo "** Cleaning up **"
sysbench --mysql-host=127.0.0.1 --db-driver=mysql --mysql-db=service_instance_db \
    --mysql-user=$user --mysql-password=$passwd \
    $test_file cleanup
echo "Done."
echo ""

