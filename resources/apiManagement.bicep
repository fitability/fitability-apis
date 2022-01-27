param name string
param location string = resourceGroup().location
param locationCode string = 'wus2'

@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

param appInsightsId string

@secure()
param appInsightsInstrumentationKey string

@allowed([
    'Consumption'
    'Isolated'
    'Developer'
    'Basic'
    'Standard'
    'Premium'
])
param apiMgmtSkuName string = 'Consumption'

param apiMgmtSkuCapacity int = 0

param apiMgmtPublisherName string
param apiMgmtPublisherEmail string

var metadata = {
    longName: '{0}-${name}-${env}-${locationCode}'
    shortName: '{0}${name}${env}${locationCode}'
}

var appInsights = {
    id: appInsightsId
    name: format(metadata.longName, 'appins')
    instrumentationKey: appInsightsInstrumentationKey
}
var apiManagement = {
    name: format(metadata.longName, 'apim')
    location: location
    skuName: apiMgmtSkuName
    skuCapacity: apiMgmtSkuCapacity
    publisherName: apiMgmtPublisherName
    publisherEmail: apiMgmtPublisherEmail
}

resource apim 'Microsoft.ApiManagement/service@2021-08-01' = {
    name: apiManagement.name
    location: apiManagement.location
    sku: {
        name: apiManagement.skuName
        capacity: apiManagement.skuCapacity
    }
    properties: {
        publisherName: apiManagement.publisherName
        publisherEmail: apiManagement.publisherEmail
    }
}

resource apimlogger 'Microsoft.ApiManagement/service/loggers@2021-08-01' = {
    name: '${apim.name}/${appInsights.name}'
    properties: {
        loggerType: 'applicationInsights'
        resourceId: appInsights.id
        credentials: {
            instrumentationKey: appInsights.instrumentationKey
        }
    }
}

output id string = apim.id
output name string = apim.name
