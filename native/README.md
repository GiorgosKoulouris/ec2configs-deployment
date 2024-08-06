# EC2 Configs Application - Native deployment

## Overview

Run each workload natively on one more hosts. All workloads can be distributed to one or more than one hosts to provide High Availability. Tests have shown that jobs are faster when the application is deployed natively but scaling and version control on High Availability deployments is tougher to maintain.

#### Single Host

This is the quickest and easiest way to deploy the app. All components and workloads are hosted on a single node (proxy, frontend, backend, terraform and python jobs, database). Although the application is not resource intensive, more resources are required when installing its npm dependencies and when building the static files for the frontend. For testing purposes, after building the application you could potentially downsize to even 1X1 machines.

#### Multiple hosts

In this sxenario, you can split the wokloads between more than one hosts. Any conbination is possible, for example:

- 1 proxy, 1 frontend, 2 backend, 1 database
- 1 proxy, 2 frontend, 2 backend, 1 database
- 1 proxy 1 for frontend and backend, 2 databases
- 1 proxy 1 for frontend and backend, 1 dedicated backend, 1 database

Note that you will need a proxy host for every scenario. It is also possible to host extra workloads on the proxy host as well, but it is not recommended for security reasons.

## Prerequisites

### User authentication

App users authenticate themselves via Entra ID, so you need an Azure tenant with Entra ID configured. You will also need an Entra application for authentication against the tenant.

Since authentication is done via SAML, you will need to own a domain to host the app. Entra apps can only perform authentication that come from a domain using HTTPS or from localhost using HTTP. You can also use a domain you do not own, but this will require either a private DNS setup or hostfile modification. Note that self-signed certificates can work in this scenario but may cause problems when a "certificate security acceptance" has not taken place for a long time, as your browser may dismiss requests made to the backend app. For testing purposes, you can import the CA of your self-signed certificate in your workstation.

### Supported operating systems

EC2 Configs application can only be hosted on linux nodes. The number of the nodes depends on the deployment approach you are going to follow. Supported and tested Operating Systems:
- Red Hat 8
- Oracle Linux 8
- Red Hat 9
- Oracle Linux 9
- Ubuntu 22.04
- Amazon Linux 2023

### Network and internet connectivity

#### Reachability

In case you expose the app publicly, a public IP needs to be assigned to:

- The proxy server, on mutli-node scenarios
- The single host, on single-node scenarios

In case you are going to use the app via a private network you will need:

- Access to the proxy server via HTTPS, on mutli-node scenarios
- Access to your host via HTTPS, on single-node scenarios

#### SSL Certificate

Since the application is by default configured to listen to HTTPS (either the proxy on HA, or the main node on non-HA scenarions), you will need an SSL certificate. It can be self-signed (not recommended), or provided by any trusted authority or by your CDN provider (if applicable). This certificate should be pem formatted and must be placed in repoDisrectory/configs/ssl_certs. Certificate file should be named ec2configs.pem and its key ec2configs-key.pem. Do not use passphrase encrypted keys for your certificates as they have not been tested.

#### Internet connectivity

Note that all nodes hosting the backend application will need to have internet access. This is because every request made to the /api path is cross-checking user authentication tokens, authenticates the users against Azure and authorizes them based on their identity and the request they provide. This is mandatory since the backend app (/api) is publicly exposed.

All hosts need internet during the initial application deployment or app/OS updates.

#### Network security

In **single node** scenarios, HTTPS traffic must be allowed to your host. Source depends on whether you expose the application publicly or not and if you intend to you use any CDN solution.

For **multi-node** scenarios:
- Proxy server: Allow HTTPS, source depends on whether you will expose the application publicly or not and if you intend to you use any CDN solution.
- Frontend servers: Allow HTTP from proxy server
- Backend servers: Allow TCP 30002 from proxy server
- Database servers: Allow TCP 3306 from backend servers
- In case you deploy an Active-Active HA Database solution you will also need the following:
    - Database servers: Allow TCP 3306, TCP 4567-4568, UDP 4567-4568, TCP 4444 from all database servers
    - Database servers: Allow TCP 3306 from the Load Balancer you are going to use
    - Load Balancer: Allow TCP 3306 from the backend servers

## Deployment prerequisites

- A UNIX system with ansible installed to execute the main bash script for the deployment
- Logon access via SSH to the target hosts for the ansible user. Your users will need to be able to become root
- Your target hosts will need internet access to download any necessary content

## Script info

