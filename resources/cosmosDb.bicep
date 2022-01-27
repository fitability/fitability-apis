param name string
param location string = resourceGroup().location
param locationCode string = 'wus2'

@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

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

var metadata = {
    longName: '{0}-${name}-${env}-${locationCode}'
    shortName: '{0}${name}${env}${locationCode}'
}

var cosmosDb = {
    name: format(metadata.longName, 'cosdba')
    location: location
    databaseAccountOfferType: cosmosDbAccountOfferType
    enableAutomaticFailover: cosmosDbAutomaticFailover
    defaultConsistencyLevel: cosmosDbConsistencyLevel
    primaryRegion: cosmosDbPrimaryRegion
    capability: cosmosDbCapability
    backupStorageRedundancy: cosmosDbBackupStorageRedundancy
}

resource cosdba 'Microsoft.DocumentDB/databaseAccounts@2021-10-15' = {
    name: cosmosDb.name
    location: cosmosDb.location
    kind: 'GlobalDocumentDB'
    properties: {
        databaseAccountOfferType: cosmosDb.databaseAccountOfferType
        enableAutomaticFailover: cosmosDb.enableAutomaticFailover
        consistencyPolicy: {
            defaultConsistencyLevel: cosmosDb.defaultConsistencyLevel
            maxIntervalInSeconds: 5
            maxStalenessPrefix: 100
        }
        locations: [
            {
                locationName: cosmosDb.primaryRegion
                failoverPriority: 0
                isZoneRedundant: false
            }
        ]
        capabilities: [
            {
                name: cosmosDb.capability
            }
        ]
        backupPolicy: {
            type: 'Periodic'
            periodicModeProperties: {
                backupIntervalInMinutes: 240
                backupRetentionIntervalInHours: 8
                backupStorageRedundancy: cosmosDb.backupStorageRedundancy
            }
        }
    }
}

output id string = cosdba.id
output name string = cosdba.name
