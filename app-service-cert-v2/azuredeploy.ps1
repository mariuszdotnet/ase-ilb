# Variables that need to be set

# The subscriptionId
$subscriptionId = '5cc5fbe7-51cc-4492-ad12-f923efbb9ade'
# Root path to script, template and parameters.  All have to be in the same folder.
$rootPath = 'C:\Users\nataliak\Source\Repos\ase-ilb\app-service-cert-v2' # Replace with $PSScriptRoot if you want to run it as a script; EXAMPLE: $rootPath = 'C:\Users\makolo\Documents\GitHub\azure-vmss-templates\vm-simple-rhel'
# Name of the resource group
$resourceGroupName = 'ASEv2'
# Resource Group Location 
$resourceGroupLocation = 'East US 2' # Run <Get-AzureLocation> to find out azure locations; EXAMPLE: 'East US 2'
# Name of the deployment
$deploymentName = 'ASEv2cert'
$KeyVaultName = "ASEv2-Keyvault"
$WebRP_SP="abfa0a7c-a6b6-4736-8310-5855508787cd"
$KeyVaultNamePermissions="get"

#Login-AzureRmAccount

Get-AzureSubscription

Select-AzureRmSubscription -SubscriptionId $subscriptionId

# One Time Activity to  
Set-AzureRmContext -SubscriptionId $subscriptionId 
Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ServicePrincipalName $WebRP_SP -PermissionsToSecrets $KeyVaultNamePermissions -Verbose 

# Create the new Azure Resource Group
New-AzureRmResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation -Force

# Run the below to test the ARM template
Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "$rootPath\azuredeploy.json" -TemplateParameterFile "$rootPath\azuredeploy.parameters.json"

# Use parameter file
New-AzureRmResourceGroupDeployment -verbose -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile "$rootPath\azuredeploy.json" -TemplateParameterFile "$rootPath\azuredeploy.parameters.json"

# Input parameters manually via CLI
#New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $resourceGroupName -TemplateFile "$rootPath\azuredeploy.json"
