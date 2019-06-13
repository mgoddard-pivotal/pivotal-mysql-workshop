# A few questions, with answers, on Galera

Q: Is it possible, when creating an instance of a MySQL DB, to pass MySQL config params in the
`-c '{"binlog_row_image": "FULL"}'` string?
A: We don’t support a feature like _parameter groups_ or the configuring of `binlog_row_image` right now.

Q: Is it possible, for any of the supported topologies, to do a zero-downtime upgrade (say, upgrade the
tile, then each of the instances)?  The Galera topology seems most likely to support this, but I’m not
sure it’s possible.  Maybe it is, and that’s just the default way it works.
A: I suppose it depends how tightly we define _zero downtime_.  Galera should
get close, but we have a few lingering bosh-dns integration issues which probably
mean up to several seconds of downtime.   Application connections will be
dropped during an upgrade regardless and need to reconnect  (potentially
interrupting in-flight transactions).

Q: It appears that the Galera option yields a specific number of nodes, and the
traffic is round-robin distributed across these, with synchronous replication
among them.  Am I right?
A: Traffic is round-robin across the cluster using bosh-dns, but directed to
proxies that **send all queries to a single database node**.   This avoids failures
due to cluster transaction certification conflicts which can significantly
degrade cluster performance.

Q: Again, referring to Galera, is it possible to add additional nodes, to scale
the workload across more nodes?
A: A galera cluster can be scaled somewhat -- but it is not a write-scaling
technology.   This could be useful for scaling reads for specific workloads,
but an app would need to be designed to be tolerant of stale reads or enable
Galera specific options to do synchronous reads.  We currently do not support
that use case in the MySQL v2 product.

