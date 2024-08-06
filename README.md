# EC2 Configs Application - Deployment

## Overview

### General

EC2 Configs is an application providing centralized management of network object deployments in Azure and AWS. It is a web application that lets you create configurations that provision multiple elements. It is stateful, so any action is preserved between sessions. You can provision and store configurations in as many accounts/sunscriptions you want as long as you have the necessary access keys and permissions for them.

Configurations are owned by users, meaning that each user has access only to the configurations created by them. Configuration sharing is also an option, making them available to multiple users or user groups. Permissions to shared configurations are defined by the owner of the configuration or by anyone that has been granted full access to the configuration.

### User authetication

User authentication is done via Entra ID, so having access to an Azure tenant with Entra ID configured is a prerequisite. A registered and configured Entra ID application is also necessary in order to perform any SAML operations related to user authentication. Any authenticated user also gets created in the database of the application, so that data is maintained between sessions. The tenant and the application that is used for user authentication are defined during the application deployment and can be changed at anytime.

Users can be defined as applications administrators. App admins have complete visibility and full access to all configurations. They can also create and delete user groups and add/remove users from them. Note that for a user to be present in the app, they need to have logged in to the application successfully at least once. For a user to be application admin, they need to be member of an Entra ID user group. This group's ID is defined during the application deployment and can change at anytime.

Ream more on how to prepare the application and the tenant [here](https://learn.microsoft.com/en-us/entra/external-id/customers/tutorial-single-page-app-react-sign-in-prepare-tenant)

## Application Components

The application has various elements and workloads that enable its full functionality. Briefly:

- Frontend application: This is the web application that is executed on users' browsers. It is based on the React framework and built into static html, css and js files that can be server by any web server.
- Backend application: It is a javascript application based on the Express framework. It serves as the backend of the application that receives and processes all the requests that need to be handled or rely on processes that can't be executed from the browser (terraform actions, file creation, communication with the database etc). It is publicly accessible and listens to the /api path of the application domain. A different domain can be used, but the backend app has not been tested and developed for scenarios where CORS is applicable.
- Python and terraform jobs: These jobs create all the nesessary files and run any terraform jobs that are related to object provision. They are executed on the same nodes that the backend application is. On K8s cluster deployments, these are executed as one-off jobs
- Database: The database keeps data related to users, groups, configurations etc. It's a MariaDB solution that can either run on a single node or with an Active-Active HA deployment. It can also be deployed as a container in the K8 deployment, but it has not yet been tested for any performance or implementation issues.
- Proxy: This is a mandatory component only in scenarios where either the frontend app, the backend app, or both are following a HA deployment. It is a single node running nginx and performing load balancing between the application instances and SSL termination. Practically, even on single node scenarios, a proxy component is present, since nginx is either proxying requests made to /api to the backend application or serving anything else from the static files build by the frontend app.

## Deployment Options

EC2 Configs app can be deployed either by running natively on one or most hosts or in a clustered kubernetes environment. Although you can split the various workloads between the 2 options, it is recommended that the whole is environment follows the same concept. This is to reduce the deployment and maintainance overhead.

Deployment has been scripted/automated in order to reduce deployment time and standarize the procedure.

### Native deployment

Run each workload natively on one more hosts. All workloads can be distributed to one or more than one hosts to provide High Availability. Tests have shown that jobs are faster when the application is deployed natively but scaling and version control on High Availability deployments is tougher to maintain.

More information on how to deploy the app natively [here](./native/README.md)

### Kubernetes deployment

In this scenario, you will need a K8 cluster that is going to host the environment. As mentioned above, you can also host the database within the cluster, but it has not been tested. Every workload is going to be delegated to either one or more containers (backend and frontend) or to one-off jobs that execute adhoc actions (file creation, terraform jobs etc).

As of now, in order to customize the frontend application (which is an essential step in order to properly define all the Azure related variables), you need to rebuild the image. This is hopefully to be imporoved in the future, so that the public images off the application can be used for the whole landscape of the app.

## Considerations

When a scenario that consists of multiple nodes is deployed, there are specific prerequisites regarding the environment that need to be met. For example, specific connectivity needs to be allows between the different hosts and backend or cluster nodes need to have shared folders/filesystems. This is standarized in the scripted deployments but you can modify them to suit your needs. For example, filesystems/folders are exported from some hosts and are mounted to other. This can also be achieved via various cloud concepts (EFS, Storage Accounts etc), but the automated deployments are developed to by as cloud-agnostic as possible.