---
external help file: ScheduledJobTools-help.xml
Module Name: ScheduledJobTools
online version:
schema: 2.0.0
---

# Remove-OldJobResult

## SYNOPSIS

Remove old job results

## SYNTAX

### name (Default)

```yaml
Remove-OldJobResult [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### job

```yaml
Remove-OldJobResult [-ScheduledJob] <ScheduledJobDefinition> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to remove all but the most recent scheduled job result.

## EXAMPLES

### Example 1

```powershell
PS C:\> Remove-OldJobResult -name DailyBackup
```

Remove all the but the most recent result for the DailyBackup job.

### Example 2

```powershell
PS C:\> Get-Scheduledjob | Remove-OldJobResult
```

Get all scheduled jobs and pipe them to this command to delete all but the most recent result.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

The name of a scheduled job.

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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

### Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Remove-Job]()

[Get-ScheduledJob]()