#Requires -version 3.0
#Requires -module PSScheduledJob


Function Export-ScheduledJob {

<#
.SYNOPSIS
Export a Scheduled Job
.DESCRIPTION
This command will export a PowerShell scheduled job to an XML file using 
the Export-CliXML cmdlet. This file can be used to import the scheduled 
task on another computer running PowerShell 3.0.
.PARAMETER Job
The name of the scheduled job or the job object.
.PARAMETER Path
The path to store the xml file. The file name will be the same as the 
job name. The default is the current location.
.PARAMETER Passthru
Write the XML file object to the pipeline.
.EXAMPLE
PS C:\> Export-ScheduledJob MyJob -path \\chi-fp01\it\jobs
Export a single job to \\chi-fp01\it\jobs. The filename will be MyJob.xml.
.EXAMPLE
PS C:\> Get-ScheduledJob | Export-ScheduledJob -path d:\backup
Export all scheduled jobs to a backup folder.
.LINK
Export-Clixml
Get-ScheduledJob
Import-ScheduledJob
.NOTES
Version 1.1

Learn more:
 PowerShell in Depth: An Administrator's Guide (http://www.manning.com/jones2/)
 PowerShell Deep Dives (http://manning.com/hicks/)
 Learn PowerShell 3 in a Month of Lunches (http://manning.com/jones3/)
 Learn PowerShell Toolmaking in a Month of Lunches (http://manning.com/jones4/)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
#>

[cmdletbinding(SupportsShouldProcess)]

Param(
[Parameter(Position=0,Mandatory,ValueFromPipeline)]
[alias("name")]
[ValidateNotNullorEmpty()]
[object]$Job,
[ValidateScript({
 if (-Not (Test-Path -path $_)) {
    Throw "Could not verify the path."
 }
 else {
    $True
 }
})]
[ValidateScript({Test-Path $_})]
[string]$Path=(Get-Location).Path,
[switch]$Passthru
)

Process {

    #if job is a string, get the corresponding job object
    if ($job -is [string]) {
        Write-verbose "Getting scheduled job $job"
        Try {
            $ExportJob = Get-ScheduledJob -Name $job -ErrorAction Stop
        }
        Catch {
            Write-Warning "Failed to get scheduled job $job"
            Return
        }
    } #if
    elseif ($job -is [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]) {
        Write-Verbose "Input object is already a job"
        $ExportJob = $job
    }
    else {
        Write-Warning "The object you specified is something other than a string or a scheduled job object."
        Return
    }

    $ExportPath = Join-path -Path $path -ChildPath "$($ExportJob.Name).xml"
    Write-Verbose "Starting the export process of $($ExportJob.Name) to $ExportPath"

    $ExportJob | Select Name,
    @{Name="Scriptblock";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0) | 
    where {$_.name -eq "ScriptBlock"}).value
    }},
    @{Name="FilePath";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0)| 
    where {$_.name -eq "FilePath"}).value
    }},
    @{Name="ArgumentList";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0) | 
    where {$_.name -eq "ArgumentList"}).value 
    }},
    @{Name="Authentication";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0) | 
    where {$_.name -eq "Authentication"}).value
    }},
    @{Name="InitializationScript";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0) | 
    where {$_.name -eq "InitializationScript"}).value
    }},
    @{Name="RunAs32";
    Expression={
    ($_.InvocationInfo.Parameters.Item(0) | 
    where {$_.name -eq "RunAs32"}).value
    }},
    @{Name="Credential";
    Expression={
    $_.Credential.UserName
    }},
    @{Name="Options";
    Expression={
    #don't export the job definition here
    $_.Options | Select * -ExcludeProperty JobDefinition
    }},
    @{Name="JobTriggers";
    Expression={
    #don't export the job definition here
    $_.JobTriggers | Select * -ExcludeProperty JobDefinition
    }},ExecutionHistoryLength,Enabled | 
    Export-Clixml -Path $ExportPath 

    if ($Passthru) {
        Write-Verbose "Writing the export file item to the pipeline"
        Get-Item -Path $ExportPath
    }

    Write-Verbose "Export finished."
} #process

} #end Export-ScheduledJob


