# GraphQL Perfomance Test

Meta repo for creating resources in Azure Cloud via Terraform, creating docker images to run in Azure, and the scripts to run against the deployed resources

#### Setup

Each folder contains a README that will help instrument the work to build out the required Docker images and Azure infrastructure:

[Function App](./functionapp/README.md)
[Web App](./functionapp/README.md)
[Infrastructure](./functionapp/README.md)

#### Users

The backing database will require data of a specific structure, to support this i've included `perf_tests/users.json` that will provide 1000 users to query against during the load test. with the data generated via `mockaroo.com`.

This data will only be needed once when using a predefined container for cosmos, but if you are creating the database on the fly, it can be used to post the data via the function app with `npm run populate`

#### Performance Test

There are two available scripts for testing the relative performance of the two resources:
`webapp` & `functionapp`
