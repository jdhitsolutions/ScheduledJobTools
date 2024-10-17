# Module manifest for module 'ScheduledJobTools'

@{
    RootModule            = 'ScheduledJobTools.psm1'
    ModuleVersion         = '2.3.0'
    CompatiblePSEditions  = @("Desktop")
    GUID                  = '35b74812-dfdb-405f-a3bd-5178dcd9827e'
    Author                = 'Jeff Hicks'
    CompanyName           = 'JDH Information Technology Solutions, Inc.'
    Copyright             = '(c)2013-2024 JDH Information Technology Solutions, Inc. All Rights Reserved'
    Description           = 'A PowerShell module for managing PowerShell scheduled jobs and their results.'
    PowerShellVersion     = '5.1'
    PowerShellHostVersion = '5.1'
    TypesToProcess        = @(".\types\ScheduledJobDefinition.types.ps1xml")
    FormatsToProcess      = @("formats\ScheduledJobResult.format.ps1xml", ".\formats\ScheduledJob.format.ps1xml")
    FunctionsToExport     = "Export-ScheduledJob", "Import-ScheduledJob", "Get-ScheduledJobResult", "Remove-OldJobResult",
    "Get-ScheduledJobDetail"
    AliasesToExport       = "esj", "isj", "ljr"
    PrivateData           = @{
        PSData = @{
            ExternalModuleDependencies = @('PSScheduledJob', 'ScheduledTasks')
            Tags                       = @('ScheduledJob')
            LicenseUri                 = 'https://github.com/jdhitsolutions/ScheduledJobtools/blob/v1.3/License.txt'
            ProjectUri                 = 'https://github.com/jdhitsolutions/ScheduledJobtools'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = @"
## ScheduledJobTools 2.3.0

### Added

- Added property set `RunInfo` for the scheduled job definition type.
- Added script property `LastRun` to the scheduled job definition type.

### Changed

- Moved script property definitions to the types ps1xml file.
- Code cleanup.
- Converted Changelog to new format.
- Reorganized module layout.
- Updated online help links.
- Minor help updates.
"@

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}
