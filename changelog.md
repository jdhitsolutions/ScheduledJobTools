# Change Log for ScheduledJobTools

## [Unreleased]

## [2.3.0] - 2024-10-17

### Added

- Added property set `RunInfo` for the scheduled job definition type.
- Added script property `LastRun` to the scheduled job definition type.

### Changed

- Moved script property definitions to the types ps1xml file.
- Code cleanup.
- Converted Changelog to new format.
- Reorganized module layout.
- Updated online help links.
- Minor help updates.

## [v2.2.0] - 2020-09-04

- Defined new custom object type for `Get-ScheduledJobDetail`.
- Added a custom table view called `NextRun` to be used when running `Get-ScheduledJob`.
- Added a script property called `NextRun` to the ScheduledJob object.
- Reorganized the module.
- Help updates.
- Updated `README.md`.

## [v2.1.0] - 2019-02-15

- Added `PSScheduledJob` as a required module to the manifest.
- Added `ScheduledJobResult.format.ps1xml` to format output from `Get-ScheduledJobResult` as a table.
- Revised `Get-ScheduledJobDetail` to have a default parameter set.
- Updated license copyright year.

## [v2.0.0] - 2018-10-23

- Changed minimum version to 5.1 and supporting Desktop edition only.
- file cleanup for the PowerShell Gallery.
- Moved alias definitions to respective functions.
- Updated help.

## v1.4.0 - 2018-06-29

- Added `Get-ScheduledJobDetail`.

## [v1.3.1] - 2018-06-29

- manifest changes.
- published to PowerShell Gallery.

## v1.3

- Added `Remove-OldJobResult`.
- Updated `README.md`.

## v1.2

- moved to external help.
- code cleanup.
- Added `Get-ScheduledJobResult` command and associated class.
- Added an auto-completer for Name parameter in `Export-ScheduledJob` and `Get-ScheduledJobResult`.
- increased required PowerShell version to 5.0.

## v1.1

- initial release.

[Unreleased]: https://github.com/jdhitsolutions/ScheduledJobTools/compare/v2.3.0..HEAD
[2.3.0]: https://github.com/jdhitsolutions/ScheduledJobTools/compare/vv2.2.0..v2.3.0
[v2.2.0]: https://github.com/jdhitsolutions/ScheduledJobtools/compare/v2.1.0..v2.2.0
[v2.1.0]: https://github.com/jdhitsolutions/ScheduledJobtools/compare/v2.0.0..v2.1.0
[v2.0.0]: https://github.com/jdhitsolutions/ScheduledJobTools/compare/v2.0.0..v1.3.1
[v1.3.1]: https://github.com/jdhitsolutions/ScheduledJobTools/compare/v1.3.1..v1.3