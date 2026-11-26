[CmdletBinding()]
param(
    [string]$Destination = '.agents/skills'
)

$ErrorActionPreference = 'Stop'
$repository = 'alexmengoli/u-spec'
$skills = @('propose', 'change', 'apply', 'archive')
$temporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("u-spec-install-" + [guid]::NewGuid())

try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$repository/releases/latest"
    $version = [string]$release.tag_name
    if ($version -cnotmatch '^v[0-9]+\.[0-9]+\.[0-9]+$') {
        throw "GitHub returned an invalid latest u-spec version: $version"
    }

    New-Item -ItemType Directory -Path $temporaryDirectory | Out-Null
    $archive = Join-Path $temporaryDirectory 'skills.zip'
    $assetUrl = "https://github.com/$repository/releases/download/$version/skills-$version.zip"
    Invoke-WebRequest -Uri $assetUrl -OutFile $archive

    $package = Join-Path $temporaryDirectory 'package'
    Expand-Archive -LiteralPath $archive -DestinationPath $package

    foreach ($skill in $skills) {
        $manifest = Join-Path $package "skills/$skill/SKILL.md"
        if (-not (Test-Path -LiteralPath $manifest -PathType Leaf)) {
            throw "The $version release is missing skills/$skill/SKILL.md"
        }
    }

    New-Item -ItemType Directory -Force -Path $Destination | Out-Null
    foreach ($skill in $skills) {
        $target = Join-Path $Destination $skill
        if (Test-Path -LiteralPath $target) {
            Remove-Item -LiteralPath $target -Recurse -Force
        }
        Copy-Item -LiteralPath (Join-Path $package "skills/$skill") -Destination $target -Recurse
    }

    Write-Output "Installed u-spec $version in $Destination"
}
finally {
    if (Test-Path -LiteralPath $temporaryDirectory) {
        Remove-Item -LiteralPath $temporaryDirectory -Recurse -Force
    }
}
