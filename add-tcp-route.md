# Use TCP Router

This document covers adding a route to PCF's TCP Router so that you can associate an external hostname and IP address pair that will connect an external client to a MySQL or Postgres service instance.

### Not for production

Note that routes must be continually re-registered within a loop, else TCP Router will stop sending traffic to the service instance.

## How

1. Configure a load balancer so that you can supply the name of the LB in the instructions below
    - The included Terraform scripts will often do this for you.
    - **NB** Terraform for AWS will automatically register 100 ports in the Elastic Load Balancer.
1. Register that load balancer in DNS (e.g. route 53), so that external clients can refer to that hostname
1. Follow the [instructions to enable TCP Router in PCF](https://docs.pivotal.io/pivotalcf/2-6/adminguide/enabling-tcp-routing.html)
    - **AWS Warning** while PCF will allow you to specify a large range of ports (e.g. 1024-65535), AWS ELB does not allow more than 100 port registrations.
1. Create a service instance
    > e.g. `cf create-service p.mysql large-db mysqlDB`

### Plumb the TCP Route

Create a route for that service instance via the [Routing API](https://github.com/cloudfoundry/routing-api/blob/master/docs/api_docs.md)

1. Follow the instructions in the Routing API docs to get the context for the `tcp_emitter` UAA client.
1. Use that token to find the GUID of the router group:
    ```
    $ curl -vvv -H "Authorization: bearer REDACTED" \
      http://api.system-domain.com/routing/v1/router_groups
    ```
1. Associate a route with your service instance's IP address
    ```
    $ curl -vvv -H "Authorization: bearer REDACTED" \
      -X POST http://api.system-domain.com/routing/v1/tcp_routes/create -d '
    [{
      "router_group_guid": "9994eddc-56fb-41bc-64b8-39dcb8c0fefc",
      "port": 1034,
      "backend_ip": "10.0.8.5",
      "backend_port": 3306,
      "ttl": 120,
      "modification_tag":  {
        "guid": "e975e9c2-76a4-4f62-83e9-028c61b77e5e",
        "index": 1
      }
    }]'
    ```
