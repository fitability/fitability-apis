param name string
param shortName string = ''
param suffix string = ''
param location string = ''
param locationCode string = ''
@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

// Storage
param storageAccountToProvision bool = false
@allowed([
    'Standard_LRS'
    'Standard_ZRS'    
    'Standard_GRS'
    'Standard_GZRS'
    'Standard_RAGRS'
    'Standard_RAGZRS'
    'Premium_LRS'
    'Premium_ZRS'
])
param storageAccountSku string = 'Standard_LRS'
param storageAccountBlobContainers array = []
param storageAccountTables array = []

// Log Analytics Workspace
param workspaceToProvision bool = false
@allowed([
    'Free'
    'Standard'
    'Premium'
    'Standalone'
    'LACluster'
    'PerGB2018'
    'PerNode'
    'CapacityReservation'
])
param workspaceSku string = 'PerGB2018'

// Application Insights
param appInsightsToProvision bool = false
@allowed([
    'web'
    'other'
])
param appInsightsType string = 'web'

@allowed([
    'ApplicationInsights'
    'ApplicationInsightsWithDiagnosticSettings'
    'LogAnalytics'
])
param appInsightsIngestionMode string = 'LogAnalytics'

// Consumption Plan
param consumptionPlanToProvision bool = false
param consumptionPlanIsLinux bool = false

// Function App
param functionAppToProvision bool = false
@allowed([
    'Development'
    'Staging'
    'Production'
])
param functionEnvironment string = 'Production'
@allowed([
    'v3'
    'v4'
])
param functionExtensionVersion string = 'v4'
@allowed([
    'dotnet'
    'dotnet-isolated'
    'java'
    'node'
    'python'
    'poweshell'
])
param functionWorkerRuntime string = 'dotnet'
@allowed([
    // dotnet / dotnet-isolated
    'v6.0'
    // java
    'v8'
    'v11'
    // node.js
    'v12'
    'v14'
    'v16'
    // python
    'v3.7'
    'v3.8'
    'v3.9'
    // powershell
    'v7'
])
param functionWorkerVersion string = 'v6.0'

// Service Bus
param serviceBusToProvision bool = false
@allowed([
    'Basic'
    'Standard'
    'Premium'
])
param serviceBusSku string = 'Standard'
param serviceBusAuthRule string = 'RootManageSharedAccessKey'

// Service Bus Topic
param serviceBusTopicToProvision bool = false
param serviceBusTopic string

// Service Bus Topic Subscription
param serviceBusTopicSubscriptionToProvision bool = false
param serviceBusTopicSubscription string

// Cosmos DB
param cosmosDbToProvision bool = false
param cosmosDbAccountOfferType string = 'Standard'
param cosmosDbAutomaticFailover bool = true
@allowed([
    'Strong'
    'BoundedStaleness'
    'Session'
    'ConsistentPrefix'
    'Eventual'
])
param cosmosDbConsistencyLevel string = 'Session'
param cosmosDbPrimaryRegion string = 'West US 2'
@allowed([
    'EnableCassandra'
    'EnableGremlin'
    'EnableServerless'
    'EnableTable'
])
param cosmosDbCapability string = 'EnableServerless'
@allowed([
    'Local'
    'Zone'
    'Geo'
])
param cosmosDbBackupStorageRedundancy string = 'Local'

// API Management
param apiMgmtToProvision bool = false
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

var locationResolved = location == '' ? resourceGroup().location : location
var locationCodeMap = {
    koreacentral: 'krc'
    'Korea Central': 'krc'
    westus2: 'wus2'
    'West US 2': 'wus2'
}
var locationCodeResolved = locationCode == '' ? locationCodeMap[locationResolved] : locationCode

module st './storageAccount.bicep' = if (storageAccountToProvision) {
    name: 'StorageAccount'
    params: {
        name: shortName
        suffix: suffix
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        storageAccountSku: storageAccountSku
        storageAccountBlobContainers: storageAccountBlobContainers
        storageAccountTables: storageAccountTables
    }
}

module wrkspc './logAnalyticsWorkspace.bicep' = if (workspaceToProvision && functionAppToProvision) {
    name: 'LogAnalyticsWorkspace'
    params: {
        name: name
        suffix: suffix
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        workspaceSku: workspaceSku
    }
}

