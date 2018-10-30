param(
    [parameter(Mandatory=$false)]
    [string]$templatePath = ".\armTemplates\baseVm.json",
    [parameter(Mandatory=$false)]
    [string]$deploymentLocation = "North Europe",
    [parameter(Mandatory=$false)]
    [string]$resourceGroupName = "infrastructure-rg"
)

Write-Output "Please enter the credentials that will be used for the VM"

$creds = Get-Credential

$deploymentParams = @{ "adminUsername" = $creds.UserName; "adminPassword" = $creds.Password}

New-AzureRmResourceGroup -Name $resourceGroupName -Location $deploymentLocation

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName -Name "deploy-infrastructure" `
                                    -TemplateUri $templatePath -TemplateParameterObject $deploymentParams `
                                    -Verbose