﻿. $PSScriptRoot\ScheduledJobFunctions.ps1

Class ScheduledJobResult {

    [string]$Name
    [DateTime]$StartTime
    [DateTime]$EndTime
    [timespan]$Runtime
    [Int]$ID
    [string]$State
    [bool]$HasMoreData
    [System.Management.Automation.Job[]]$ChildJobs
    [PSObject[]]$Output

    [PSObject[]] GetResults() {
        if ($this.HasMoreData) {
            $data = Receive-job -id $this.id -keep 
        }
        else {
            $data = $null
        }
        return $data
    }

    ScheduledJobResult ([int]$ID) {
        $job = Get-Job -id $ID
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
Update-TypeData -TypeName ScheduledJobResult -DefaultDisplayPropertySet Name, ID, State, Runtime, Starttime, Endtime, HasMoreData -Force

Register-ArgumentCompleter -CommandName Export-ScheduledJob, Get-ScheduledJobResult -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
    (Get-ScheduledJob -Name "$wordtoComplete*").name | foreach-object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
    
Set-Alias -Name isj -Value Import-ScheduledJob
Set-Alias -Name esj -Value Export-ScheduledJob
Set-Alias -Name ljr -Value Get-ScheduledJobResult
    
Export-ModuleMember -Function Export-ScheduledJob, Import-ScheduledJob, Get-ScheduledJobResult -Alias isj, esj, ljr