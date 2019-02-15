---
external help file: ScheduledJobTools-help.xml
Module Name: ScheduledJobTools
online version:
schema: 2.0.0
---

# Get-ScheduledJobDetail

## SYNOPSIS

Get details for a PowerShell Scheduled Job

## SYNTAX

### name (Default)

```yaml
Get-ScheduledJobDetail [-Name] <String[]> [<CommonParameters>]
```

### job

```yaml
Get-ScheduledJobDetail [-ScheduledJob] <ScheduledJobDefinition> [<CommonParameters>]
```

## DESCRIPTION

The PowerShell scheduled job object is very rich. There is a great deal of information but much of it is nested. This command will expose the most common information you might want to know about a scheduled job.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-ScheduledJobDetail jdhitbackup



ID                     : 19
Name                   : JDHITBackup
Command                : C:\scripts\Backup-JDHIT.ps1
Enabled                : True
State                  : Ready
NextRun                : 6/29/2018 6:00:00 PM
MaxHistory             : 5
RunAs                  : Jeff
Frequency              : Daily
Days                   :
RepetitionDuration     :
RepetitionInterval     :
DoNotAllowDemandStart  : False
IdleDuration           : 00:10:00
IdleTimeout            : 01:00:00
MultipleInstancePolicy : IgnoreNew
RestartOnIdleResume    : False
RunElevated            : True
RunWithoutNetwork      : False
ShowInTaskScheduler    : True
StartIfNotIdle         : True
StartIfOnBatteries     : False
StopIfGoingOffIdle     : False
StopIfGoingOnBatteries : True
WakeToRun              : False
```

Get job details for a single scheduled job.

### Example 2

```powershell
PS C:\> Get-ScheduledJob | Get-ScheduledJobDetail | Out-Gridview
```

Get job detail for all scheduled jobs and pipe to Out-Gridview.

## PARAMETERS

### -Name

Enter the name of a scheduled job.

```yaml
Type: String[]
Parameter Sets: name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ScheduledJob

A scheduled job object.

```yaml
Type: ScheduledJobDefinition
Parameter Sets: job
Aliases: job

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

### Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition

## OUTPUTS

### System.Object

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-ScheduledJob]()

[Get-ScheduledTask]()

[Get-ScheduledTaskInfo]()