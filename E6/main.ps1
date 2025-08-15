#!/usr/bin/env pwsh
Import-Module 'BasicAudit'

Write-Host "=== Basic users and services audit ==="
Write-Host "1. Show inactive users"
Write-Host "2. Show external active services"
$option = Read-Host "Select an option (1 or 2)"

switch ($option) {
    "1" {
        $users = Get-InactiveUsers
        $users | Format-Table Name, Enabled, LastLogon -AutoSize
        $users | Export-Csv -Path "$env:USERPROFILE\Desktop\users_inac.csv" -NoTypeInformation
        Write-Host "`n Reporte generado: users_inac.csv"
      }
    "2" {
        $services = Get-ExternalServices
        $services | Format-Table DisplayName, Status, StartType -AutoSize
        $services | ConvertTo-Html | Out-File "$env:USERPROFILE\Desktop\serv_e.html"
        Write-Host "`n Reporte generado: serv_e.html"
      }
    default {
        Write-Host "Invalid Option"
      }
  }
