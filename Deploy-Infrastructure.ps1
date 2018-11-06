param(
    [parameter(Mandatory=$false)]
    [string]$vmTemplatePath = ".\armTemplates\baseVm.json",
    [parameter(Mandatory=$false)]
    [string]$vnetTemplatePath = ".\armTemplates\baseVnet.json",
    [parameter(Mandatory=$false)]
    [string]$deploymentLocation = "North Europe",
    [parameter(Mandatory=$false)]
    [string]$resourceGroupName = "infrastructure-rg",
    [parameter(Mandatory=$false)]
    [pscredential]$adminCreds = $null,
    [parameter(Mandatory=$false)]
    [string]$vnetName = "vnet"
)

Write-Output "Please enter the credentials that will be used for the VM"

if ($null -eq $adminCreds) {
    $adminCreds = Get-Credential
}

New-AzureRmResourceGroup -Name $resourceGroupName -Location $deploymentLocation

$vnetDeploymentParams = @{ "vnetName" = $vnetName }

$vnet = New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "deploy-infrastructure" `
                                    -TemplateUri $vnetTemplatePath -TemplateParameterObject $vnetDeploymentParams `
                                    -Verbose

$vmDeploymentParams = @{ "adminUsername" = $adminCreds.UserName; "adminPassword" = $adminCreds.Password; "vnetID" = $vnet.outputs.vnetID.value}

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "deploy-infrastructure" `
                                    -TemplateUri $vmTemplatePath -TemplateParameterObject $vmDeploymentParams `
                                    -Verbose