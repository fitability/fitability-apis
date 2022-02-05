# Provisions resources based on Flags
Param(
    [string]
    [Parameter(Mandatory=$false)]
    $ResourceGroupName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $DeploymentName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $ResourceName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $ResourceShortName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $ResourceNameSuffix = "",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("", "koreacentral", "westus2")]
    $Location = "",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("", "krc", "wus2")]
    $LocationCode = "",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "test", "prod")]
    $Environment = "dev",

    ### Storage Account ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionStorageAccount = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Standard_GRS", "Standard_LRS", "Standard_ZRS", "Standard_GZRS", "Standard_RAGRS", "Standard_RAGZRS", "Premium_LRS", "Premium_ZRS")]
    $StorageAccountSku = "Standard_LRS",

    [string[]]
    [Parameter(Mandatory=$false)]
    $StorageAccountBlobContainers = @(),

    [string[]]
    [Parameter(Mandatory=$false)]
    $StorageAccountTables = @(),
    ### Storage Account ###

    ### Log Analytics ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionLogAnalyticsWorkspace = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Free", "Standard", "Premium", "Standalone", "LACluster", "PerGB2018", "PerNode", "CapacityReservation")]
    $LogAnalyticsWorkspaceSku = "PerGB2018",
    ### Log Analytics ###

    ### Application Insights ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionAppInsights = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("web", "other")]
    $AppInsightsType = "web",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("ApplicationInsights", "ApplicationInsightsWithDiagnosticSettings", "LogAnalytics")]
    $AppInsightsIngestionMode = "LogAnalytics",
    ### Application Insights ###

    ### Consumption Plan ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionConsumptionPlan = $false,

    [bool]
    [Parameter(Mandatory=$false)]
    $ConsumptionPlanIsLinux = $false,
    ### Consumption Plan ###

    ### Function App ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionFunctionApp = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Development", "Staging", "Production")]
    $FunctionEnvironment = "Production",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("v3", "v4")]
    $FunctionExtensionVersion = "v4",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("dotnet", "dotnet-isolated", "java", "node", "poweshell", "python")]
    $FunctionWorkerRuntime = "dotnet",
    ### Function App ###

    ### Service Bus ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionServiceBus = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Basic", "Standard", "Premium")]
    $ServiceBusSku = "Standard",

    [string]
    [Parameter(Mandatory=$false)]
    $ServiceBusAuthRule = "RootManageSharedAccessKey",
    ### Service Bus ###

    ### Service Bus Topic ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionServiceBusTopic = $false,

    [string]
    [Parameter(Mandatory=$false)]
    $ServiceBusTopic = "",
    ### Service Bus Topic ###

    ### Service Bus Topic Subscription ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionServiceBusTopicSubscription = $false,

    [string]
    [Parameter(Mandatory=$false)]
    $ServiceBusTopicSubscription = "",
    ### Service Bus Topic Subscription ###

    ### Cosmos DB ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionCosmosDb = $false,

    [string]
    [Parameter(Mandatory=$false)]
    $CosmosDbAccountOfferType = "Standard",

    [bool]
    [Parameter(Mandatory=$false)]
    $CosmosDbAutomaticFailover = $true,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Strong", "BoundedStaleness", "Session", "ConsistentPrefix", "Eventual")]
    $CosmosDbConsistencyLevel = "Session",

    [string]
    [Parameter(Mandatory=$false)]
    $CosmosDbPrimaryRegion = "West US 2",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("EnableCassandra", "EnableGremlin", "EnableServerless", "EnableTable")]
    $CosmosDbCapability = "EnableServerless",

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Local", "Zone", "Geo")]
    $CosmosDbBackupStorageRedundancy = "Local",
    ### Cosmos DB ###

    ### API Management ###
    [bool]
    [Parameter(Mandatory=$false)]
    $ProvisionApiMangement = $false,

    [string]
    [Parameter(Mandatory=$false)]
    [ValidateSet("Consumption", "Isolated", "Developer", "Basic", "Standard", "Premium")]
    $ApiManagementSkuName = "Consumption",

    [int]
    [Parameter(Mandatory=$false)]
    $ApiManagementSkuCapacity = 0,

    [string]
    [Parameter(Mandatory=$false)]
    $ApiManagementPublisherName = "",

    [string]
    [Parameter(Mandatory=$false)]
    $ApiManagementPublisherEmail = "",
    ### API Management ###

    [switch]
    [Parameter(Mandatory=$false)]
    $WhatIf,

    [switch]
    [Parameter(Mandatory=$false)]
    $Help
)

