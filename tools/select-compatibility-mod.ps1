param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('jade', 'wthit')]
    [string]$Provider
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-Sha512 {
    param([Parameter(Mandatory = $true)][string]$Path)

    $stream = [System.IO.File]::OpenRead($Path)
    $hasher = [System.Security.Cryptography.SHA512]::Create()
    try {
        $bytes = $hasher.ComputeHash($stream)
        return (($bytes | ForEach-Object { $_.ToString('x2') }) -join '')
    }
    finally {
        $hasher.Dispose()
        $stream.Dispose()
    }
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$manifestPath = Join-Path $PSScriptRoot 'compatibility-mods.json'
$runDirectory = Join-Path $repositoryRoot 'run'
$modsDirectory = Join-Path $runDirectory 'mods'
$cacheDirectory = Join-Path $runDirectory '.compatibility-mods'
$selectionFile = Join-Path $runDirectory 'compatibility-provider.txt'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$selectedProvider = $manifest.providers.$Provider

New-Item -ItemType Directory -Path $modsDirectory -Force | Out-Null
New-Item -ItemType Directory -Path $cacheDirectory -Force | Out-Null

$managedFiles = @(
    $manifest.providers.psobject.Properties.Value.files | ForEach-Object { $_ }
)

foreach ($file in $selectedProvider.files) {
    $cachedPath = Join-Path $cacheDirectory $file.filename
    $downloadPath = "$cachedPath.download"

    $cacheIsValid = Test-Path -LiteralPath $cachedPath -PathType Leaf
    if ($cacheIsValid) {
        $cacheHash = Get-Sha512 -Path $cachedPath
        $cacheIsValid = $cacheHash -eq $file.sha512
    }

    if (-not $cacheIsValid) {
        if (Test-Path -LiteralPath $downloadPath) {
            Remove-Item -LiteralPath $downloadPath -Force
        }

        Write-Host "Downloading $($file.filename) from Modrinth..."
        Invoke-WebRequest -Uri $file.url -OutFile $downloadPath
        $downloadHash = Get-Sha512 -Path $downloadPath
        if ($downloadHash -ne $file.sha512) {
            Remove-Item -LiteralPath $downloadPath -Force
            throw "SHA-512 mismatch for $($file.filename)"
        }

        Move-Item -LiteralPath $downloadPath -Destination $cachedPath -Force
    }
}

foreach ($file in $managedFiles) {
    $activePath = Join-Path $modsDirectory $file.filename
    if (Test-Path -LiteralPath $activePath -PathType Leaf) {
        $activeHash = Get-Sha512 -Path $activePath
        if ($activeHash -ne $file.sha512) {
            $backupName = "original-$($activeHash.Substring(0, 12))-$($file.filename)"
            $backupPath = Join-Path $cacheDirectory $backupName
            if (-not (Test-Path -LiteralPath $backupPath -PathType Leaf)) {
                Copy-Item -LiteralPath $activePath -Destination $backupPath
                Write-Host "Preserved the pre-existing file as $backupName."
            }
        }
        Remove-Item -LiteralPath $activePath -Force
    }
}

foreach ($file in $selectedProvider.files) {
    $cachedPath = Join-Path $cacheDirectory $file.filename
    $activePath = Join-Path $modsDirectory $file.filename
    Copy-Item -LiteralPath $cachedPath -Destination $activePath
}

[System.IO.File]::WriteAllText($selectionFile, "$Provider`r`n", [System.Text.UTF8Encoding]::new($false))
Write-Host "$($selectedProvider.displayName) $($selectedProvider.version) is selected for the next development-client run."
Write-Host 'The other overlay provider is not present in run/mods.'
