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

$vmName = "test-vm"

Write-Output "Please enter the credentials that will be used for the VM"

if ($null -eq $adminCreds) {
    $adminCreds = Get-Credential
}

New-AzureRmResourceGroup -Name $resourceGroupName -Location $deploymentLocation

$vnetDeploymentParams = @{ "vnetName" = $vnetName }

Write-Output "Deploying vnet:"
try {
    $vnet = New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "deploy_vnet_$($vnetName)" `
                                    -TemplateUri $vnetTemplatePath -TemplateParameterObject $vnetDeploymentParams `
                                    -Verbose
} catch {
    write-error "Could not deploy vnet. This is a requirement so will exit now"
    exit 1
}

$vmDeploymentParams = @{ "vmName" = $vmName; "adminUsername" = $adminCreds.UserName; "adminPassword" = $adminCreds.Password; "vnetID" = $vnet.outputs.vnetID.value}

$vm = New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "deploy_VM_$($vmName)" `
                                    -TemplateUri $vmTemplatePath -TemplateParameterObject $vmDeploymentParams `
                                    -Verbose


.\Provision-ViaSSH.ps1 -VmCreds $adminCreds -VmIp $vm.Outputs.vmIp.Value -ScriptPath .\provisioning\nodeServer.sh