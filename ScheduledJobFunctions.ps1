Function Get-ScheduledJobDetail {
    [CmdletBinding()]
    [OutputType("PSCustomObject")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "name")]
        [ValidateNotNullorEmpty()]
        [string[]]$Name,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "job")]
        [ValidateNotNullorEmpty()]
        [alias("job")]
        [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$ScheduledJob
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)   BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    
    Process {
        $jobs = @()
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            foreach ($item in $name) {
                Try {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting scheduledjob $item"
                    $jobs += Get-Scheduledjob -Name $item -ErrorAction Stop
                }
                Catch {
                    Write-Warning $_.exception.message
                }
            }
        } #if Name
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using scheduledjob $($scheduledjob.name)"
            $jobs += $ScheduledJob
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting scheduledjob details"
        foreach ($job in $jobs) {
            #get corresponding task
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] $($job.name)"
            $task = Get-ScheduledTask -TaskName $job.name
            $info = $task | Get-ScheduledTaskInfo
            [pscustomobject]@{
                ID                     = $job.ID
                Name                   = $job.name
                Command                = $job.command
                Enabled                = $job.enabled
                State                  = $task.State
                NextRun                = $info.nextRunTime
                MaxHistory             = $job.ExecutionHistoryLength
                RunAs                  = $task.Principal.UserID
                Frequency              = $job.JobTriggers.Frequency
                Days                   = $job.JobTriggers.DaysOfWeek
                RepetitionDuration     = $job.JobTriggers.RepetitionDuration
                RepetitionInterval     = $job.JobTriggers.RepetitionInterval
                DoNotAllowDemandStart  = $job.options.DoNotAllowDemandStart
                IdleDuration           = $job.options.IdleDuration
                IdleTimeout            = $job.options.IdleTimeout
                MultipleInstancePolicy = $job.options.MultipleInstancePolicy
                RestartOnIdleResume    = $job.options.RestartOnIdleResume
                RunElevated            = $job.options.RunElevated
                RunWithoutNetwork      = $job.options.RunWithoutNetwork
                ShowInTaskScheduler    = $job.options.ShowInTaskScheduler
                StartIfNotIdle         = $job.options.StartIfNotIdle
                StartIfOnBatteries     = $job.options.StartIfOnBatteries
                StopIfGoingOffIdle     = $job.options.StopIfGoingOffIdle
                StopIfGoingOnBatteries = $job.options.StopIfGoingOnBatteries
                WakeToRun              = $job.options.WakeToRun
            }
            
        } #foreach job
        
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay)     END] Ending $($myinvocation.MyCommand)"
    } #end
}

Function Remove-OldJobResult {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "name")]
    [OutputType("None")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "name")]
        [ValidateNotNullorEmpty()]
        [string[]]$Name,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "job")]
        [ValidateNotNullorEmpty()]
        [alias("job")]
        [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$ScheduledJob
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)   BEGIN] Starting $($myinvocation.mycommand)"
    } #begin

    Process {
        #get all but newest job result for cleanup
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            $items = $Name
        }
        else {
            $items = $ScheduledJob.Name
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Removing old job results for $($items -join ',')"
        Get-Job -name $items | Sort-Object PSEndTime -descending | Select-Object -skip 1  |
            Remove-Job
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay)     END] Ending $($myinvocation.MyCommand)"
    } #end
}


