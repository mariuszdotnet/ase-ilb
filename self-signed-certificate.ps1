# Generate self signed wildcard certificate (Source: http://stackoverflow.com/questions/19441155/how-to-create-a-self-signed-certificate-for-a-domain-name-for-development)
New-SelfSignedCertificate -DnsName *.aseilb.com -CertStoreLocation cert:\LocalMachine\My # MMC -> Certificate Store -> Intermediate Certificate Authority

# Create password for cert
$pwd = ConvertTo-SecureString -String "password" -Force -AsPlainText

# Export Cert - make so sure the change the thumbprint from output of "New-SelfSignedCertificate"
Export-PfxCertificate -cert cert:\localMachine\my\04F766B851C5B949C67117ACA2C8F3A2137DF21A -FilePath C:\Users\makolo\git\ase-ilb\aseilbcert.pfx -Password $pwd