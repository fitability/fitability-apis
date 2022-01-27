param name string
param location string = resourceGroup().location
param locationCode string = 'wus2'

@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

@allowed([
    'Basic'
    'Standard'
    'Premium'
])
param serviceBusSku string = 'Standard'
param serviceBusAuthRule string = 'RootManageSharedAccessKey'

var metadata = {
    longName: '{0}-${name}-${env}-${locationCode}'
    shortName: '{0}${name}${env}${locationCode}'
}

var serviceBus = {
    name: format(metadata.longName, 'svcbus')
    location: location
    sku: serviceBusSku
    authRule: serviceBusAuthRule
}

resource svcbus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
    name: serviceBus.name
    location: serviceBus.location
    sku: {
        name: serviceBus.sku
    }
}

resource svcBusAuthRules 'Microsoft.ServiceBus/namespaces/authorizationRules@2021-06-01-preview' = {
    name: serviceBus.authRule
    parent: svcbus
    properties: {
        rights: [
            'Listen'
            'Send'
            'Manage'
        ]
    }
}

output id string = svcbus.id
output name string = svcbus.name
output authRuleId string = svcBusAuthRules.id
