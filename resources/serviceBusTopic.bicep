param name string
param location string = resourceGroup().location
param locationCode string = 'wus2'

@allowed([
    'dev'
    'test'
    'prod'
])
param env string = 'dev'

param serviceBusTopic string

var metadata = {
    longName: '{0}-${name}-${env}-${locationCode}'
    shortName: '{0}${name}${env}${locationCode}'
}

var serviceBus = {
    name: format(metadata.longName, 'svcbus')
    location: location
    topic: serviceBusTopic
}

resource svcbusTopic 'Microsoft.ServiceBus/namespaces/topics@2021-06-01-preview' = {
    name: '${serviceBus.name}/${serviceBus.topic}'
    properties: {
        requiresDuplicateDetection: true
    }
}

output topic string = serviceBus.topic
