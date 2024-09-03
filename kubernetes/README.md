# EC2 Configs Application - Kubernetes deployment

## Overview

Deploy EC2 Configs on an existing kubernetes client.

## Components

- **Frontend application**:
The frontend application that is rendered on client-side and performs all calls to the application api and applies some basic logic.
- **Backend application**:
The backend application that handles most of the operations, including the provisioning of one-off kubernetes jobs.
- **Database**:
Pod serving the MariaDB database that stores application information
- **Python jobs**:
Adhoc jobs that get spawned every time a configuration is edited in order to update the relevant terraform files.
- **Terraform jobs**:
Adhoc jobs that get spawned every time a user plans, applies, destroys or deletes a configuration.
- **Nginx ingress**:
Ingress that performs ssl termination and routes traffic to the appropriate kubernetes service based on the requested path
- **VS Code utility**:
Browser rendered instance of vscode for adhoc editing of any configuration or helm chart of the applicaiton itself.
- **MySQL Workbench utility**:
Browser rendered instance SQL Workbench to enable visual editing of the database of the application.


## Prerequisites

### Kubernetes cluster

You will need an existing kubernetes cluster in order to deploy the application. 

- <a href="https://github.com/GiorgosKoulouris/MDs-and-pages/tree/main/ansible-playbooks/linux-deploy-k8-cluster" target="_blank">Build a baremetal cluster</a>
- <a href="https://github.com/GiorgosKoulouris/MDs-and-pages/tree/main/aws/deploy-eks-cluster" target="_blank">Build an EKS cluster</a>

This configuration is deployed via a Helm chart, so you will need to have Helm installed.

### User authentication

App users authenticate themselves via Entra ID, so you need an Azure tenant with Entra ID configured. You will also need an Entra application for authentication against the tenant.

Since authentication is done via SAML, you will need to own a domain to host the app. Entra apps can only perform authentication that come from a domain using HTTPS or from localhost using HTTP. You can also use a domain you do not own, but this will require either a private DNS setup or hostfile modification. Note that self-signed certificates can work in this scenario but may cause problems when a "certificate security acceptance" has not taken place for a long time, as your browser may dismiss requests made to the backend app. For testing purposes, you can import the CA of your self-signed certificate in your workstation.

### Storage

Application data may be used by multiple pods at the same time. As of now, all PVs are created using nfs. Except for the folder that contains the actual application helm charts (which need to be present on your control node), all other data volumes can be exported from any host.

In order to avoid file permission issues, a nologin user is created on the fileserver and all pods run by using this user's ID.

### SSL Certificate

Since the application is by default configured to listen to HTTPS, you will need an SSL certificate. It can be self-signed (not recommended), or provided by any trusted authority or by your CDN provider (if applicable). This certificate should be pem formatted. Do not use passphrase encrypted keys for your certificates as they have not been tested.

### Internet connectivity

Note that the main application pods will need to have internet access. This is because every request made to the /api path is cross-checking user authentication tokens, authenticates the users against Azure and authorizes them based on their identity and the request they provide. This is mandatory since the backend app (/api) is publicly exposed.

## Deploy

### Prepare the fileserver

As mentioned above, the only data that needs to actually by present on a host with access to the cluster's API is 'kubeConfigs'. All other data can be hosted anywhere. For simplicity, it is assumed that all data directories are exported from the same host (which has access to control the cluster).

```bash
# Create appData directories
[ ! -d /appData/configs ] && mkdir -p /appData/configs
[ ! -d /appData/logs ] && mkdir -p /appData/logs
[ ! -d /appData/db/db ] && mkdir -p /appData/db/db
[ ! -d /appData/db/dumps ] && mkdir -p /appData/db/dumps
[ ! -d /appData/utils/sqlwb ] && mkdir -p /appData/utils/sqlwb

# Create kubeConfigs directory
[ ! -d /kubeConfigs/ec2c ] && mkdir -p /kubeConfigs/ec2c

# Create the user and fix the permissions
podUsername=poduser
useradd -s /sbin/nologin $podUsername
[ -d /home/$podUsername ] && rm -rf /home/$podUsername
podUserID="$(id -u $podUsername)"
podGroupID="$(id -g $podUsername)"
chown -R $podUserID:$podGroupID /kubeConfigs/*
chown -R $podUserID:$podGroupID /appData/*
chmod -R 777 /appData/utils/sqlwb

# Export the directories
systemctl start nfs-server
systemctl enable nfs-server
clusterSubnet="10.130.100.192/26" # Modify accordingly
grep -Eiv "(appData|kubeConfigs)" /etc/exports > tmpFile; rm -f /etc/exports; mv tmpFile /etc/exports
echo "/appData      $clusterSubnet(rw)" >> /etc/exports
echo "/kubeConfigs  $clusterSubnet(rw)" >> /etc/exports
exportfs -r
exportfs -s # Verify
```

