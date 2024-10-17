Function Remove-OldJobResult {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "name")]
    [OutputType("None")]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "name"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name,

        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            ParameterSetName = "job"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("job")]
        [Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$ScheduledJob
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay)   BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        #get all but newest job result for cleanup
        if ($PSCmdlet.ParameterSetName -eq 'name') {
            $items = $Name
        }
        else {
            $items = $ScheduledJob.Name
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Removing old job results for $($items -join ',')"
        Get-Job -name $items | Sort-Object PSEndTime -descending | Select-Object -skip 1 |
        Remove-Job
} #process

End {
    Write-Verbose "[$((Get-Date).TimeOfDay)     END] Ending $($MyInvocation.MyCommand)"
} #end
}
