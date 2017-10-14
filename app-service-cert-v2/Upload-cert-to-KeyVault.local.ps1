# Variables that need to be set
Login-AzureRmAccount

# The subscriptionId
$subscriptionId = 'SUBSCRIPTION_ID' #Subscription ID
$KeyVaultName = "ase-kv"  #Key Vault Name
$pfxFilePath = "C:\Users\makolo\git\ase-ilb\app-service-cert-v2\a-exportedcert.pfx" # Change this path 
$pwd = "password" # Change this password 
$KeyVaultSecretName="ase-cert"     #change to set the name of the secret


$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable 
$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection 
$collection.Import($pfxFilePath, $pwd, $flag) 
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12 
$clearBytes = $collection.Export($pkcs12ContentType) 
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes) 
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force 
$secretContentType = 'application/x-pkcs12' 
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $Secret -ContentType $secretContentType # Change Key Vault name and Secret name 