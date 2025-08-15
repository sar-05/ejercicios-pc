#!/usr/bin/env pwsh
function Test-Item
{
  param ([string]$Path)
  try
  {
    if (Test-Path $Path)
    {
      Get-Content $Path > $null -ErrorAction Stop
      return "Archivo encontrado y accesible: $Path"
    } else
    {
      throw "El archivo $Path no existe."
    }
  } catch
  {
    return "Error: $_"
  } finally
  {
    Write-Host "Validación finalizada para: $Path" -ForegroundColor Cyan }
}

Test-Item -Path "C:\archivo-inexistente.txt"
Test-Item -Path "$env:USERPROFILE\Desktop\main.ps1"
