---
external help file: ScheduledJobTools-help.xml
Module Name: ScheduledJobTools
online version:
schema: 2.0.0
---

# Import-ScheduledJob

## SYNOPSIS

Import a PowerShell scheduled job from an XML file.

## SYNTAX

```yaml
Import-ScheduledJob [-Path] <String> [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

This command will take an exported PowerShell scheduled job stored in an XML file and import it, re-creating the scheduled job. If the job uses credentials you will be prompted for the credential password.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Import-ScheduledJob \\chi-fp01\it\jobs\myjob.xml
```

Import a scheduled job from an XML file located on a file share.

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

### -Passthru

Write the new job to the pipeline.

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

The path and file name with the exported job definition.

```yaml
Type: String
Parameter Sets: (All)
Aliases: name, pspath

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

## OUTPUTS

### None

### Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Register-ScheduledJob]()

[Export-ScheduledJob]()

[Import-CliXML]()
