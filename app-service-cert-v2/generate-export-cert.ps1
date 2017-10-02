$certificate = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname "*.aseilb.com","*.scm.aseilb.com"

$certThumbprint = "cert:\localMachine\my\" + $certificate.Thumbprint
$password = ConvertTo-SecureString -String "password" -Force -AsPlainText

$fileName = "a-exportedcert.pfx"
Export-PfxCertificate -cert $certThumbprint -FilePath $fileName -Password $password     

$fileContentBytes = get-content -encoding byte $fileName
$fileContentEncoded = [System.Convert]::ToBase64String($fileContentBytes)
$fileContentEncoded | set-content ($fileName + ".b64")

$certThumbprint

# Get All Thumbprints
Get-ChildItem -path cert:\LocalMachine\My