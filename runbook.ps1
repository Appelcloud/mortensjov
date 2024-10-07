# Retrieve automation account variables
$AppSecret = Get-AutomationVariable -Name 'AppSecret'
$ApplicationClientId = Get-AutomationVariable -Name 'ApplicationClientID'
$TenantId = Get-AutomationVariable -Name 'TenantID'
$MailUserId = Get-AutomationVariable -Name 'MailUserId'

# Convert client secret to secure string and create PSCredential object
$SecureClientSecret = ConvertTo-SecureString -String $AppSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationClientId, $SecureClientSecret

# Connect to Microsoft Graph
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential

# Define mail recipient
$MailRecipient = "aa@komplexit.dk"

# Create output folder
$date = (Get-Date).ToString("yyyyMMdd-HHmm")
$FileName = "MaesterReport" + $Date + ".zip"

$TempOutputFolder = $env:TEMP + $date
if (!(Test-Path $TempOutputFolder -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $TempOutputFolder
}

# Run Maester report
cd $env:TEMP
md maester-tests
cd maester-tests
Install-MaesterTests .\tests
Invoke-Maester -MailUserId $MailUserId -MailRecipient $MailRecipient -OutputFolder $TempOutputFolder
