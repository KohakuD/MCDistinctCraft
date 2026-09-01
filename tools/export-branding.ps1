$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$svgPath = Join-Path $repositoryRoot 'docs/assets/branding/distinctcraft-logo.svg'
$curseForgePath = Join-Path $repositoryRoot 'docs/assets/branding/distinctcraft-logo.png'
$modPath = Join-Path $repositoryRoot 'src/main/resources/distinctcraft.png'

$edgeCandidates = @(
    (Join-Path ${env:ProgramFiles(x86)} 'Microsoft/Edge/Application/msedge.exe'),
    (Join-Path $env:ProgramFiles 'Microsoft/Edge/Application/msedge.exe')
)
$edgePath = $edgeCandidates | Where-Object { $_ -and (Test-Path -LiteralPath $_ -PathType Leaf) } | Select-Object -First 1
if (-not $edgePath) {
    throw 'Microsoft Edge is required to rasterize the canonical SVG on Windows.'
}

$svgUri = [System.Uri]::new($svgPath).AbsoluteUri
if (Test-Path -LiteralPath $curseForgePath -PathType Leaf) {
    Remove-Item -LiteralPath $curseForgePath -Force
}
& $edgePath '--headless=new' '--disable-gpu' '--hide-scrollbars' '--window-size=1024,1024' "--screenshot=$curseForgePath" $svgUri
$deadline = [DateTime]::UtcNow.AddSeconds(10)
while (-not (Test-Path -LiteralPath $curseForgePath -PathType Leaf) -and [DateTime]::UtcNow -lt $deadline) {
    Start-Sleep -Milliseconds 100
}
if (-not (Test-Path -LiteralPath $curseForgePath -PathType Leaf)) {
    throw 'Edge did not create the 1024 x 1024 branding export.'
}

Add-Type -AssemblyName System.Drawing
$source = [System.Drawing.Image]::FromFile($curseForgePath)
try {
    if ($source.Width -ne 1024 -or $source.Height -ne 1024) {
        throw "Unexpected CurseForge export dimensions: $($source.Width) x $($source.Height)"
    }

    $modIcon = [System.Drawing.Bitmap]::new(256, 256)
    try {
        $graphics = [System.Drawing.Graphics]::FromImage($modIcon)
        try {
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
            $graphics.DrawImage($source, 0, 0, 256, 256)
        }
        finally {
            $graphics.Dispose()
        }
        $modIcon.Save($modPath, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $modIcon.Dispose()
    }
}
finally {
    $source.Dispose()
}

Write-Host "Exported CurseForge logo: $curseForgePath"
Write-Host "Exported NeoForge icon: $modPath"
