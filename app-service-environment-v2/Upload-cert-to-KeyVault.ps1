# Variables that need to be set

# The subscriptionId
$subscriptionId = '5cc5fbe7-51cc-4492-ad12-f923efbb9ade' #Subscription ID
$KeyVaultName = "ASEv2-Keyvault"  #Key Vault Name
$pfxFilePath = "C:\Users\nataliak\OneDrive - Microsoft\Customers\Manulife\TRS\ASEv2-ARM Templates\DigiCert_certs\wildcard_azureminilab_com.pfx" # Change this path 
$pwd = "R37fallacy" # Change this password 
$KeyVaultSecretName="azureminilab-cert-asev2"     #change to set the name of the secret


$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable 
$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection 
$collection.Import($pfxFilePath, $pwd, $flag) 
$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12 
$clearBytes = $collection.Export($pkcs12ContentType) 
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes) 
$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force 
$secretContentType = 'application/x-pkcs12' 
Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $Secret -ContentType $secretContentType # Change Key Vault name and Secret name 