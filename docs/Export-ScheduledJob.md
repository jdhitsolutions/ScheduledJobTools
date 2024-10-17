---
external help file: ScheduledJobTools-help.xml
Module Name: ScheduledJobTools
online version: https://bit.ly/3eQGcf3
schema: 2.0.0
---

# Export-ScheduledJob

## SYNOPSIS

Export a PowerShell scheduled job.

## SYNTAX

### name (Default)

```yaml
Export-ScheduledJob [-Name] <String> [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### job

```yaml
Export-ScheduledJob [-ScheduledJob] <ScheduledJobDefinition> [-Path <String>] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will export a PowerShell scheduled job to an XML file using the Export-CliXML cmdlet. This file can be used to import the scheduled task on another computer running PowerShell 3.0 or later.

## EXAMPLES

### EXAMPLE 1

```PowerShell
PS C:\> Export-ScheduledJob MyJob -path \\chi-fp01\it\jobs
```

Export a single job to \\chi-fp01\it\jobs. The filename will be MyJob.xml.

### EXAMPLE 2

```powershell
PS C:\> Get-ScheduledJob | Export-ScheduledJob -path d:\backup
```

Export all scheduled jobs to a backup folder.

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

The name of a PowerShell scheduled job.

```yaml
Type: String
Parameter Sets: name
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Passthru

Write the XML file object to the pipeline.

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

### -Path

The path to store the XML file. The file name will be the same as the job name. The default is the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScheduledJob

A PowerShell scheduled job object.

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

### System.String

### Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition

## OUTPUTS

### None

### System.IO.FileInfo

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-Clixml]()

[Get-ScheduledJob]()

[Import-ScheduledJob](Import-ScheduledJob.md)
