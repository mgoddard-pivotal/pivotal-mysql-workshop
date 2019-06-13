# Experiment to illustrate the round robin DNS resolution for Galera clients

Before starting this, a simple app was pushed, just to provide a place to bind an instance
of an existing MySQL Galera DB cluster.  The app, called _image-resizing-service_, can be
checked out from [this repository](https://github.com/cf-platform-eng/image-resizing-service),
then deployed via `cf push`.

* Bind an HA / Galera MySQL instance to the app:
```
$ cf bs image-resizing-service ha-mysql
Binding service ha-mysql to app image-resizing-service in org pde / space dev as mgoddard...
OK

TIP: Use 'cf restage image-resizing-service' to ensure your env variable changes take effect
```

* Get the hostname of the DB from the app's environment (the plan, _db-ha-galera_, is also visible here:
```
$ cf env image-resizing-service
Getting env variables for app image-resizing-service in org pde / space dev as mgoddard...
OK

System-Provided:
{
 "VCAP_SERVICES": {
  "p.mysql": [
   {
    "binding_name": null,
    "credentials": {
     "hostname": "q-n3s3y1.q-g222.bosh",
     [...]
     }
    },
    "instance_name": "ha-mysql",
    "label": "p.mysql",
    "name": "ha-mysql",
    "plan": "db-ha-galera",
    "provider": null,
    "syslog_drain_url": null,
    "tags": [
     "mysql"
    ],
    "volume_mounts": []
   }
  ]
}
```

* SSH into the app's container:
```
$ cf ssh image-resizing-service
```

* Resolve that host name in a loop, to illustrate the DNS round robin configuration:
```
vcap@e02c6c1d-bed2-40ba-5e38-7152:~$ while `true` ; do date && host q-n3s3y1.q-g222.bosh && sleep 5 ; done
Thu Jun 13 13:28:28 UTC 2019
q-n3s3y1.q-g222.bosh has address 10.0.8.7
q-n3s3y1.q-g222.bosh has address 10.0.10.4
q-n3s3y1.q-g222.bosh has address 10.0.9.4
Thu Jun 13 13:28:33 UTC 2019
q-n3s3y1.q-g222.bosh has address 10.0.9.4
q-n3s3y1.q-g222.bosh has address 10.0.8.7
q-n3s3y1.q-g222.bosh has address 10.0.10.4
Thu Jun 13 13:28:38 UTC 2019
q-n3s3y1.q-g222.bosh has address 10.0.8.7
q-n3s3y1.q-g222.bosh has address 10.0.9.4
q-n3s3y1.q-g222.bosh has address 10.0.10.4
Thu Jun 13 13:28:43 UTC 2019
q-n3s3y1.q-g222.bosh has address 10.0.9.4
q-n3s3y1.q-g222.bosh has address 10.0.8.7
q-n3s3y1.q-g222.bosh has address 10.0.10.4
```

