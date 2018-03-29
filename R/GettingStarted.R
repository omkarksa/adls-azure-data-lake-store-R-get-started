
#' SAMPLE using ClientCredentials config_clientcredentials.json:
#'
#' {
#' "authType": "ClientCredential",
#' "resource": "https://datalake.azure.net/",
#' "tenantID": "72f988bf-blah-41af-blah-2d7cd011blah",
#' "clientID": "1d604733-blah-4b37-blah-98fca981blah",
#' "authKey": "zTw5blah+IN+yIblahrKv2K8dM2/BLah4FogBLAH/ME=",
#' "azureDataLakeAccount": "azuresmrtestadls"
#' }
#'
#' OR SAMPLE using DeviceCode config_devicecode.json:
#'
#' {
#' "authType": "DeviceCode",
#' "resource": "https://datalake.azure.net/",
#' "tenantID": "72fblahf-blah-41af-blah-2d7cBLAHdb47",
#' "clientID": "2dblah05-blah-4e0a-blah-ae4d2BLAH5df",
#' }


#' keeping all static variables here
{
  configPath <- paste0(getwd(), "/../config.json")
}

#' Create a new `azureActiveContext` using the config.json property file.
#'
#' @return `azureActiveContext` object
getAzureActiveContext <- function() {
  config <- read.AzureSMR.config(configPath)
  asc <- createAzureContext()
  with(config,
       # do NOT specify authKey for DeviceCode based auth
       setAzureContext(asc, tenantID = tenantID, clientID = clientID, authKey = authKey, authType = authType, resource = resource)
  )
  azureAuthenticateOnAuthType(asc)
  return(asc)
}

getADLSAccountName <- function() {
  config <- read.AzureSMR.config(paste0(getwd(), "/../config.json"))
  return(config$azureDataLakeAccount)
}

#' Main function that does some basic ADLS operations.
#'
doSomeADLSOperations <- function() {
  #get all required objects for an ADLS operation
  asc <- getAzureActiveContext()
  azureDataLakeAccount <- getADLSAccountName()

  res <- azureDataLakeMkdirs(asc, azureDataLakeAccount, "deleteme")
  print(res)

  res <- azureDataLakeGetFileStatus(asc, azureDataLakeAccount, "deleteme")
  print(res)

  res <- azureDataLakeCreate(asc, azureDataLakeAccount, "deleteme/deleteme00.txt", contents = charToRaw("abcd"))
  print(res)

  res <- azureDataLakeRead(asc, azureDataLakeAccount, "deleteme/deleteme00.txt")
  print(rawToChar(res))

  res <- azureDataLakeCreate(asc, azureDataLakeAccount, "deleteme/sampledata.csv")
  datafileCSV <- paste0(getwd(), "/data/sampledata.csv")
  binData <- readBin(con = datafileCSV, what = "raw", n = 7257)
  # Upload a sample CSV file to ADLS
  adlFOS <- azureDataLakeAppendBOS(asc, azureDataLakeAccount, "deleteme/sampledata.csv")
  res <- adlFileOutputStreamWrite(adlFOS, binData, 1, 7257L)
  res <- adlFileOutputStreamClose(adlFOS)
  # Download the sample CSV file from ADLS
  adlFIS <- azureDataLakeOpenBIS(asc, azureDataLakeAccount, "deleteme/sampledata.csv")
  buffer <- raw(7257)
  res <- adlFileInputStreamRead(adlFIS, 0L, buffer, 1L, 7257L)
  print(rawToChar(res[[2]]))
  res <- adlFileInputStreamClose(adlFIS, TRUE)

  res <- azureDataLakeDelete(asc, azureDataLakeAccount, "deleteme", TRUE)
  print(res)
}
