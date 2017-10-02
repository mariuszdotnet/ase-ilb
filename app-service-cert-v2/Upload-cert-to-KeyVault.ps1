#$subscriptionId = "5aec60e9-f535-4bd7-a951-2833f043e918" #Subscription ID
$KeyVaultName = "ase-kv"  #Key Vault Name
$KeyVaultSecretName="asecert2"     #change to set the name of the secret

$pfxFilePath = 'C:\Users\makolo\git\ase-ilb\app-service-cert-v2\a-exportedcert.pfx'
$pwd = 'password'
$flag = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
$collection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection 
$collection.Import($pfxFilePath, $pwd, $flag)
#$pkcs12ContentType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12
$clearBytes = $collection.Export($pkcs12ContentType)
$fileContentEncoded = [System.Convert]::ToBase64String($clearBytes)

$fileContentEncoded

#$secret = ConvertTo-SecureString -String $fileContentEncoded -AsPlainText –Force
#$secretContentType = 'application/x-pkcs12'
#Set-AzureKeyVaultSecret -VaultName $KeyVaultName -Name $KeyVaultSecretName -SecretValue $Secret -ContentType $secretContentType

# simple version
$fileName = "exportedcert.pfx"
Export-PfxCertificate -cert $certThumbprint -FilePath $fileName -Password $password     
$fileContentBytes = get-content -encoding byte $fileName
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)