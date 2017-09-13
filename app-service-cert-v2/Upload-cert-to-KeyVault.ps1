# Variables that need to be set
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionId $subscriptionId


# The subscriptionId
$subscriptionId = "" #Subscription ID
$KeyVaultName = ""  #Key Vault Name
$pfxFilePath = "" # Change this path 
$pwd = "" # Change this password 
$KeyVaultSecretName=""     #change to set the name of the secret

# One time action required per Azure Tenant to Authorize Azure.Web RP to access KeyVault
# Set-AzureRmKeyVaultAccessPolicy -VaultName $KeyVaultName -ServicePrincipalName abfa0a7c-a6b6-4736-8310-5855508787cd -PermissionsToSecrets get

$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable 
$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection 
$collection.Import($pfxFilePath, $pwd, $flag) 
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12 
$clearBytes = $collection.Export($pkcs12ContentType) 
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes) 
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force 
$secretContentType = 'application/x-pkcs12' 
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $Secret -ContentType $secretContentType # Change Key Vault name and Secret name 