# Restoring a MySQL DB instance from a backup

This procedure is documented [here](https://docs.pivotal.io/p-mysql/2-5/backup-and-restore.html),
though the process here deviates slightly in that it just restores to an existing DB instance.

Also note that this example is for a **single node DB**; the leader/follower and Galera HA
instances are more complex.

* Set up the BOSH alias and log into BOSH as user _director_:
```
bosh alias-env hooli -e 10.0.16.5 --ca-cert /var/tempest/workspaces/default/root_ca_certificate
bosh -e hooli login
```

* Log into Credhub:
```
credhub api https://10.0.16.5:8844 --ca-cert=/var/tempest/workspaces/default/root_ca_certificate
credhub login --client-name=ops_manager --client-secret=<your_password>
```

* Get the encryption key for the backup:
```
ubuntu@ip-10-0-0-241:~$ credhub get -n /p-bosh/service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d/backup_encryption_key
id: c0b917f5-5b2b-429a-96de-1571eae21c41
name: /p-bosh/service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d/backup_encryption_key
type: password
value: IFWinHY8fje30aXVbCsAlCsz7k8G3T
version_created_at: 2019-06-10T10:36:08Z
```

* While you're at it, get the MySQL instance `admin` user password, too:
```
ubuntu@ip-10-0-0-241:~$ credhub get -n /p-bosh/service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d/admin_password
id: e4723c4c-26ac-4af5-836c-0fab0855dcfc
name: /p-bosh/service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d/admin_password
type: password
value: G0FfNrgrRJlCOf5WIkS0oXV8S1HDWk
version_created_at: 2019-06-10T10:36:08Z
```

* Download the backup file using `curl` (after making the bucket public):
```
curl -O https://hooli-roof.s3.amazonaws.com/mysql-v2/service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d/2019/06/13/mysql-backup-1560445200-0.tar.gpg
```

* SCP that from the Ops Man VM to the MySQL instance VM:
```
ubuntu@ip-10-0-0-241:~$ bosh -e hooli -d service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d vms
Using environment '10.0.16.5' as user 'director' (bosh.*.read, openid, bosh.*.admin, bosh.read, bosh.admin)

Task 3813. Done

Deployment 'service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d'

Instance                                    Process State  AZ          IPs       VM CID               VM Type   Active
mysql/a192e472-0149-4b62-bf77-7d3200dd4684  running        us-west-2a  10.0.8.6  i-08555a68cd18fd790  m4.large  true

1 vms

Succeeded
ubuntu@ip-10-0-0-241:~$ bosh -e hooli -d service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d scp ./mysql-backup-1560445200-0.tar.gpg mysql/a192e472-0149-4b62-bf77-7d3200dd4684:/tmp/
Using environment '10.0.16.5' as user 'director' (bosh.*.read, openid, bosh.*.admin, bosh.read, bosh.admin)

Using deployment 'service-instance_64259f2c-8cd2-4904-af4c-e200ea65f88d'

Task 3814. Done
mysql/a192e472-0149-4b62-bf77-7d3200dd4684: stderr | Unauthorized use is strictly prohibited. All access and activity
mysql/a192e472-0149-4b62-bf77-7d3200dd4684: stderr | is subject to logging and monitoring.

Succeeded
```

* Now, restore the DB:
```
mysql/a192e472-0149-4b62-bf77-7d3200dd4684:/tmp# mysql-restore --encryption-key IFWinHY8fje30aXVbCsAlCsz7k8G3T --mysql-username admin --mysql-password G0FfNrgrRJlCOf5WIkS0oXV8S1HDWk --restore-file mysql-backup-1560445200-0.tar.gpg
2019/06/13 18:12:05 NOTE: --mysql-user and --mysql-password options are deprecated and no longer required for this utility.
2019/06/13 18:12:05 Stopping mysql job...
2019/06/13 18:12:10 Removing mysql data directory...
2019/06/13 18:12:10 Decrypting mysql backup mysql-backup-1560445200-0.tar.gpg...
2019/06/13 18:12:36 Removing stale database users...
2019/06/13 18:12:46 Starting mysql job...
```

