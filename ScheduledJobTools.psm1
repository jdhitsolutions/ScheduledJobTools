
(Get-ChildItem -Path $PSScriptRoot\functions\*.ps1).Foreach( { . $_.FullName })

Class ScheduledJobResult {
    [string]$Name
    [DateTime]$StartTime
    [DateTime]$EndTime
    [TimeSpan]$Runtime
    [Int]$ID
    [string]$State
    [bool]$HasMoreData
    [System.Management.Automation.Job[]]$ChildJobs
    [PSObject[]]$Output

    [PSObject[]] GetResults() {
        if ($this.HasMoreData) {
            $data = Receive-Job -Id $this.id -Keep
        }
        else {
            $data = $null
        }
        return $data
    }

    ScheduledJobResult ([int]$ID) {
        $job = Get-Job -Id $ID
        $this.Name = $job.Name
        $this.StartTime = $job.PSBeginTime
        $this.EndTime = $job.PSEndTime
        $this.Runtime = $job.PSEndTime - $job.PSBeginTime
        $this.ID = $job.Id
        $this.state = $job.State
        $this.HasMoreData = $job.HasMoreData
        $this.ChildJobs = $job.ChildJobs
        $this.Output = $job.Output
    }

    ScheduledJobResult ([Microsoft.PowerShell.ScheduledJob.ScheduledJob]$job) {
        $this.Name = $job.Name
        $this.StartTime = $job.PSBeginTime
        $this.EndTime = $job.PSEndTime
        $this.Runtime = $job.PSEndTime - $job.PSBeginTime
        $this.ID = $job.Id
        $this.state = $job.State
        $this.HasMoreData = $job.HasMoreData
        $this.ChildJobs = $job.ChildJobs
        $this.Output = $job.Output
    }

}

#set default display properties
Update-TypeData -TypeName ScheduledJobResult -DefaultDisplayPropertySet Name, ID, State, Runtime, StartTime, EndTime, HasMoreData -Force

#add a property to the ScheduledJob that shows the next run time
#17 Oct 2024 -these have been moved to the types ps1xml file.
# Update-TypeData -TypeName Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition -MemberName "NextRun" -MemberType ScriptProperty -Value { (Get-ScheduledTask -TaskName $this.name | Get-ScheduledTaskInfo).nextRunTime } -Force
# Update-TypeData -TypeName Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition -MemberName "LastRun" -MemberType ScriptProperty -Value { (Get-job $This.Name -Newest 1).PSEndTime } -Force

#add argument completers to auto populate scheduled job names
$sb = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-ScheduledJob -Name "$WordToComplete*").name | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

$completerParams = @{
    CommandName   = 'Export-ScheduledJob', 'Get-ScheduledJobResult', 'Remove-OldJobResult', 'Get-ScheduledJobDetail'
    ParameterName = 'Name'
    ScriptBlock   = $sb
}
Register-ArgumentCompleter @completerParams

