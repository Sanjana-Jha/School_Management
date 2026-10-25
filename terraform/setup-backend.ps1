<#
.SYNOPSIS
    Provisions Azure Remote Backend for Terraform State in Resource Group 'school-system'.
.DESCRIPTION
    Creates:
    1. Resource Group: 'school-system' (if not already existing)
    2. Storage Account: Unique name (Standard_LRS, TLS 1.2, Blob Versioning enabled)
    3. Blob Container: 'tfstate' (Lease lock & state storage)
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName = "school-system",

    [Parameter(Mandatory = $false)]
    [string]$Location = "centralindia",

    [Parameter(Mandatory = $false)]
    [string]$ContainerName = "tfstate"
)

$ErrorActionPreference = "Stop"

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host " [Terraform Azure Backend Provisioning Script] " -ForegroundColor Yellow
Write-Host "========================================================`n" -ForegroundColor Cyan

# 1. Verify Azure CLI Login
Write-Host "[1/5] Checking Azure CLI authentication..." -ForegroundColor Green
$currentAccount = az account show 2>$null | ConvertFrom-Json
if (-not $currentAccount) {
    Write-Error "Aap Azure CLI me logged in nahi hain! Kripya 'az login' run karein aur dubara run karein."
    exit 1
}
Write-Host "  -> Logged in as: $($currentAccount.user.name)" -ForegroundColor Gray
Write-Host "  -> Subscription: $($currentAccount.name) ($($currentAccount.id))`n" -ForegroundColor Gray

# 2. Create or Verify Resource Group
Write-Host "[2/5] Checking Resource Group '$ResourceGroupName' in '$Location'..." -ForegroundColor Green
$rgExists = az group exists --name $ResourceGroupName
if ($rgExists -eq "false") {
    Write-Host "  -> Creating Resource Group '$ResourceGroupName'..." -ForegroundColor Yellow
    az group create --name $ResourceGroupName --location $Location --output none
    Write-Host "  -> Resource Group '$ResourceGroupName' created successfully!" -ForegroundColor Green
} else {
    Write-Host "  -> Resource Group '$ResourceGroupName' already exists." -ForegroundColor Gray
}

# 3. Generate Unique Storage Account Name (max 24 chars, lowercase alphanumeric)
# Take 10 chars prefix + 10 chars unique hash from sub ID and timestamp
$subPrefix = $currentAccount.id.Replace("-", "").Substring(0, 6)
$randomSuffix = -join ((48..57) + (97..122) | Get-Random -Count 6 | ForEach-Object {[char]$_})
$rawName = "stschooltf$subPrefix$randomSuffix".ToLower()
$StorageAccountName = if ($rawName.Length -gt 24) { $rawName.Substring(0, 24) } else { $rawName }

Write-Host "`n[3/5] Creating Storage Account '$StorageAccountName' for Terraform State..." -ForegroundColor Green
az storage account create `
    --name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --location $Location `
    --sku Standard_LRS `
    --kind StorageV2 `
    --min-tls-version TLS1_2 `
    --allow-blob-public-access false `
    --tags Environment=Infra Project=SchoolManagement ManagedBy=Terraform `
    --output none

Write-Host "  -> Storage Account '$StorageAccountName' created successfully!" -ForegroundColor Green

# Enable Blob Versioning (State corruption protection)
Write-Host "  -> Enabling Blob Versioning for State Safety..." -ForegroundColor Yellow
az storage account blob-service-properties update `
    --account-name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --enable-versioning true `
    --output none

# 4. Create Blob Container for tfstate
Write-Host "`n[4/5] Creating Blob Container '$ContainerName'..." -ForegroundColor Green
az storage container create `
    --name $ContainerName `
    --account-name $StorageAccountName `
    --auth-mode login `
    --output none

Write-Host "  -> Blob Container '$ContainerName' ready!" -ForegroundColor Green

# 5. Output Terraform Backend Configuration
Write-Host "`n[5/5] Backend Setup Complete! Use the following configuration:`n" -ForegroundColor Cyan
$backendConfig = @"
  backend "azurerm" {
    resource_group_name  = "$ResourceGroupName"
    storage_account_name = "$StorageAccountName"
    container_name       = "$ContainerName"
    key                  = "school-system.tfstate"
  }
"@

Write-Host $backendConfig -ForegroundColor White

# Save this backend config to backend.hcl for easy init
$backendHcl = @"
resource_group_name  = "$ResourceGroupName"
storage_account_name = "$StorageAccountName"
container_name       = "$ContainerName"
key                  = "school-system.tfstate"
"@
$backendHclPath = Join-Path -Path $PSScriptRoot -ChildPath "backend.hcl"
Set-Content -Path $backendHclPath -Value $backendHcl -Encoding utf8
Write-Host "`n  -> Config also saved to: $backendHclPath" -ForegroundColor Magenta
Write-Host "  -> Initialize terraform anytime using: terraform init -backend-config=backend.hcl`n" -ForegroundColor Yellow
