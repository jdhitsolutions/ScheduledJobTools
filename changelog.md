# Change Log for ScheduledJobTools

## v2.1.0

+ Added `PSScheduledJob` as a required module to the manifest
+ Added `ScheduledJobResult.format.ps1xml` to format output from `Get-ScheduledJobResult` as a table
+ Revised `Get-ScheduledJobDetail` to have a default parameter set.
+ Updated license copyright year

## v2.0.0

+ Changed minimum version to 5.1 and supporting Desktop edition only
+ file cleanup for the PowerShell Gallery
+ Moved alias definitions to respective functions
+ Updated help

## v1.4.0

+ Added `Get-ScheduledJobDetail`

## v1.3.1

+ manifest changes
+ published to PowerShell Gallery

## v1.3

+ Added `Remove-OldJobResult`
+ Updated `README.md`

## v1.2

+ moved to external help
+ code cleanup
+ Added `Get-ScheduledJobResult` command and associated class
+ Added auto completer for Name parameter in `Export-ScheduledJob` and `Get-ScheduledJobResult`
+ increased required PowerShell version to 5.0

## v1.1

+ initial release
