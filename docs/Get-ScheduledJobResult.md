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

```none
Get-ScheduledJobResult [[-Name] <String>] [-Newest <Int32>] [-All] [<CommonParameters>]
```

## DESCRIPTION

This command will retrieve the last job result for a given PowerShell scheduled job. By default, when you create a scheduled job, PowerShell will retain the last 32 job results. Although you can modify this MaxHistoryCount value. This command can help you get the most recent job result. The default behavior is to retrieve the newest job for all enabled scheduled jobs. But you can specify scheduled jobs by name, indicate if you want to see all jobs, and also the number of recent jobs.

The command uses a custom type definition based on the Job object.

## EXAMPLES

### EXAMPLE 1

```PowerShell
PS C:\> Get-ScheduledJobResult


Name        : Download PowerShell Help
ID          : 236
State       : Completed
Runtime     : 00:00:04.0070000
Starttime   : 6/28/2018 8:00:07 AM
Endtime     : 6/28/2018 8:00:11 AM
HasMoreData : False

Name        : Daily Work Backup
ID          : 237
State       : Completed
Runtime     : 00:00:01.6789112
Starttime   : 6/28/2018 6:00:07 PM
Endtime     : 6/28/2018 6:00:08 PM
HasMoreData : True
```

### EXAMPLE 2

```powershell
PS C:\> Get-ScheduledJobResult myTasksEmail -newest 3

Name        : myTasksEmail
ID          : 231
State       : Completed
Runtime     : 00:00:01.7045444
Starttime   : 6/28/2018 7:00:06 AM
Endtime     : 6/28/2018 7:00:08 AM
HasMoreData : True

Name        : myTasksEmail
ID          : 230
State       : Completed
Runtime     : 00:00:01.6864100
Starttime   : 6/27/2018 7:00:07 AM
Endtime     : 6/27/2018 7:00:09 AM
HasMoreData : True

Name        : myTasksEmail
ID          : 229
State       : Completed
Runtime     : 00:00:01.8097321
Starttime   : 6/26/2018 7:00:07 AM
Endtime     : 6/26/2018 7:00:09 AM
HasMoreData : True
```

Get the newest 3 job results for the myTasksEmail scheduled job.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Custom ScheduledJob Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-Job]()

[Get-ScheduledJob]()

