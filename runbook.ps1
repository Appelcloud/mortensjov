Connect-MgGraph -ClientId "29a4e233-2840-478c-af7f-3bfc5da6f918" -TenantId "[Get-AutomationVariable -Name 'TenantID']"
$AppSecret = Get-AutomationVariable -Name '[concat(parameters('runbookName'), '_AppSecret')]'
$ApplicationClientId = '29a4e233-2840-478c-af7f-3bfc5da6f918'
$ApplicationClientSecret = $AppSecret
$TenantId = '[Get-AutomationVariable -Name 'TenantID']'
$SecureClientSecret = ConvertTo-SecureString -String $ApplicationClientSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationClientId, $SecureClientSecret

Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential

# Define mail recipient
$MailRecipient = "[Get-AutomationVariable -Name '[concat(parameters('runbookName'), '_MailRecipient')]']"

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
Invoke-Maester -MailUserId $MailRecipient -MailRecipient "aa@komplexit.dk" -OutputFolder $TempOutputFolder