param webAppName string = uniqueString(resourceGroup().id)
param sku string = 'F1'
param linuxFxVersion string = 'DOTNETCORE|8.0'
param location string = resourceGroup().location
param repositoryUrl string
param branch string = 'main'
param appServcePlanName string = toLower('AppServicePlan-${webAppName}')
param webSiteName string = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServcePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2023-12-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: { 
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2023-12-01' = { 
  parent: appService
  name: 'web'
  properties: { 
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