Function Import-ScheduledJob{

<#
.SYNOPSIS
Import a PowerShell scheduled job from an XML file.
.DESCRIPTION
This command will take an exported PowerShell scheduled job stored in an
XML file and import it, re-creating the scheduled job. If the job uses 
credentials you will be prompted for the credential password.
.PARAMETER Path
The path and file name with the exported job definition.
.PARAMETER Passthru
Write the new job to the pipeline.
.EXAMPLE
PS C:\> Import-ScheduledJob \\chi-fp01\it\jobs\myjob.xml
.LINK
Register-ScheduledJob
Export-ScheduledJob
Import-CliXML
.NOTES
Version 1.1

Learn more:
 PowerShell in Depth: An Administrator's Guide (http://www.manning.com/jones2/)
 PowerShell Deep Dives (http://manning.com/hicks/)
 Learn PowerShell 3 in a Month of Lunches (http://manning.com/jones3/)
 Learn PowerShell Toolmaking in a Month of Lunches (http://manning.com/jones4/)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************
#>

[cmdletbinding(SupportsShouldProcess)]

Param(
[Parameter(Position=0,Mandatory,ValueFromPipeline)]
[alias("name")]
[ValidateScript({
 if (-Not (Test-Path -path $_)) {
    Throw "Could not verify the path."
 }
 else {
    $True
 }
})]
[object]$Path,
[switch]$Passthru
)


Process {

    #test if $path is a string or a file object
    if ($Path -is [string]) {
        Write-Verbose "Getting $path"
        Try {
            $ImportFile = Get-Item -Path $path -ErrorAction Stop
        }
        Catch {
            Write-Warning "Failed to get $Path. $($_.Exception.Message)"
            Return
        }
    }
    elseif ($Path -is [System.IO.FileInfo]) {
        Write-Verbose "Input object is already a file object"
        $ImportFile = $Path
    }
    else {
        Write-Warning "You entered an invalid object type for -Path"
        #bail out
        Return
    }
    
    #define a hashtable of values for Register-ScheduledJob
    $paramHash=@{
     ErrorAction="Stop"
    }

    $Imported = Import-Clixml -path $ImportFile

    #$cmd = "Register-ScheduledJob -name ""$($Imported.Name)"""
    $paramHash.Add("Name",$Imported.Name)

    if ($Imported.scriptblock) {
        Write-Verbose "Found a scriptblock"
        #$cmd+= " -ScriptBlock {$($Imported.Scriptblock)}"
        $paramHash.Add("ScriptBlock",[scriptblock]::Create($Imported.Scriptblock))

    }
    elseif ($Imported.FilePath) {
        Write-Verbose "Found a filepath"
        #$cmd+= " -FilePath $($Imported.FilePath)"
        $paramHash.Add("FilePath",$Imported.Filepath)
    }
    else {
        #this should never really happen
        Write-Warning "Failed to find a scriptblock or file path"
        #bail out
        Return
    }

    Write-Verbose "Processing additional job elements"
    if ($Imported.ArgumentList) {
        Write-Verbose "..ArgumentList"
        #$cmd+= " -ArgumentList $($Imported.ArgumentList)"
        $paramHash.Add("ArgumentList",$ImportFile.ArgumentList)
    }

    if ($Imported.Authentication) {
        Write-Verbose "..Authentication"
        #$cmd+= " -Authentication $($Imported.Authentication)"
        $paramhash.Add("Authentication",$Imported.Authentication)
    }

    if ($Imported.Credential) {
        Write-Verbose "..Credential"
        #$cmd+= " -credential $($Imported.Credential)"
        $paramHash.Add("credential",$Imported.Credential)
    }

    if ($Imported.InitializationScript) {
        Write-Verbose "..InitializationScript"
        #$cmd+= " -InitializationScript {$($Imported.InitializationScript)}"
        $paramHash.Add("InitializationScript",[scriptblock]::Create($Imported.InitializationScript))

    }

    if ($Imported.ExecutionHistoryLength) {
        Write-Verbose "..ExecutionHistoryLength"
        #$cmd+= " -MaxResultCount $($Imported.ExecutionHistoryLength)"
        $paramHash.Add("MaxResultCount",$Imported.ExecutionHistoryLength)
    }

    if ($Imported.RunAs32) {
        Write-Verbose "..RunAs32"
        #$cmd+= " -RunAs32"
        $paramHash.Add("RunAs32",$True)
    }

    if ($Imported.Options) {
        Write-Verbose "Processing Options"

        $optionHash=@{
        RunElevated = $Imported.Options.RunElevated 
        HideInTaskScheduler = -Not ($Imported.Options.ShowInTaskScheduler)
        RestartOnIdleResume = $Imported.Options.RestartOnIdleResume
        MultipleInstancePolicy = $Imported.Options.MultipleInstancePolicy
        DoNotAllowDemandStart = $Imported.Options.DoNotAllowDemandStart
        RequireNetwork = -Not ($Imported.Options.RunWithoutNetwork)
        StopIfGoingOffIdle = $Imported.Options.StopIfGoingOffIdle
        WakeToRun = $Imported.Options.WakeToRun
        ContinueIfGoingOnBattery = -Not ($Imported.Options.StopIfGoingOnBatteries)
        StartIfOnBattery = $Imported.Options.StartIfOnBatteries
        IdleTimeout = $Imported.Options.IdleTimeout
        IdleDuration = $Imported.Options.IdleDuration
        StartIfIdle = -Not ($Imported.Options.StartIfNotIdle)
        }
        
        $jobOption = New-ScheduledJobOption @optionHash
        #$cmd+= " -ScheduledJobOption `$jobOption"
        $paramhash.Add("ScheduledJobOption",$jobOption)
    }

    if ($Imported.JobTriggers) {
        Write-Verbose "Processing Job Triggers"

        #define an array to hold triggers
        $Triggers=@()

        #enumerate each job trigger
        foreach ($trigger in $Imported.JobTriggers) {
            #test for parameter set
            Switch ($trigger.Frequency.Value) {
             "Once" { 
                $TriggerCmd = "New-JobTrigger -Once -At ""$($trigger.At)"""
                if ($trigger.RepetitionDuration) {
                    $TriggerCmd+= " -RepetitionDuration $($trigger.RepetitionDuration)"
                 }
                if ($trigger.RepetitionInterval) {
                    $TriggerCmd+= "-RepetitionInterval $($trigger.RepetitionInterval)"
                }
                } #once
             "Weekly" {
                $TriggerCmd = "New-JobTrigger -Weekly -DaysOfWeek $($trigger.DaysOfWeek) -WeeksInterval $($trigger.Interval) -At ""$($trigger.At)"""
              } #weekly
             "Daily" {
                $TriggerCmd = "New-JobTrigger -Daily -DaysInterval $($trigger.Interval) -At ""$($trigger.At)"""
             } #Daily
             "AtLogon" {
                $TriggerCmd = "New-JobTrigger -AtLogOn -User $($trigger.user)"
             } #AtLogon
             "AtStartup" {
                $TriggerCmd = "New-JobTrigger -AtStartup"
             } #AtStartup
             Default {
                #no frequency
                Write-Warning "No trigger found"
             } #Default
            } #end switch

            #define a new trigger and add to the array
            $TriggerCmd += " -randomdelay $($trigger.RandomDelay)"
            Write-Verbose $triggerCmd
            $Triggers+= Invoke-Expression -Command $TriggerCmd
        } #foreach trigger
  
            #$cmd+= " -Trigger `$Triggers"
            $paramHash.Add("Trigger",$Triggers)
    }

    Write-Verbose "Creating the scheduled job"
    Write-Verbose ($paramhash | Out-String)
    #create the scheduled job
    if ($PSCmdlet.ShouldProcess($imported.Name)) {
        $newJob = Register-ScheduledJob @paramhash
        #Invoke-Expression -Command $cmd
        #if the job is disabled, then 
        if (-Not ($Imported.Enabled)) {
            Write-Verbose "Disabling the job"
            $newJob | Disable-ScheduledJob
        }
        if ($Passthru) {
            Get-ScheduledJob $imported.Name
        }
    } #should process
} #process

} #end Import-ScheduledJob

Set-Alias -Name isj -Value Import-ScheduledJob
Set-Alias -Name esj -Value Export-ScheduledJob

Export-ModuleMember -Function * -Alias *