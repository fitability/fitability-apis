param name string
param shortName string = ''
param suffix string = ''
param location string = resourceGroup().location
param locationCode string = 'wus2'
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
    'poweshell'
    'python'
])
param functionWorkerRuntime string = 'dotnet'

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

module st './storageAccount.bicep' = if (storageAccountToProvision) {
    name: 'StorageAccount'
    params: {
        name: shortName
        suffix: suffix
        location: location
        locationCode: locationCode
        env: env
        storageAccountSku: storageAccountSku
    }
}

module wrkspc './logAnalyticsWorkspace.bicep' = if (workspaceToProvision && functionAppToProvision) {
    name: 'LogAnalyticsWorkspace'
    params: {
        name: name
        suffix: suffix
        location: location
        locationCode: locationCode
        env: env
        workspaceSku: workspaceSku
    }
}

module wrkspcapimgmt './logAnalyticsWorkspace.bicep' = if (workspaceToProvision && apiMgmtToProvision) {
    name: 'LogAnalyticsWorkspaceForApiManagement'
    params: {
        name: name
        location: location
        locationCode: locationCode
        env: env
        workspaceSku: workspaceSku
    }
}

module appins './appInsights.bicep' = if (appInsightsToProvision && functionAppToProvision) {
    name: 'ApplicationInsights'
    params: {
        name: name
        suffix: suffix
        location: location
        locationCode: locationCode
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
        location: location
        locationCode: locationCode
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
        location: location
        locationCode: locationCode
        env: env
        consumptionPlanIsLinux: consumptionPlanIsLinux
    }
}

module fncapp './functionApp.bicep' = if (functionAppToProvision) {
    name: 'FunctionApp'
    params: {
        name: name
        suffix: suffix
        location: location
        locationCode: locationCode
        env: env
        storageAccountId: st.outputs.id
        storageAccountName: st.outputs.name
        appInsightsId: appins.outputs.id
        consumptionPlanId: csplan.outputs.id
        functionEnvironment: functionEnvironment
        functionExtensionVersion: functionExtensionVersion
        functionWorkerRuntime: functionWorkerRuntime
    }
}

module svcbus './serviceBus.bicep' = if (serviceBusToProvision) {
    name: 'ServiceBus'
    params: {
        name: name
        location: location
        locationCode: locationCode
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
        location: location
        locationCode: locationCode
        env: env
        serviceBusTopic: serviceBusTopic
    }
}

module svcbustpcstandalone './serviceBusTopic.bicep' = if (!serviceBusToProvision && serviceBusTopicToProvision) {
    name: 'ServiceBusTopicStandAlone'
    params: {
        name: name
        location: location
        locationCode: locationCode
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
        location: location
        locationCode: locationCode
        env: env
        serviceBusTopic: serviceBusTopic
        serviceBusSubscription: serviceBusTopicSubscription
    }
}

module svcbustpcsubstandalone './serviceBusTopicSubscription.bicep' = if (!serviceBusTopicToProvision && serviceBusTopicSubscriptionToProvision) {
    name: 'ServiceBusTopicSubscriptionStandAlone'
    params: {
        name: name
        location: location
        locationCode: locationCode
        env: env
        serviceBusTopic: serviceBusTopic
        serviceBusSubscription: serviceBusTopicSubscription
    }
}

module cosdba './cosmosDb.bicep' = if (cosmosDbToProvision) {
    name: 'CosmosDB'
    params: {
        name: name
        location: location
        locationCode: locationCode
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
        location: location
        locationCode: locationCode
        env: env
        appInsightsId: appinsapimgmt.outputs.id
        appInsightsInstrumentationKey: appinsapimgmt.outputs.instrumentationKey
        apiMgmtSkuName: apiMgmtSkuName
        apiMgmtSkuCapacity: apiMgmtSkuCapacity
        apiMgmtPublisherName: apiMgmtPublisherName
        apiMgmtPublisherEmail: apiMgmtPublisherEmail
    }
}
