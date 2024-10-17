Function Get-ScheduledJobResult {

    [cmdletbinding()]
    [OutputType("ScheduledJobResult")]
    [Alias("ljr")]

    Param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name = "*",
        [ValidateScript({ $_ -gt 0 })]
        [int]$Newest = 1,
        [switch]$All
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay)   BEGIN] Starting $($MyInvocation.MyCommand)"
    } #begin

    Process {
        #only show results for Enabled jobs
        Try {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting scheduled jobs for $name"
            $jobs = Get-ScheduledJob -Name $name -ErrorAction Stop #-ErrorVariable ev
        }
        Catch {
            Write-Warning "$Name : $($_.exception.message)"
            # $ev.errorRecord.Exception
        }

        if ($jobs) {
            #filter unless asking for all jobs

            if ($All) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting all jobs"
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting enabled jobs only"
                $jobs = $jobs | Where-Object Enabled
            }
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $($jobs.count) found jobs"
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Getting newest $newest job results"

            $data = $jobs | ForEach-Object {
                #get job and select all properties to create a custom object
                Try {
                    Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Trying to get jobs for $($_.name)"
                    Get-Job -Name $_.name -Newest $Newest -ErrorAction stop | ForEach-Object {
                        [ScheduledJobResult]::new($_)
                    }
                } #Try
                Catch {
                    Write-Warning $_.exception.message
                    Write-Warning "Scheduled job $($_.TargetObject) has not been run yet."
                }
            } #Foreach Scheduled Job

            #write a sorted result to the pipeline
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Here are your $($data.count) results"
            $data | Sort-Object -Property PSEndTime -Descending

        } #if $jobs
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeOfDay)     END] Ending $($MyInvocation.MyCommand)"
    } #end

} #end function
