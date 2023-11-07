
$githubOrganizationName = 'nicoarapaul'
$githubRepositoryName = 'Paul2Bicep'

$applicationRegistration = New-AzADApplication -DisplayName 'toy-website-test'
New-AzADAppFederatedCredential `
   -Name 'toy-website-test' `
   -ApplicationObjectId $applicationRegistration.Id `
   -Issuer 'https://token.actions.githubusercontent.com' `
   -Audience 'api://AzureADTokenExchange' `
   -Subject "repo:$($githubOrganizationName)/$($githubRepositoryName):environment:Website"

New-AzADAppFederatedCredential `
   -Name 'toy-website-test-branch' `
   -ApplicationObjectId $applicationRegistration.Id `
   -Issuer 'https://token.actions.githubusercontent.com' `
   -Audience 'api://AzureADTokenExchange' `
   -Subject "repo:$($githubOrganizationName)/$($githubRepositoryName):ref:refs/heads/main"


   $resourceGroup = New-AzResourceGroup -Name ToyWebsiteTest -Location westus3

New-AzADServicePrincipal -AppId $($applicationRegistration.AppId)
New-AzRoleAssignment `
  -ApplicationId $($applicationRegistration.AppId) `
  -RoleDefinitionName Contributor `
  -Scope $($resourceGroup.ResourceId)

  $azureContext = Get-AzContext
Write-Host "AZURE_CLIENT_ID: $($applicationRegistration.AppId)"
Write-Host "AZURE_TENANT_ID: $($azureContext.Tenant.Id)"
Write-Host "AZURE_SUBSCRIPTION_ID: $($azureContext.Subscription.Id)"