### Script sections
- User prompts and variables
- OS configuration and patching
- Application admin creation
- Install and deploy Database server
- Configure backend servers and deploy backend app
- Configure frontend servers and deploy frontend app
- Configure proxy server (when applicable)

### Script prompts

### Inventory file

The first thing you need to edit is the inventory file. All the main ansible variables need to be checked.

For the deployment, what you actually need to edit is the host(s) under each group depending on their role. If a node is hosting more than one workloads, place its IP under all of the corresponfing roles. For example, if a node is a host serving the backend application and is also the database of the landscape, place it under both the backendHosts and the dbHosts group. In a single node scenario, the same host should be under all of the groups.

Manually fill the "hostname" variable on each host, as this is used to change the hostname of each node. Hosts that aere present on more than one groups, should have the same hostname on all of them.

**NOTE:** If you are going top use a single node deployment, the "proxyHosts" group in the inventory file must be empty. This is because the first playbook of the deployment is executed against all nodes defined in the inventory file.

#### New User

The script creates a new user for application administration purposes. This uses has elevated priviliges on each host, scoping his rights to only what's necessary based on the role(s) of each host. Default username is **ec2cadmin**, but you can name the user however you want. Enter the new password when asked. The script will also need an SSH public key stored at repodirectory/native/ansible/ssh/ec2cadmin.pub. If no valid key is found, a new key will be generated using the username you provided (username and username.pub). SSH key creation will also modify the inventory file, so that the new key is added for the newly created user.

#### Database user

There is a dedicated database user for the app to use (ec2cdbuser). Enter his password when asked and store it somewhere safe because you will need it later for the backend configuration.

#### High availability and domain configuration

Answer yes if one (or both) of the following is true:
- Multiple backend servers
- Multiple frontend servers

High Availability deployment for the database is not developed yet. If you want to configure HA DBs, do it manually.

Answering yes (HA configured) will result in some extra steps for the configuration of the reverse proxy. It will also configure the TLS termination on the proxy server and frontend app servers to listen to HTTP. When asked for the IPs of the frontend and backend servers, enter them one by one and answer "y" as long as you have more hosts to add.

Answering no (no HA) will result in skipping some extra configuration steps. It will also configure the single server to listen to HTTPS and perform TLS termination.

On both scenarios, you will need to enter the domain you are going to use.

#### Unit and environment files

Edit these files accordingly. They can be edited on the target system as well, but it is a good idea to fix them now, because editing them will require the app to be stopped and/or rebuilt.

## Deploy

Download the repo, navigate to the native deployment section and execute the script. All of the necessary information will be asked during runtime.
Make sure that you have read the instructions and information carefully before executing the script to avoid unessecary errors.

```bash
git clone https://github.com/GiorgosKoulouris/ec2configs-deployment.git

# Make sure that some predefined directories are present
mkdir -p ec2configs-deployment/native/configs/ssl_certs
mkdir -p ec2configs-deployment/native/ansible/ssh

# Paste the SSL certificate and key to the specific location
# Certificate
vi ec2configs-deployment/native/configs/ssl_certs/ec2configs.pem
# Key
vi ec2configs-deployment/native/configs/ssl_certs/ec2configs-key.pem

# Edit the inventory file
vi ec2configs-deployment/native/ansible/01-hosts.ini

# Execute the deployment script
cd ec2configs-deployment/native/ansible
./00-deploy-app.sh
```

## Add managed cloud accounts and subscriptions to the application

EC2 Configs uses terraform in the background. Authentication for terraform is required and it is achieved via access keys for AWS and application secrets for Azure. To add a managed account to the application execute the following on the node hosting your database.

```bash
sudo -i
mysql
```

While on the MariaDB cli, execute the following after changing the VALUES accordingly.

For AWS accounts:

```sql
INSERT INTO `ec2c`.`aws_accounts` (`account_name`, `aws_id`, `fa_access_key`, `fa_secret`) VALUES 
    (   'MY_Account_DisplayName',
        'Account_ID',
        'AKIASvnkjfhbvjhw',
        'EXMPALEJEHFIA');
```

For Azure subscriptions:

```sql

INSERT INTO `ec2c`.`az_subscriptions` (`subscription_name`, `tenant_id`, `subscription_id`, `application_id`, `secret_value`) VALUES 
    (   'My_Subscription_DisplayName',
        '1234-sdfg-2343',
        'koji-huy7-7867',
        'qwwe-sdas-231e',
        'secretValue');
```

No application restart is needed, if you navigate through the applicaiton's tab on your browser the new accounts/subscriptions will appear