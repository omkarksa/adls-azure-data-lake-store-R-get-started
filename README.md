---
services: data-lake-store
platforms: R
author: omkarksa
---

# Project Name: Azure Data Lake Store (ADLS): Getting Started

A sample R client using the **R connector for ADLS** to connect to an ADLS store.
The sample R client shows how to use some of the APIs to do some CRUD operations on the ADLS store.
The R connector for ADLS is currently part of the Microsoft/AzureSMR github project.

## Features

* The configurations required to authenticate with AAD using the ClientSecret flow.
* Getting a valid access token from AAD for accessing ADLS.
* Sample R client that demonstrates how to do CRUD operations with ADLS files & folders.

## Getting Started

### Prerequisites

- Install R version 3.0.0 or above and R studio.
- Azure application with ClientSecret.
- ADLS account with permission for the above azure application.

### Installation

- Clone the sample R client repo
```
	git clone https://github.com/Azure-Samples/adls-azure-data-lake-store-R-get-started.git
```

### Quickstart

1. Open the adls-azure-data-lake-store-R-get-started in R studio.
2. Install required packages
```
	install.packages("devtools", dependencies = TRUE)
	library(devtools)
	
	install_github("Microsoft/AzureSMR")
	library(AzureSMR)
```
	**NOTE:** During this installation process if you come across an error with installing any 
	package, please exit RStudio and delete the respective package folder from the paths 
	specified in .libPaths()
3. Prepare the config.json property file
```
	{
		"authType": "ClientCredential",
		"resource": "https://datalake.azure.net/",
		"tenantID": "72f988bf-blah-41af-blah-2d7cd011blah",
		"clientID": "1d604733-blah-4b37-blah-98fca981blah",
		"authKey": "zTw5blah+IN+yIblahrKv2K8dM2/BLah4FogBLAH/ME=",
		"azureDataLakeAccount": "adlsrtest"
	}
```
4. Configure the config.json file path in the GettingStarted.R file
```
	configPath <- paste0(getwd(), "/../config.json")
```
5. Build and reload the client.
6. Run the sample R client
```
	setwd("<path-to-root-of_adls-azure-data-lake-store-R-get-started_local-repo>")
	doSomeADLSOperations()
```

## Resources

- AzureSMR: github repo: https://github.com/Microsoft/AzureSMR
- AzureSMR: R connector for ADLS tutorial: http://htmlpreview.github.io/?https://github.com/Microsoft/AzureSMR/blob/master/inst/doc/tutorial.html --> Accessing Azure Data Lake Store using the azureActiveContext
- Authentication: End-user authentication for your application: https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-end-user-authenticate-java-sdk
- Authentication: Service-to-service authentication for your application: https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-service-to-service-authenticate-java
