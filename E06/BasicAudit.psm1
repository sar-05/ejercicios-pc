#!/usr/bin/env pwsh

function Get-InactiveUsers {
    <#
    .SYNOPSIS
    Gets enabled local uses that have never logged in
    .DESCRIPTION
    Searches for local enabled user accounts with no last log in date
    .EXAMPLE
    Get-InactiveUsers
    .NOTES
    Can help finding unnecessary or risky account in basic audits
    #>
    Get-LocalUser | Where-Object { $_.Enabled -eq $true -and -not $_.LastLogon }
}

function Get-ExternalServices {
    <#
    .SYNOPSIS
    Gets non-Windows executing services
    .DESCRIPTION
    Filters services which descriptive name isn't explicitly "Windows"
    .EXAMPLE
    Get-ExternalServices
    .NOTES
    Useful to detect 3rd party software running in the background
    #>
    Get-LocalUser | Where-Object { $_.Enabled -eq $true -and -not $_.LastLogon }
}