function Show-Usage {
    Write-Output "    This provisions resources to Azure

    Usage: $(Split-Path $MyInvocation.ScriptName -Leaf) ``
            -ResourceGroupName <resource group name> ``
            -DeploymentName <deployment name> ``
            -ResourceName <resource name> ``
            [-ResourceShortName <resource short name> ``
            [-ResourceNameSuffix <resource name suffix>] ``
            [-Location <location>] ``
            [-LocationCode <location code>] ``
            [-Environment <environment>] ``

            [-ProvisionStorageAccount <`$true|`$false>] ``
            [-StorageAccountSku <Storage Account SKU>] ``
            [-StorageAccountBlobContainers <Storage Account blob containers>] ``
            [-StorageAccountTables <Storage Account tables>] ``

            [-ProvisionLogAnalyticsWorkspace <`$true|`$false>] ``
            [-LogAnalyticsWorkspaceSku <Log Analytics workspace SKU>] ``

            [-ProvisionAppInsights <`$true|`$false>] ``
            [-AppInsightsType <Application Insights type>] ``
            [-AppInsightsIngestionMode <Application Insights data ingestion mode>] ``

            [-ProvisionConsumptionPlan <`$true|`$false>] ``
            [-ConsumptionPlanIsLinux <`$true|`$false>] ``

            [-ProvisionFunctionApp <`$true|`$false>] ``
            [-FunctionEnvironment <Function App environment>] ``
            [-FunctionExtensionVersion <Function App extension version>] ``
            [-FunctionWorkerRuntime <Function App worker runtime>] ``

            [-ProvisionServiceBus <`$true|`$false>] ``
            [-ServiceBusSku <Service Bus SKU>] ``
            [-ServiceBusAuthRule <Service Bus authorisation rule>] ``

            [-ProvisionServiceBusTopic <`$true|`$false>] ``
            [-ServiceBusTopic <Service Bus topic>] ``

            [-ProvisionServiceBusTopicSubscription <`$true|`$false>] ``
            [-ServiceBusTopicSubscription <Service Bus topic>] ``

            [-ProvisionCosmosDb <`$true|`$false>] ``
            [-CosmosDbAccountOfferType <Cosmos DB account type>] ``
            [-CosmosDbAutomaticFailover <`$true|`$false>] ``
            [-CosmosDbConsistencyLevel <Cosmos DB consistency level>] ``
            [-CosmosDbPrimaryRegion <Cosmos DB primary region>] ``
            [-CosmosDbCapability <Cosmos DB capability>] ``
            [-CosmosDbBackupStorageRedundancy <Cosmos DB backup storage redundancy>] ``

            [-ProvisionApiMangement <`$true|`$false>] ``
            [-ApiManagementSkuName <API Management SKU name>] ``
            [-ApiManagementSkuCapacity <API Management SKU capacity>] ``
            [-ApiManagementPublisherName <API Management publisher name>] ``
            [-ApiManagementPublisherEmail <API Management publisher email>] ``

            [-WhatIf] ``
            [-Help]

    Options:
        -ResourceGroupName                Resource group name.
        -DeploymentName                   Deployment name.
        -ResourceName                     Resource name.
        -ResourceShortName                Resource short name.
                                          Default is to use the resource name.
        -ResourceNameSuffix               Resource name suffix.
                                          Default is empty string.
        -Location                         Resource location.
                                          Default is empty string.
        -LocationCode                     location code.
                                          Default is empty string.
        -Environment                      environment.
                                          Default is 'dev'.

        -ProvisionStorageAccount          To provision Storage Account or not.
                                          Default is `$false.
        -StorageAccountSku                Storage Account SKU.
                                          Default is 'Standard_LRS'.
        -StorageAccountBlobContainers     Storage Account blob containers array.
                                          Default is empty array.
        -StorageAccountTables             Storage Account tables array.
                                          Default is empty array.

        -ProvisionLogAnalyticsWorkspace   To provision Log Analytics Workspace
                                          or not. Default is `$false.
        -LogAnalyticsWorkspaceSku         Log Analytics workspace SKU.
                                          Default is 'PerGB2018'.

        -ProvisionAppInsights             To provision Application Insights
                                          or not. Default is `$false.
        -AppInsightsType                  Application Insights type.
                                          Default is 'web'.
        -AppInsightsIngestionMode         Application Insights data ingestion
                                          mode. Default is 'ApplicationInsights'.

        -ProvisionConsumptionPlan         To provision Consumption Plan or not.
                                          Default is `$false.
        -ConsumptionPlanIsLinux           To enable Linux Consumption Plan
                                          or not. Default is `$false.

        -ProvisionFunctionApp             To provision Function App or not.
                                          Default is `$false.
        -FunctionEnvironment              Function App environment.
                                          Default is 'Production'.
        -FunctionExtensionVersion         Function App extension version.
                                          Default is 'v4'.
        -FunctionWorkerRuntime            Function App worker runtime.
                                          Default is 'dotnet'.

        -ProvisionServiceBus              To provision Service Bus or not.
                                          Default is `$false.
        -ServiceBusSku                    Service Bus SKU.
                                          Default is 'Standard'.
        -ServiceBusAuthRule               Service Bus authorisation rule.
                                          Default is 'RootManageSharedAccessKey'.

        -ProvisionServiceBusTopic         To provision Service Bus topic or not.
                                          Default is `$false.
        -ServiceBusTopic                  Service Bus topic name.
                                          Default is empty string.
                                          If -ProvisionServiceBusTopic is `$true,
                                          this parameter must have a value.
                                          If -ProvisionServiceBusTopicSubscription
                                          is `$true, this parameter must have a
                                          value.

        -ProvisionServiceBusTopicSubscription
                                          To provision Service Bus topic
                                          subscription or not.
                                          Default is `$false.
        -ServiceBusTopicSubscription      Service Bus topic subscription name.
                                          Default is empty string.
                                          If -ProvisionServiceBusTopicSubscription
                                          is `$true, this parameter must have a
                                          value.

        -ProvisionCosmosDb                To provision Cosmos DB or not.
                                          Default is `$false.
        -CosmosDbAccountOfferType         Cosmos DB account type.
                                          Default is 'Standard'.
        -CosmosDbAutomaticFailover        To enable failover or not.
                                          Default is `$true.
        -CosmosDbConsistencyLevel         Cosmos DB consistency level.
                                          Default is 'Session'.
        -CosmosDbPrimaryRegion            Cosmos DB primary region.
                                          Default is 'West US 2'.
        -CosmosDbCapability               Cosmos DB capability.
                                          Default is 'EnableServerless'.
        -CosmosDbBackupStorageRedundancy  Cosmos DB backup storage redundancy.
                                          Default is 'Local'.

        -ProvisionApiMangement            To provision API Management or not.
                                          Default is `$false.
        -ApiManagementSkuName             API Management SKU name.
                                          Default is 'Consumption'.
        -ApiManagementSkuCapacity         API Management SKU capacity.
                                          Default is 0.
        -ApiManagementPublisherName       API Management publisher name.
                                          Default is empty string.
                                          If -ProvisionApiMangement is `$true,
                                          this parameter must have a value.
        -ApiManagementPublisherEmail      API Management publisher email.
                                          Default is empty string.
                                          If -ProvisionApiMangement is `$true,
                                          this parameter must have a value.

        -WhatIf:                          Show what would happen without
                                          actually provisioning resources.
        -Help:                            Show this message.
"

    Exit 0
}

# Show usage
$needHelp = ($ResourceGroupName -eq "") -or ($DeploymentName -eq "") -or ($ResourceName -eq "") -or ($Help -eq $true)
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}
$needHelp = ($ProvisionServiceBusTopic -eq $true) -and ($ServiceBusTopic -eq "")
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}
$needHelp = ($ProvisionServiceBusTopicSubscription -eq $true) -and (($ServiceBusTopic -eq "") -or ($ServiceBusTopicSubscription -eq ""))
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}
$needHelp = ($ProvisionApiMangement -eq $true) -and (($ApiManagementPublisherName -eq "") -or ($ApiManagementPublisherEmail -eq ""))
if ($needHelp -eq $true) {
    Show-Usage
    Exit 0
}

# Override resource short name with resource name if resource short name is not specified
if ($ResourceShortName -eq "") {
    $ResourceShortName = $ResourceName
}

# Force the dependencies to be provisioned - Application Insights
if ($ProvisionAppInsights -eq $true) {
    $ProvisionLogAnalyticsWorkspace = $true
}

# Force the dependencies to be provisioned - Function App
if ($ProvisionFunctionApp -eq $true) {
    $ProvisionStorageAccount = $true
    $ProvisionConsumptionPlan = $true
    $ProvisionAppInsights = $true
    $ProvisionLogAnalyticsWorkspace = $true
}

# Force the dependencies to be provisioned - API Management
if ($ProvisionApiMangement -eq $true) {
    $ProvisionAppInsights = $true
    $ProvisionLogAnalyticsWorkspace = $true
}

# Build parameters
$params = @{
    name = @{ value = $ResourceName };
    shortName = @{ value = $ResourceShortName };
    suffix = @{ value = $ResourceNameSuffix };
    location = @{ value = $Location };
    locationCode = @{ value = $LocationCode };
    env = @{ value = $Environment };

    storageAccountToProvision = @{ value = $ProvisionStorageAccount };
    storageAccountSku = @{ value = $StorageAccountSku };
    storageAccountBlobContainers = @{ value = $StorageAccountBlobContainers };
    storageAccountTables = @{ value = $StorageAccountTables };

    workspaceToProvision = @{ value = $ProvisionLogAnalyticsWorkspace };
    workspaceSku = @{ value = $LogAnalyticsWorkspaceSku };

    appInsightsToProvision = @{ value = $ProvisionAppInsights };
    appInsightsType = @{ value = $AppInsightsType };
    appInsightsIngestionMode = @{ value = $AppInsightsIngestionMode };

    consumptionPlanToProvision = @{ value = $ProvisionConsumptionPlan };
    consumptionPlanIsLinux = @{ value = $ConsumptionPlanIsLinux };

    functionAppToProvision = @{ value = $ProvisionFunctionApp };
    functionEnvironment = @{ value = $FunctionEnvironment };
    functionExtensionVersion = @{ value = $FunctionExtensionVersion };
    functionWorkerRuntime = @{ value = $FunctionWorkerRuntime };

    serviceBusToProvision = @{ value = $ProvisionServiceBus };
    serviceBusSku = @{ value = $ServiceBusSku };
    serviceBusAuthRule = @{ value = $ServiceBusAuthRule };

    serviceBusTopicToProvision = @{ value = $ProvisionServiceBusTopic };
    serviceBusTopic = @{ value = $ServiceBusTopic };

    serviceBusTopicSubscriptionToProvision = @{ value = $ProvisionServiceBusTopicSubscription };
    serviceBusTopicSubscription = @{ value = $ServiceBusTopicSubscription };

    cosmosDbToProvision = @{ value = $ProvisionCosmosDb };
    cosmosDbAccountOfferType = @{ value = $CosmosDbAccountOfferType };
    cosmosDbAutomaticFailover = @{ value = $CosmosDbAutomaticFailover };
    cosmosDbConsistencyLevel = @{ value = $CosmosDbConsistencyLevel };
    cosmosDbPrimaryRegion = @{ value = $CosmosDbPrimaryRegion };
    cosmosDbCapability = @{ value = $CosmosDbCapability };
    cosmosDbBackupStorageRedundancy = @{ value = $CosmosDbBackupStorageRedundancy };

    apiMgmtToProvision = @{ value = $ProvisionApiMangement };
    apiMgmtSkuName = @{ value = $ApiManagementSkuName };
    apiMgmtSkuCapacity = @{ value = $ApiManagementSkuCapacity };
    apiMgmtPublisherName = @{ value = $ApiManagementPublisherName };
    apiMgmtPublisherEmail = @{ value = $ApiManagementPublisherEmail };
}

# Uncomment to debug
# $params | ConvertTo-Json
# $params | ConvertTo-Json -Compress
# $params | ConvertTo-Json -Compress | ConvertTo-Json

$stringified = $params | ConvertTo-Json -Compress | ConvertTo-Json

# Provision the resources
if ($WhatIf -eq $true) {
    Write-Output "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Provisioning resources as a test ..."
    az deployment group create -g $ResourceGroupName -n $DeploymentName `
        -f ./azuredeploy.bicep `
        -p $stringified `
        -w

        # -u https://raw.githubusercontent.com/fitability/fitability-api/main/resources/azuredeploy.bicep `
} else {
    Write-Output "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Provisioning resources ..."
    az deployment group create -g $ResourceGroupName -n $DeploymentName `
        -f ./azuredeploy.bicep `
        -p $stringified `
        --verbose

        # -u https://raw.githubusercontent.com/fitability/fitability-api/main/resources/azuredeploy.bicep `

    Write-Output "[$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")] Resources have been provisioned"
}
