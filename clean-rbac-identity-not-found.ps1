[CmdletBinding()]
param (
    [switch] $CheckOnly,
    [Parameter(Mandatory = $false)]
    [string] $Scope = ""
)

[array]$Assignments = @()

if ("" -eq $Scope) {
    Write-Output "No Scope defined, getting all assignments."
    $Assignments = Get-AzRoleAssignment | Where-Object { $_.ObjectType -eq "Unknown" }
} else {
    Write-Output "Scope is: $Scope"
    $Assignments = Get-AzRoleAssignment -Scope $Scope | Where-Object { $_.ObjectType -eq "Unknown" }
}

Write-Output "Total: $($Assignments.Count) Unknown Identity found"

Foreach ($Assignment in $Assignments) {

    Write-Output "---------------------------"
    Write-Output "Scope: $($Assignment.Scope)"
    Write-Output "Object Type: $($Assignment.ObjectType)"
    Write-Output "Display Name: $($Assignment.DisplayName)"
    Write-Output "SignIn Name: $($Assignment.SignInName)"
    Write-Output "Role Definition Name: $($Assignment.RoleDefinitionName)"
    Write-Output "Role Definition Id: $($Assignment.RoleDefinitionId)"
    Write-Output "Role Assignment Id: $($assignment.RoleAssignmentId)"
    Write-Output "---------------------------"
    Write-Output ""

    if (-not $CheckOnly) {
        Write-Output "Removing assignment: $($Assignment.RoleAssignmentId)"
        $Assignment | Remove-AzRoleAssignment -Verbose
    }

}
