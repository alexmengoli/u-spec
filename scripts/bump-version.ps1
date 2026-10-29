[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^v?(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$')]
    [string]$Version
)

$ErrorActionPreference = 'Stop'
$targetVersion = 'v' + ($Version -replace '^v', '')
$targetNumber = [version]$targetVersion.Substring(1)
$root = Split-Path -Parent $PSScriptRoot
$updates = @()
$currentVersion = $null
$encoding = New-Object System.Text.UTF8Encoding($false, $true)

foreach ($skill in 'propose', 'change', 'apply', 'archive') {
    $path = Join-Path $root "skills/$skill/SKILL.md"
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $content = $encoding.GetString($bytes)
    $versionMatches = [regex]::Matches($content, '(?m)^Framework version: ([^\r\n]+)\r?$')
    if ($versionMatches.Count -ne 1) {
        throw "Expected exactly one Framework version in $path"
    }

    $declaredVersion = $versionMatches[0].Groups[1].Value
    if ($declaredVersion -cnotmatch '^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$') {
        throw "Invalid framework version in ${path}: $declaredVersion"
    }
    if ($null -eq $currentVersion) {
        $currentVersion = $declaredVersion
    } elseif ($declaredVersion -cne $currentVersion) {
        throw "Skill versions differ: expected $currentVersion but $path declares $declaredVersion"
    }

    $value = $versionMatches[0].Groups[1]
    $updated = $content.Substring(0, $value.Index) + $targetVersion +
        $content.Substring($value.Index + $value.Length)
    $updates += [pscustomobject]@{ Path = $path; Content = $updated }
}

if ($targetNumber -le [version]$currentVersion.Substring(1)) {
    throw "New version $targetVersion must be greater than $currentVersion"
}

if ($PSCmdlet.ShouldProcess($root, "Update all four skill versions from $currentVersion to $targetVersion")) {
    foreach ($update in $updates) {
        [System.IO.File]::WriteAllBytes($update.Path, $encoding.GetBytes($update.Content))
    }
    Write-Output "Updated all four skills: $currentVersion -> $targetVersion"
}