Function Export-ScheduledJob {

    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "name")]
    [OutputType("None","System.IO.FileInfo")]
    [Alias("esj")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "name")]
        [ValidateNotNullorEmpty()]
        [string]$Name,

        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ParameterSetName = "job")]
        [ValidateNotNullorEmpty()]
        [alias("job")]
        [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$ScheduledJob,

        [ValidateScript( {
                if (-Not (Test-Path -path $_)) {
                    Throw "Could not verify the path."
                }
                else {
                    $True
                }
            })]
        [ValidateScript( {Test-Path $_})]
        [string]$Path = (Get-Location).Path,
        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)   BEGIN] Starting $($myinvocation.mycommand)"
    } #begin

    Process {

        if ($Name) {
            Write-verbose "[$((Get-Date).TimeofDay) PROCESS] Getting scheduled job $job"
            Try {
                $ExportJob = Get-ScheduledJob -Name $name -ErrorAction Stop
            }
            Catch {
                Write-Warning "Failed to get scheduled job $name"
                #bail out
                Return
            }
        } #if
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using scheduled job $($scheduledjob.name)"
            $ExportJob = $scheduledjob
        }

        $ExportPath = Join-path -Path $path -ChildPath "$($ExportJob.Name).xml"
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Starting the export process of $($ExportJob.Name) to $ExportPath"

        $ExportJob | Select-Object -property Name,
        @{Name         = "Scriptblock";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0) | 
                        Where-Object {$_.name -eq "ScriptBlock"}).value
            }
        },
        @{Name         = "FilePath";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0)| 
                        Where-Object {$_.name -eq "FilePath"}).value
            }
        },
        @{Name         = "ArgumentList";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0) | 
                        Where-Object {$_.name -eq "ArgumentList"}).value 
            }
        },
        @{Name         = "Authentication";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0) | 
                        Where-Object {$_.name -eq "Authentication"}).value
            }
        },
        @{Name         = "InitializationScript";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0) | 
                        Where-Object {$_.name -eq "InitializationScript"}).value
            }
        },
        @{Name         = "RunAs32";
            Expression = {
                ($_.InvocationInfo.Parameters.Item(0) | 
                        Where-Object {$_.name -eq "RunAs32"}).value
            }
        },
        @{Name         = "Credential";
            Expression = {
                $_.Credential.UserName
            }
        },
        @{Name         = "Options";
            Expression = {
                #don't export the job definition here
                $_.Options | Select-Object -property * -ExcludeProperty JobDefinition
            }
        },
        @{Name         = "JobTriggers";
            Expression = {
                #don't export the job definition here
                $_.JobTriggers | Select-Object -property * -ExcludeProperty JobDefinition
            }
        }, ExecutionHistoryLength, Enabled | 
            Export-Clixml -Path $ExportPath 

        if ($Passthru) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Writing the export file item to the pipeline"
            Get-Item -Path $ExportPath
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Export finished."
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay)     END] Ending $($myinvocation.MyCommand)"
    } #end
} #end Export-ScheduledJob


