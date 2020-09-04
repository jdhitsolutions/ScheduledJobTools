# Module manifest for module 'ScheduledJobTools'

@{

    # Script module or binary module file associated with this manifest
    RootModule             = 'ScheduledJobTools.psm1'

    # Version number of this module.
    ModuleVersion          = '2.2.0'

    # Supported PSEditions
    CompatiblePSEditions = @("Desktop")

    # ID used to uniquely identify this module
    GUID                   = '35b74812-dfdb-405f-a3bd-5178dcd9827e'

    # Author of this module
    Author                 = 'Jeff Hicks'

    # Company or vendor of this module
    CompanyName            = 'JDH Information Technology Solutions, Inc.'

    # Copyright statement for this module
    Copyright              = '(c)2013-2020 JDH Information Technology Solutions, Inc. All Rights Reserved'

    # Description of the functionality provided by this module
    Description            = 'A PowerShell module for managing scheduled jobs and their results.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion      = '5.1'

    # Name of the Windows PowerShell host required by this module
    PowerShellHostName     = ''

    # Minimum version of the Windows PowerShell host required by this module
    PowerShellHostVersion  = '5.0'

    # Minimum version of the .NET Framework required by this module
    DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion             = ''

    # Processor architecture (None, X86, Amd64, IA64) required by this module
    ProcessorArchitecture  = 'None'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules        = @("PSScheduledJob")

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies     = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module
    ScriptsToProcess       = @()

    # Type files (.ps1xml) to be loaded when importing this module
    TypesToProcess         = @()

    # Format files (.ps1xml) to be loaded when importing this module
    FormatsToProcess       = @("formats\ScheduledjobResult.format.ps1xml",".\formats\scheduledjob.format.ps1xml")

    # Modules to import as nested modules of the module specified in ModuleToProcess
    NestedModules          = @()

    # Functions to export from this module
    FunctionsToExport      = "Export-ScheduledJob", "Import-ScheduledJob", "Get-ScheduledJobResult", "Remove-OldJobResult",
    "Get-ScheduledJobDetail"

    # Cmdlets to export from this module
    CmdletsToExport        = @()

    # Variables to export from this module
    VariablesToExport      = @()

    # Aliases to export from this module
    AliasesToExport        = "esj", "isj", "ljr"

    # List of all modules packaged with this module
    ModuleList             = @()

    # List of all files packaged with this module
    FileList               = @()

    # Private data to pass to the module specified in ModuleToProcess
    PrivateData            = @{

        PSData = @{

            ExternalModuleDependencies = @('PSScheduledJob', 'ScheduledTasks')

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags                       = @('scheduledjob')

            # A URL to the license for this module.
            LicenseUri                 = 'https://github.com/jdhitsolutions/scheduledjobtools/blob/v1.3/License.txt'

            # A URL to the main website for this project.
            ProjectUri                 = 'https://github.com/jdhitsolutions/scheduledjobtools'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}



