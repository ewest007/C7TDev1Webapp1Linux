# azure-infrastructure

## Description

Powershell and Azure arm templates for deploying projects from my github and other nodejs git projects

## Installation and usage

### Prerequisites

- Requires Powershell v5
- Requires Azure Powershell
- Requires PoshSSH for powershell

### Usage

- Clone this repository
- Open Powershell
- Login to Azure Powershell with `Connect-AzureRmAccount`
- Select the subscritption to deploy this to with `Select-AzureRmSubscription`
- Run `.\Deploy-Infrastructure.ps1`

## Scripts Description

`.\Deploy-Infrastructure.ps1`
This script will currently deploy the following things:
- Vnet with an app subnet
- Vm with public ip in the app subnet

The script will then provision the app server to host my tube-data app from github using nodeServer.sh and my Provision-ViaSSH.ps1 script

`.\Provision-ViaSSH.ps1`
This script will provision a linux server via ssh and a provided scripts file.

Mandatory parameters:
- -vmCreds(pscredential): The pscredential with username and password for the vm
- -vmIp(string): The ip of the vm to provision
- -scriptPath(string): The path to the script file to run on the specified box