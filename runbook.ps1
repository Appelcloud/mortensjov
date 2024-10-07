# Retrieve existing Automation Account variables
$AppSecret = Get-AutomationVariable -Name 'AppSecret'
$ApplicationClientId = Get-AutomationVariable -Name 'ApplicationClientID'
$TenantId = Get-AutomationVariable -Name 'TenantID'

# Convert secret to a secure string and create the PSCredential
$SecureClientSecret = ConvertTo-SecureString -String $AppSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationClientId, $SecureClientSecret

# Connect to Microsoft Graph using Client Secret Credential
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential

# Define mail recipient
$MailRecipient = "aa@komplexit.dk"

# Create output folder for the report
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport" + $date + ".zip"

$TempOutputFolder = $env:TEMP + $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder
}

# Run Maester report
cd $env:TEMP
md maester-tests
cd maester-tests
Install-MaesterTests .\tests
Invoke-Maester -MailUserId "aa@3g35sp.onmicrosoft.com" -MailRecipient $MailRecipient -OutputFolder $TempOutputFolder
