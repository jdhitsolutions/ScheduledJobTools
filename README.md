# ScheduledJobTools

[![PSGallery Version](https://img.shields.io/powershellgallery/v/ScheduledJobTools.png?style=for-the-badge&logo=powershell&label=PowerShell%20Gallery)](https://www.powershellgallery.com/packages/ScheduledJobTools/) [![PSGallery Downloads](https://img.shields.io/powershellgallery/dt/ScheduledJobTools.png?style=for-the-badge&label=Downloads)](https://www.powershellgallery.com/packages/ScheduledJobTools/)

A PowerShell module with commands for working with scheduled jobs. PowerShell scheduled jobs are only supported on Windows platforms. You can install this module from the PowerShell Gallery:

```powershell
Install-Module ScheduledJobTools
```

This module will not run on PowerShell 7 since it does not support the ScheduledJob module.

## Commands

The module consists of these commands:

[Export-ScheduledJob](/docs/Export-ScheduledJob.md)

This command will export a scheduled job configuration to an XML file, making it easier to recreate on another computer or if you need to re-install.

[Import-ScheduledJob](/docs/Import-ScheduledJob.md)

Assuming you have exported the scheduled job, use this command to import it and recreate the configuration.

[Get-ScheduledJobResult](/docs/Get-ScheduledJobResult.md)

This command is designed to make it easier to get the most recent results of your scheduled job.

```text
PS C:\> Get-ScheduledJobResult

ID  Name                StartTime             EndTime               Runtime          State
--  ----                ---------             -------               -------          -----
551 OfflineTickle       9/4/2020 10:00:13 AM  9/4/2020 10:00:14 AM  00:00:01.0010018 Completed
154 myTasksEmail        9/4/2020 8:00:08 AM   9/4/2020 8:00:11 AM   00:00:02.9260021 Completed
58  WeeklyFullBackup    8/28/2020 10:00:08 PM 8/28/2020 10:14:43 PM 00:14:35.6991443 Completed
553 RemoteOpWatcher     9/4/2020 10:33:56 AM  9/4/2020 10:33:56 AM  00:00:00.6534636 Completed
153 DailyIncremental    9/3/2020 10:00:07 PM  9/3/2020 10:00:39 PM  00:00:31.3470147 Completed
72  JDHITBackup         9/3/2020 6:00:07 PM   9/3/2020 6:00:10 PM   00:00:03.1494835 Completed
```

The function has an alias of `ljr`.

[Remove-OldJobResult](/docs/Remove-OldJobResult.md)

Use this command to remove all but the most recent scheduled job result.

[Get-ScheduledJobDetail](/docs/Get-ScheduledJobDetail.md)

PowerShell Scheduled jobs are intertwined with Scheduled Tasks. There is a lot of useful information, but it is buried in nested objects and properties. This command is designed to make it easier to get detailed information about a scheduled job.

```text
PS C:\> Get-ScheduledJobDetail -Name DailyIncremental


ID                     : 3
Name                   : DailyIncremental
Command                : C:\scripts\PSBackup\DailyIncrementalBackup.ps1
Enabled                : True
State                  : Ready
NextRun                : 9/5/2020 10:00:00 PM
MaxHistory             : 7
RunAs                  : BOVINE320\Jeff
Frequency              : Weekly
Days                   : {Sunday, Monday, Tuesday, Wednesday...}
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
WakeToRun              : True
```

## Customizations

When you import the module, it will modify the ScheduledJob object to define a script property called `NextRun`. This makes it easier to view when a job is scheduled to run again.

```text
PS C:\> Get-ScheduledJob JDHITBackup | Select-Object name,NextRun

Name        NextRun
----        -------
JDHITBackup 9/4/2020 6:00:00 PM
```

Or you can use a custom table view.

```text
PS C:\> Get-ScheduledJob | Format-Table -view nextrun

Id Enabled Name                NextRun               Command
-- ------- ----                -------               -------
2  False   DailyDiskReport     9/4/2020 11:00:00 PM  C:\scripts\DiskReports.ps1
3  True    DailyIncremental    9/5/2020 10:00:00 PM  C:\scripts\PSBackup\DailyIncrementalBackup.ps1
4  True    DailyWatcher                              ...
5  False   HelpUpdate          9/28/2020 12:00:00 PM  Update-Help
6  True    JDHITBackup         9/4/2020 6:00:00 PM   C:\scripts\Backup-JDHIT.ps1
8  True    myTasksEmail        9/5/2020 8:00:00 AM   ...
9  True    OfflineTickle       9/4/2020 11:00:00 AM  ...
10 True    RemoteOpWatcher     9/4/2020 10:41:41 AM  ...
11 True    WeeklyFullBackup    9/4/2020 10:00:00 PM  C:\scripts\PSBackup\WeeklyFullBackup.ps1
73 True    tmp50E8             9/4/2020 12:45:45 PM  ...
```

The view uses ANSI escape sequences and will color `False` in red.

*last updated 4 September 2020*
