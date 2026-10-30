<#
.SYNOPSIS
    Creates the foundational Azure resources required to store Terraform state securely for School Management System.
.DESCRIPTION
    This script automates the creation of a Resource Group, a Storage Account, 
    and a Blob Container to be used as a backend for Terraform state (.tfstate).
.EXAMPLE
    .\Setup-TerraformBackend.ps1 -Location "Central US" -Environment "dev"
#>

param (
    [string]$Location = "Central US",
    [string]$Environment = "dev",
    [string]$ResourceGroupName = "school-shared-tfstate-rg",
    # Storage account names must be between 3 and 24 characters in length and use numbers and lower-case letters only.
    [string]$StorageAccountName = "schoolsharedtfstate",
    [string]$ContainerName = "tfstate"
)

# Ensure the user is logged in to Azure
Write-Host "Checking Azure Login Status..." -ForegroundColor Cyan
$loginStatus = az account show 2>$null
if (-not $loginStatus) {
    Write-Host "You are not logged in to Azure. Please log in using the popup window..." -ForegroundColor Yellow
    az login
}

# 1. Create Resource Group
Write-Host "`n1. Creating Resource Group: $ResourceGroupName in $Location..." -ForegroundColor Cyan
az group create --name $ResourceGroupName --location $Location --tags Project=SchoolManagement Environment=$Environment

# 2. Create Storage Account
Write-Host "`n2. Creating Storage Account: $StorageAccountName in $ResourceGroupName..." -ForegroundColor Cyan
az storage account create `
    --resource-group $ResourceGroupName `
    --name $StorageAccountName `
    --sku Standard_LRS `
    --encryption-services blob `
    --allow-blob-public-access false `
    --min-tls-version TLS1_2 `
    --tags Project=SchoolManagement Environment=$Environment

# 3. Create Blob Container
Write-Host "`n3. Creating Blob Container: $ContainerName in $StorageAccountName..." -ForegroundColor Cyan
# Retrieve storage account key to create container
$accountKey = (az storage account keys list --resource-group $ResourceGroupName --account-name $StorageAccountName --query "[0].value" -o tsv)

az storage container create `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --account-key $accountKey

Write-Host "`n=========================================================" -ForegroundColor Green
Write-Host "Terraform Backend Setup Complete for School Management!" -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "Please update your Terraform backend configuration with the following details:"
Write-Host "Resource Group Name:   $ResourceGroupName"
Write-Host "Storage Account Name:  $StorageAccountName"
Write-Host "Container Name:        $ContainerName"
Write-Host "========================================================="