Function Import-ScheduledJob {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None","Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition")]
    [Alias("isj")]

    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [alias("name", "pspath")]
        [ValidateScript( {
                if (-Not (Test-Path -path $_)) {
                    Throw "Could not verify the path."
                }
                else {
                    $True
                }
            })]
        [string]$Path,
        [switch]$Passthru
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)   BEGIN] Starting $($myinvocation.mycommand)"
    } #begin

    Process {

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] processing $path"
   
        #define a hashtable of values for Register-ScheduledJob
        $paramHash = @{
            ErrorAction = "Stop"
        }

        $Imported = Import-Clixml -path $Path

        #$cmd = "Register-ScheduledJob -name ""$($Imported.Name)"""
        $paramHash.Add("Name", $Imported.Name)

        if ($Imported.scriptblock) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found a scriptblock"

            $paramHash.Add("ScriptBlock", [scriptblock]::Create($Imported.Scriptblock))

        }
        elseif ($Imported.FilePath) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found a filepath"
            #$cmd+= " -FilePath $($Imported.FilePath)"
            $paramHash.Add("FilePath", $Imported.Filepath)
        }
        else {
            #this should never really happen
            Write-Warning "Failed to find a scriptblock or file path"
            #bail out
            Return
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing additional job elements"
        if ($Imported.ArgumentList) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..ArgumentList"

            $paramHash.Add("ArgumentList", $ImportFile.ArgumentList)
        }

        if ($Imported.Authentication) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..Authentication"

            $paramhash.Add("Authentication", $Imported.Authentication)
        }

        if ($Imported.Credential) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..Credential"

            $paramHash.Add("credential", $Imported.Credential)
        }

        if ($Imported.InitializationScript) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..InitializationScript"

            $paramHash.Add("InitializationScript", [scriptblock]::Create($Imported.InitializationScript))

        }

        if ($Imported.ExecutionHistoryLength) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..ExecutionHistoryLength"

            $paramHash.Add("MaxResultCount", $Imported.ExecutionHistoryLength)
        }

        if ($Imported.RunAs32) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ..RunAs32"

            $paramHash.Add("RunAs32", $True)
        }

        if ($Imported.Options) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing Options"

            $optionHash = @{
                RunElevated              = $Imported.Options.RunElevated 
                HideInTaskScheduler      = -Not ($Imported.Options.ShowInTaskScheduler)
                RestartOnIdleResume      = $Imported.Options.RestartOnIdleResume
                MultipleInstancePolicy   = $Imported.Options.MultipleInstancePolicy
                DoNotAllowDemandStart    = $Imported.Options.DoNotAllowDemandStart
                RequireNetwork           = -Not ($Imported.Options.RunWithoutNetwork)
                StopIfGoingOffIdle       = $Imported.Options.StopIfGoingOffIdle
                WakeToRun                = $Imported.Options.WakeToRun
                ContinueIfGoingOnBattery = -Not ($Imported.Options.StopIfGoingOnBatteries)
                StartIfOnBattery         = $Imported.Options.StartIfOnBatteries
                IdleTimeout              = $Imported.Options.IdleTimeout
                IdleDuration             = $Imported.Options.IdleDuration
                StartIfIdle              = -Not ($Imported.Options.StartIfNotIdle)
            }
        
            $jobOption = New-ScheduledJobOption @optionHash

            $paramhash.Add("ScheduledJobOption", $jobOption)
        }

        if ($Imported.JobTriggers) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing Job Triggers"

            #define an array to hold triggers
            $Triggers = @()

            #enumerate each job trigger
            foreach ($trigger in $Imported.JobTriggers) {
                #test for parameter set
                Switch ($trigger.Frequency.Value) {
                    "Once" { 
                        $TriggerCmd = "New-JobTrigger -Once -At ""$($trigger.At)"""
                        if ($trigger.RepetitionDuration) {
                            $TriggerCmd += " -RepetitionDuration $($trigger.RepetitionDuration)"
                        }
                        if ($trigger.RepetitionInterval) {
                            $TriggerCmd += "-RepetitionInterval $($trigger.RepetitionInterval)"
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
                $Triggers += Invoke-Expression -Command $TriggerCmd
            } #foreach trigger
  

            $paramHash.Add("Trigger", $Triggers)
        }

        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating the scheduled job"
        Write-Verbose ($paramhash | Out-String)
        #create the scheduled job
        if ($PSCmdlet.ShouldProcess($imported.Name)) {
            $newJob = Register-ScheduledJob @paramhash
            
            #if the job is disabled, then 
            if (-Not ($Imported.Enabled)) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Disabling the job"
                $newJob | Disable-ScheduledJob
            }
            if ($Passthru) {
                Get-ScheduledJob $imported.Name
            }
        } #should process
    } #process
    
    End {
        Write-Verbose "[$((Get-Date).TimeofDay)     END] Ending $($myinvocation.MyCommand)"
    } #end
} #close Import-ScheduledJob


Function Get-ScheduledJobResult {
    
    [cmdletbinding()]
    [OutputType("ScheduledJobResult")]
    [Alias("ljr")]

    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$Name = "*",
        [validatescript( {$_ -gt 0})]
        [int]$Newest = 1,
        [switch]$All
    )
    
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay)   BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    
    Process {
        #only show results for Enabled jobs
        Try {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting scheduled jobs for $name"
            $jobs = Get-ScheduledJob -Name $name -ErrorAction Stop -ErrorVariable ev
        }
        Catch {
            Write-Warning $ev.errorRecord.Exception 
        }
    
        if ($jobs) {
            #filter unless asking for all jobs
      
            if ($All) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting all jobs"
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting enabled jobs only"
                $jobs = $jobs | where-object Enabled
            }
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing $($jobs.count) found jobs"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Getting newest $newest job results"
    
            $data = $jobs | foreach-object { 
                #get job and select all properties to create a custom object
                Try {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Trying to get jobs for $($_.name)"
                    Get-Job -Name $_.name -Newest $Newest -ErrorAction stop | foreach-object {
                        [scheduledjobresult]::new($_)
                    }
                   
                } #Try
                Catch {
                    Write-Warning "Scheduled job $($_.TargetObject) has not been run yet." 
                }
            } #Foreach Scheduled Job
             
            #write a sorted result to the pipeline
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Here are your $($data.count) results"
            $data | Sort-Object -Property PSEndTime -Descending
    
        } #if $jobs
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay)     END] Ending $($myinvocation.MyCommand)"
    } #end
    
} #end function
        
