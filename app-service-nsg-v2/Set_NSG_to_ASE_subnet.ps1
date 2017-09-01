 Variables that need to be set

# The subscriptionId
$subscriptionId = '5cc5fbe7-51cc-4492-ad12-f923efbb9ade'
$vnet_name="CHANGE_TO_VNET_NAME" # set VNET name
$subnet_name = "CHANGE_TO_SUBENT_NAME" # set the subnet
$addressprefix="CHANGE_TO_SUBNET_PREFIX" #specify subnet IP space in format a.b.c.d/z
$nsg_name="CHANGE_TO_NSG_NAME" #set the ASE NSG name
$RG = "CHANGE_TO_RESOURCE_GROUP_NAME" #set the Resource group name. Assumption that all resources are containted in the same Resource group


$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $RG -Name $vnet_name
$nsg=Get-AzureRmNetworkSecurityGroup -Name $nsg_name -ResourceGroupName $RG

Set-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnet_name -NetworkSecurityGroup $nsg -AddressPrefix $addressprefix

$vnet | Set-AzureRmVirtualNetwork