### Deploy the application

#### Clone the repository

```bash
git clone https://github.com/GiorgosKoulouris/ec2configs-deployment.git
mv ec2configs-deployment/kubernetes/* /kubeConfigs/ec2c
rm -rf ec2configs-deployment
chown -R $podUserID:$podGroupID /kubeConfigs/*
```

#### Create the necessary secrets

```bash
# ----- Create the secrets ------
# TLS Secret
cd /kubeConfigs/ec2c/00_secrets/tls
vi cert.pem # Edit the certificate
vi key.pem # Edit the certificate key
./createSecret.sh

# Database user credentials
cd /kubeConfigs/ec2c/00_secrets/
vi ec2c-db-creds.yml # Edit the username and the passwords
kubectl apply -f ec2c-db-creds.yml

# Create the ECR credentials. Only necessary when using your private repositories 
cd /kubeConfigs/ec2c/00_secrets/
./create-aws-ecr-secret.sh
```

#### Deploy nginx controller

You may want to edit the default configuration. Unless you edit the *deploy.yaml* file after downloading it, the ingress controller is configured to be of tyope *nodePort*, listening on a random port on the high range used by kubernetes.

```bash
cd /kubeConfigs/ec2c/01_ingress-controller
./deploy-ingress-controller.sh
# Verify
kubectl get all -n ingress-nginx
```

#### Provision the storage objects

```bash
vi /kubeConfigs/ec2c/02_storage/values.yaml
helm install ec2c-storage /kubeConfigs/ec2c/02_storage/
# Verify
kubectl get pv -o wide && kubectl get pvc -o wide
```

#### Deploy the main workloads

```bash
vi /kubeConfigs/ec2c/03_main/values.yaml
helm install ec2c-workloads /kubeConfigs/ec2c/03_main/
# Verify
kubectl get all -o wide
```

#### Deploy ec2c utility pods

```bash
vi /kubeConfigs/ec2c/04_utils/values.yaml
helm install ec2c-utils /kubeConfigs/ec2c/04_utils/

# MySQL Workbench has some weird permission issues on persistent volumes. Follow this AFTER the 1st launch of the pod
chmod -R 777 /appData/utils/sqlwb
kubectl delete po -l app=ec2c-util-sqlwb-app               
```

### Usage
#### Application
In order to use the app, just visit the domain you specified on the values during the deployment
#### VS Code utility
VS Code utility is exposed via nodeport on the port you specified on the values during the deployment. Visit: *http://nodeIP:nodePort/?folder=/ec2c*
#### SQL Workbench utility
SQL Workbench utility is exposed via nodeport on the port you specified on the values during the deployment. Visit: *http://nodeIP:nodePort*. 

Since this utility is a pod in the cluster, when adding the connection you should be able by just referencing the kubernetes service used by the database pod. If no names were changed:
- **Host**: ec2c-main-dtbs-svc
- **Port**: 3306

## Post deployment actions

### Import accounts

In order to use the application you will need to import the account/subscription information on the database. You can do this either from the SQL Workbench utilitity or by logging in the database pod and executing the following on the MariaDB cli.

For Azure subscriptions:

```sql
INSERT INTO `ec2c`.`az_subscriptions` (`subscription_name`, `tenant_id`, `subscription_id`, `application_id`, `secret_value`) VALUES 
    (   'My_Subscription_DisplayName',
        '1234-sdfg-2343',
        'koji-huy7-7867',
        'qwwe-sdas-231e',
        'secretValue');
```

For AWS accounts:

```sql
INSERT INTO `ec2c`.`aws_accounts` (`account_name`, `aws_id`, `fa_access_key`, `fa_secret`) VALUES 
    (   'MY_Account_DisplayName',
        'Account_ID',
        'AKIASvnkjfhbvjhw',
        'EXMPALEJEHFIA');
```

Since the region list on both AWS and Azure is really long, you can delete any entry you don't plan to use.

- **For AWS**: Delete entries from the *aws_regions* table of *ec2c* database
- **For Azure**: Delete entries from the *az_regions* table of *ec2c* database