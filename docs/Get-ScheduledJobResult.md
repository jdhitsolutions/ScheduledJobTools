---
external help file: ScheduledJobTools-help.xml
Module Name: ScheduledJobTools
online version:
schema: 2.0.0
---

# Get-ScheduledJobResult

## SYNOPSIS

Get PowerShell scheduled job result.

## SYNTAX

```yaml
Get-ScheduledJobResult [[-Name] <String>] [-Newest <Int32>] [-All] [<CommonParameters>]
```

## DESCRIPTION

This command will retrieve the last job result for a given PowerShell scheduled job. By default, when you create a scheduled job, PowerShell will retain the last 32 job results. Although you can modify this MaxHistoryCount value. This command can help you get the most recent job result. The default behavior is to retrieve the newest job for all enabled scheduled jobs. But you can specify scheduled jobs by name, indicate if you want to see all jobs, and also the number of recent jobs.

The command uses a custom type definition based on the Job object.

## EXAMPLES

### EXAMPLE 1

```PowerShell
PS C:\> Get-ScheduledJobResult


ID Name            StartTime             EndTime               Runtime          State
-- ----            ---------             -------               -------          -----
20 OfflineTickle   2/15/2019 12:00:08 PM 2/15/2019 12:00:09 PM 00:00:00.9199788 Completed
25 DownloadHelp    2/15/2019 8:00:04 AM  2/15/2019 8:00:06 AM  00:00:02.2474913 Completed
44 RemoteOpWatcher 2/15/2019 12:49:53 PM 2/15/2019 12:49:53 PM 00:00:00.4630425 Completed
15 myTasksEmail    2/15/2019 8:00:04 AM  2/15/2019 8:00:06 AM  00:00:01.6949456 Completed
```

### EXAMPLE 2

```powershell
PS C:\> Get-ScheduledJobResult myTasksEmail -newest 3

ID Name         StartTime            EndTime              Runtime          State
-- ----         ---------            -------              -------          -----
15 myTasksEmail 2/15/2019 8:00:04 AM 2/15/2019 8:00:06 AM 00:00:01.6949456 Completed
14 myTasksEmail 2/14/2019 8:00:04 AM 2/14/2019 8:00:06 AM 00:00:01.6648106 Completed
13 myTasksEmail 2/13/2019 8:00:04 AM 2/13/2019 8:00:05 AM 00:00:01.4718193 Completed
```

Get the newest 3 job results for the myTasksEmail scheduled job.

### EXAMPLE 3

```powershell
PS C:\> Get-ScheduledJobResult offlinetickle | format-list

Name        : OfflineTickle
ID          : 20
State       : Completed
Runtime     : 00:00:00.9199788
Starttime   : 2/15/2019 12:00:08 PM
Endtime     : 2/15/2019 12:00:09 PM
HasMoreData : True
```

Get all properties of the result object.

## PARAMETERS

### -Name

The name of a PowerShell scheduled job.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Newest

The number of newest job results to retrieve.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -All

Display all scheduled jobs. The default is enabled only.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### ScheduledJobResult

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Job]()

[Get-ScheduledJob]()

