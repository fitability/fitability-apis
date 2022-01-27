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
param serviceBusSubscription string

var metadata = {
    longName: '{0}-${name}-${env}-${locationCode}'
    shortName: '{0}${name}${env}${locationCode}'
}

var serviceBus = {
    name: format(metadata.longName, 'svcbus')
    location: location
    topic: serviceBusTopic
    subscription: serviceBusSubscription
}

resource svcbusTopicSubscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-06-01-preview' = {
    name: '${serviceBus.name}/${serviceBus.topic}/${serviceBus.subscription}'
    properties: {
        maxDeliveryCount: 10
    }
}

resource svcbusTopicSubscriptionRule 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2021-06-01-preview' = {
    name: '${svcbusTopicSubscription.name}/${serviceBus.subscription}-filter'
    properties: {
        filterType: 'SqlFilter'
        sqlFilter: {
            sqlExpression: '1=1'
        }
    }
}

output subscription string = serviceBus.subscription
