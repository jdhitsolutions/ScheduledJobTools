Function Get-ScheduledJobDetail {
    [CmdletBinding(DefaultParameterSetName = "name")]
    [OutputType("ScheduledJobDetail")]

    Param(
        [Parameter(Position = 0, ValueFromPipeline, Mandatory, ParameterSetName = "name")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "job")]
        [ValidateNotNullOrEmpty()]
        [alias("job")]
        [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$ScheduledJob
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay)   BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using parameter set $($PSCmdlet.ParameterSetName)"
        $jobs = @()
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            foreach ($item in $name) {
                Try {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting ScheduledJob $item"
                    $jobs += Get-ScheduledJob -Name $item -ErrorAction Stop
                }
                Catch {
                    Write-Warning $_.exception.message
                }
            }
        } #if Name
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Using ScheduledJob $($ScheduledJob.name)"
            $jobs += $ScheduledJob
        }

        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting ScheduledJob details"
        foreach ($job in $jobs) {
            #get corresponding task
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] $($job.name)"
            $task = Get-ScheduledTask -TaskName $job.name
            $info = $task | Get-ScheduledTaskInfo
            [PSCustomObject]@{
                PSTypeName             = "ScheduledJobDetail"
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
        Write-Verbose "[$((Get-Date).TimeOfDay)     END] Ending $($MyInvocation.MyCommand)"
    } #end
}