module wrkspcapimgmt './logAnalyticsWorkspace.bicep' = if (workspaceToProvision && apiMgmtToProvision) {
    name: 'LogAnalyticsWorkspaceForApiManagement'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        workspaceSku: workspaceSku
    }
}

module appins './appInsights.bicep' = if (appInsightsToProvision && functionAppToProvision) {
    name: 'ApplicationInsights'
    params: {
        name: name
        suffix: suffix
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        appInsightsType: appInsightsType
        appInsightsIngestionMode: appInsightsIngestionMode
        workspaceId: wrkspc.outputs.id
    }
}

module appinsapimgmt './appInsights.bicep' = if (appInsightsToProvision && apiMgmtToProvision) {
    name: 'ApplicationInsightsForApiManagement'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        appInsightsType: appInsightsType
        appInsightsIngestionMode: appInsightsIngestionMode
        workspaceId: wrkspcapimgmt.outputs.id
    }
}

module csplan './consumptionPlan.bicep' = if (consumptionPlanToProvision) {
    name: 'ConsumptionPlan'
    params: {
        name: name
        suffix: suffix
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        consumptionPlanIsLinux: consumptionPlanIsLinux
    }
}

module fncapp './functionApp.bicep' = if (functionAppToProvision) {
    name: 'FunctionApp'
    params: {
        name: name
        suffix: suffix
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        storageAccountId: st.outputs.id
        storageAccountName: st.outputs.name
        appInsightsId: appins.outputs.id
        consumptionPlanId: csplan.outputs.id
        functionIsLinux: consumptionPlanIsLinux
        functionEnvironment: functionEnvironment
        functionExtensionVersion: functionExtensionVersion
        functionWorkerRuntime: functionWorkerRuntime
        functionWorkerVersion: functionWorkerVersion
    }
}

module svcbus './serviceBus.bicep' = if (serviceBusToProvision) {
    name: 'ServiceBus'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        serviceBusSku: serviceBusSku
        serviceBusAuthRule: serviceBusAuthRule
    }
}

module svcbustpc './serviceBusTopic.bicep' = if (serviceBusToProvision && serviceBusTopicToProvision) {
    name: 'ServiceBusTopic'
    dependsOn: [
        svcbus
    ]
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        serviceBusTopic: serviceBusTopic
    }
}

module svcbustpcstandalone './serviceBusTopic.bicep' = if (!serviceBusToProvision && serviceBusTopicToProvision) {
    name: 'ServiceBusTopicStandAlone'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        serviceBusTopic: serviceBusTopic
    }
}

module svcbustpcsub './serviceBusTopicSubscription.bicep' = if (serviceBusTopicToProvision && serviceBusTopicSubscriptionToProvision) {
    name: 'ServiceBusTopicSubscription'
    dependsOn: [
        svcbustpc
    ]
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        serviceBusTopic: serviceBusTopic
        serviceBusSubscription: serviceBusTopicSubscription
    }
}

module svcbustpcsubstandalone './serviceBusTopicSubscription.bicep' = if (!serviceBusTopicToProvision && serviceBusTopicSubscriptionToProvision) {
    name: 'ServiceBusTopicSubscriptionStandAlone'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        serviceBusTopic: serviceBusTopic
        serviceBusSubscription: serviceBusTopicSubscription
    }
}

module cosdba './cosmosDb.bicep' = if (cosmosDbToProvision) {
    name: 'CosmosDB'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        cosmosDbAccountOfferType: cosmosDbAccountOfferType
        cosmosDbAutomaticFailover: cosmosDbAutomaticFailover
        cosmosDbConsistencyLevel: cosmosDbConsistencyLevel
        cosmosDbPrimaryRegion: cosmosDbPrimaryRegion
        cosmosDbCapability: cosmosDbCapability
        cosmosDbBackupStorageRedundancy: cosmosDbBackupStorageRedundancy
    }
}

module apim './apiManagement.bicep' = if (apiMgmtToProvision) {
    name: 'ApiManagement'
    params: {
        name: name
        location: locationResolved
        locationCode: locationCodeResolved
        env: env
        appInsightsId: appinsapimgmt.outputs.id
        appInsightsInstrumentationKey: appinsapimgmt.outputs.instrumentationKey
        apiMgmtSkuName: apiMgmtSkuName
        apiMgmtSkuCapacity: apiMgmtSkuCapacity
        apiMgmtPublisherName: apiMgmtPublisherName
        apiMgmtPublisherEmail: apiMgmtPublisherEmail
    }
}
