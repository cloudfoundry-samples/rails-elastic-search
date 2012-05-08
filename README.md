rails-elastic-search
====================

Rails app that uses [Tire](https://github.com/karmi/tire) to interact with Elastic Search deployed on Cloud Foundry.  This app was originally created by running the "rails new searchapp" command explained under "ActiveModel Integration" in the Tire README.

## Setting up Elastic Search
This app connects to an instance of Elastic Search running on Cloud Foundry.  Follow these instructions to deploy Elastic Search as a standalone application:

- Download and unzip the latest stable release of [Elastic Search](http://www.elasticsearch.org/download/)
- Modify config/elasticsearch.yml to use Cloud Foundry-provided host and port

```
# ElasticSearch, by default, binds itself to the 0.0.0.0 address, and listens
# on port [9200-9300] for HTTP traffic and on port [9300-9400] for node-to-node
# communication. (the range means that if the port is busy, it will automatically
# try the next port).

# Set the bind address specifically (IPv4 or IPv6):
#
network.bind_host: ${VCAP_APP_HOST}

# Set the address other nodes will use to communicate with this node. If not
# set, it is automatically derived. It must point to an actual IP address.
#
# network.publish_host: 192.168.0.1

# Set both 'bind_host' and 'publish_host':
#
network.host: ${VCAP_APP_HOST}

# Set a custom port for the node to node communication (9300 by default):
#
# transport.tcp.port: 9300

# Enable compression for all communication between nodes (disabled by default):
#
# transport.tcp.compress: true

# Set a custom port to listen for HTTP traffic:
#
http.port: ${VCAP_APP_PORT}
```

- Deploy Elastic Search to Cloud Foundry using the provided manifest.  You may need to modify the manifest to generate a unique URL.

```bash
cd elasticsearch-0.19.2
cp rails-elastic-search/elastic-search-manifest.yml .
vmc push --manifest=elastic-search-manifest.yml
```

You should now be able to direct REST requests to myelasticsearch.cloudfoundry.com

## Deploying rails-elastic-search to Cloud Foundry
Cloud Foundry runs your Rails app in production mode, therefore you need to precompile assets prior to deploying:

```bash
rake assets:precompile
```

You also need to update the Tire configuration to point to the URL you've assigned to Elastic Search.  Edit the following line in config/environments/production.rb:

```
Tire::Configuration.url "http://myelasticsearch.cloudfoundry.com"
```

To deploy the application to Cloud Foundry, simply use the provided manifest.yml file.  You need only to provide the application with a name and URL.

```bash
vmc push
Would you like to deploy from the current directory? [Yn]:
Application Name: searchapp
Application Deployed URL [searchapp.cloudfoundry.com]:
```