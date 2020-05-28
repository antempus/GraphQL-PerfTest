# GraphQL Perfomance Test

Meta repo for creating docker images, for creating resources in Azure via Terraform for those images, and scripts to run against them for load test

#### Setup

Each folder contains a README that will help instrument the work to build out the required Docker images and Azure infrastructure:

[Function App](./functionapp/README.md)
[Web App](./functionapp/README.md)
[Infrastructure](./functionapp/README.md)

#### CosmosDB Account

The account should have a database name `database` and a container within named `users` with a partition key of `/id`. This is a hard requirement and will prevent the perf test from running and data upload from processing.

##### User Data

The backing database will require data of a specific structure, to support this i've included `perf_tests/users.json` that will provide 1000 users to query against during the load test, with the data generated via `mockaroo.com`.

This data will only needed to be populated once when using a predefined container for cosmos, but if you are creating the database on the fly, it can ran via `npm run populate` for each db creation

#### Performance Test

There are two available scripts for testing the relative performance of the two resources:
`webapp` & `functionapp`
