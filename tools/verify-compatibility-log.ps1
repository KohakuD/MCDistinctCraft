param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('jade', 'wthit')]
    [string]$Provider
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'compatibility-mods.json') -Raw | ConvertFrom-Json
$logPath = Join-Path $repositoryRoot 'run/logs/latest.log'
$selectionPath = Join-Path $repositoryRoot 'run/compatibility-provider.txt'

if (-not (Test-Path -LiteralPath $logPath -PathType Leaf)) {
    throw 'Missing run/logs/latest.log. Start and close the development client first.'
}
if (-not (Test-Path -LiteralPath $selectionPath -PathType Leaf)) {
    throw 'Missing compatibility selection marker. Run select-compatibility-mod.ps1 first.'
}

$selection = (Get-Content -LiteralPath $selectionPath -Raw).Trim()
if ($selection -ne $Provider) {
    throw "The selected provider is '$selection', not '$Provider'."
}

$log = Get-Content -LiteralPath $logPath -Raw
$selected = $manifest.providers.$Provider
$otherProvider = if ($Provider -eq 'jade') { 'wthit' } else { 'jade' }
$other = $manifest.providers.$otherProvider

$requiredPatterns = @(
    "DistinctCraft 0.5.0 \(distinctcraft\)",
    "Minecraft $([regex]::Escape($manifest.minecraft)) \(minecraft\)",
    "NeoForge $([regex]::Escape($manifest.neoforge)) \(neoforge\)",
    "$([regex]::Escape($selected.logName)) $([regex]::Escape($selected.logVersion)) \($([regex]::Escape($selected.modId))\)",
    'mod/distinctcraft:resourcepacks/(subtle|clear|monochrome)',
    'distinctcraft:coverage_smoke_test'
)

if ($Provider -eq 'wthit') {
    $requiredPatterns += 'Bad Packets 0\.12\.2 \(badpackets\)'
}

foreach ($pattern in $requiredPatterns) {
    if ($log -notmatch $pattern) {
        throw "Compatibility log is missing required evidence: $pattern"
    }
}

if ($log -match "\($([regex]::Escape($other.modId))\)") {
    throw "$($other.displayName) was loaded together with $($selected.displayName); test providers must remain mutually exclusive."
}
$errorLines = [regex]::Matches($log, '(?m)^.*\[[^\r\n]+/ERROR\].*$') | ForEach-Object { $_.Value }
$knownProviderSwitchState = $Provider -eq 'wthit' -and $log -match 'jade:max_position_deviation'
foreach ($errorLine in $errorLines) {
    if ($knownProviderSwitchState -and $errorLine -match '\[minecraft/SavedDataStorage\].*Failed to parse saved data') {
        Write-Warning 'The reused test world contains Jades saved max_position_deviation game rule. Minecraft ignored that stale provider-specific value after switching to WTHIT.'
        continue
    }
    throw "The compatibility run contains an ERROR log entry: $errorLine"
}
if ($log -match 'Crash report saved to') {
    throw 'The compatibility run produced a crash report.'
}

Write-Host "$($selected.displayName) compatibility log passed: correct versions, exclusive provider, profile reload, smoke test, and no errors."
