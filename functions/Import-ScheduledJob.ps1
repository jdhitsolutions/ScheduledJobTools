Function Import-ScheduledJob {

    [cmdletbinding(SupportsShouldProcess)]
    [OutputType("None", "Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition")]
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
        Write-Verbose "[$((Get-Date).TimeOfDay)   BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] processing $path"

        #define a hashtable of values for Register-ScheduledJob
        $ParamHash = @{
            ErrorAction = "Stop"
        }

        $Imported = Import-Clixml -path $Path

        #$cmd = "Register-ScheduledJob -name ""$($Imported.Name)"""
        $ParamHash.Add("Name", $Imported.Name)

        if ($Imported.scriptblock) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found a scriptblock"

            $ParamHash.Add("ScriptBlock", [scriptblock]::Create($Imported.Scriptblock))

        }
        elseif ($Imported.FilePath) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Found a filepath"
            #$cmd+= " -FilePath $($Imported.FilePath)"
            $ParamHash.Add("FilePath", $Imported.Filepath)
        }
        else {
            #this should never really happen
            Write-Warning "Failed to find a scriptblock or file path"
            #bail out
            Return
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing additional job elements"
        if ($Imported.ArgumentList) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..ArgumentList"

            $ParamHash.Add("ArgumentList", $ImportFile.ArgumentList)
        }

        if ($Imported.Authentication) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..Authentication"

            $ParamHash.Add("Authentication", $Imported.Authentication)
        }

        if ($Imported.Credential) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..Credential"

            $ParamHash.Add("credential", $Imported.Credential)
        }

        if ($Imported.InitializationScript) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..InitializationScript"

            $ParamHash.Add("InitializationScript", [scriptblock]::Create($Imported.InitializationScript))

        }

        if ($Imported.ExecutionHistoryLength) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..ExecutionHistoryLength"

            $ParamHash.Add("MaxResultCount", $Imported.ExecutionHistoryLength)
        }

        if ($Imported.RunAs32) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] ..RunAs32"

            $ParamHash.Add("RunAs32", $True)
        }

        if ($Imported.Options) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing Options"

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

            $ParamHash.Add("ScheduledJobOption", $jobOption)
        }

        if ($Imported.JobTriggers) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing Job Triggers"

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


            $ParamHash.Add("Trigger", $Triggers)
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating the scheduled job"
        Write-Verbose ($ParamHash | Out-String)
        #create the scheduled job
        if ($PSCmdlet.ShouldProcess($imported.Name)) {
            $newJob = Register-ScheduledJob @ParamHash

            #if the job is disabled, then
            if (-Not ($Imported.Enabled)) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Disabling the job"
                $newJob | Disable-ScheduledJob
            }
            if ($Passthru) {
                Get-ScheduledJob $imported.Name
            }
        } #should process
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay)     END] Ending $($MyInvocation.MyCommand)"
    } #end
} #close Import-ScheduledJob
