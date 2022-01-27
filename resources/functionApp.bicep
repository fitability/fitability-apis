param name string
param suffix string = ''
param location string = resourceGroup().location
param locationCode string = 'wus2'

@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

param storageAccountId string
param storageAccountName string
param appInsightsId string
param consumptionPlanId string

@allowed([
    'Development'
    'Staging'
    'Production'
])
param functionEnvironment string = 'Production'

@allowed([
    'dotnet'
    'dotnet-isolated'
    'java'
    'node'
    'poweshell'
    'python'
])
param functionWorkerRuntime string = 'dotnet'

var metadata = {
    longName: '{0}-${name}{1}-${env}-${locationCode}'
    shortName: '{0}${name}{1}${env}${locationCode}'
}

var storage = {
    id: storageAccountId
    name: storageAccountName
}
var consumption = {
    id: consumptionPlanId
}
var appInsights = {
    id: appInsightsId
}
var functionApp = {
    name: suffix == '' ? format(metadata.longName, 'fncapp', '') : format(metadata.longName, 'fncapp', '-${suffix}')
    location: location
    environment: functionEnvironment
    workerRuntime: functionWorkerRuntime
}

resource fncapp 'Microsoft.Web/sites@2021-02-01' = {
    name: functionApp.name
    location: functionApp.location
    kind: 'functionapp'
    properties: {
        serverFarmId: consumption.id
        httpsOnly: true
        siteConfig: {
            cors: {
                allowedOrigins: [
                    'https://functions.azure.com'
                    'https://functions-staging.azure.com'
                    'https://functions-next.azure.com'
                    'https://flow.microsoft.com'
                    'https://asia.flow.microsoft.com'
                ]
            }
            appSettings: [
                // Common Settings
                {
                    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
                    value: '${reference(appInsights.id, '2020-02-02', 'Full').properties.InstrumentationKey}'
                }
                {
                    name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
                    value: '${reference(appInsights.id, '2020-02-02', 'Full').properties.connectionString}'
                }
                {
                    name: 'AZURE_FUNCTIONS_ENVIRONMENT'
                    value: functionApp.environment
                }
                {
                    name: 'AzureWebJobsStorage'
                    value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storage.id, '2021-06-01').keys[0].value}'
                }
                {
                    name: 'FUNCTION_APP_EDIT_MODE'
                    value: 'readonly'
                }
                {
                    name: 'FUNCTIONS_EXTENSION_VERSION'
                    value: '~4'
                }
                {
                    name: 'FUNCTIONS_WORKER_RUNTIME'
                    value: functionApp.workerRuntime
                }
                {
                    name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
                    value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storage.id, '2021-06-01').keys[0].value}'
                }
                {
                    name: 'WEBSITE_CONTENTSHARE'
                    value: functionApp.name
                }
            ]
        }
    }
}

output id string = fncapp.id
output name string = fncapp.name
