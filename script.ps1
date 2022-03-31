[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]
    $AutomationAccountName,

    [Parameter(Mandatory = $true)]
    [String]
    $ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [String]
    $RunbookName
)

# if (-not (Get-Module -Name Az.Accounts -ListAvailable -ErrorAction SilentlyContinue | Where-Object { $_.Version -eq "2.2.4" })) {
#     Install-Module -Name Az.Accounts -RequiredVersion 2.2.4 -Scope CurrentUser -Force
# }

# if (-not (Get-Module -Name Az.Automation -ListAvailable -ErrorAction SilentlyContinue | Where-Object { $_.Version -eq "1.4.2" })) {
#     Install-Module -Name Az.Automation -RequiredVersion 1.4.2 -Scope CurrentUser -Force
# }

# Import-Module -Name Az.Accounts -RequiredVersion 2.2.4
# Import-Module -Name Az.Automation -RequiredVersion 1.4.2

$context = (Get-AzContext).Name
Write-Output "Context: $context"

$jobSchedules = Get-AzAutomationScheduledRunbook -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -ErrorAction SilentlyContinue
$jobSchedule = $jobSchedules | Where-Object -Property "RunbookName" -eq $RunbookName

if ($null -ne $jobSchedule) {
    Write-Host "Unregister job schedule $($jobSchedule.JobScheduleId) from runbook $($jobSchedule.RunbookName)."
    Unregister-AzAutomationScheduledRunbook -JobScheduleId $jobSchedule.jobScheduleId -ResourceGroupName $ResourceGroupName -AutomationAccountName $AutomationAccountName -Force
}
else {
    Write-Host "No job schedule found for runbook $RunbookName to unregister."
}
