$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$profiles = @('subtle', 'clear', 'monochrome')
$blocks = @(
    'andesite', 'gravel', 'coal_ore', 'deepslate_coal_ore', 'iron_ore', 'deepslate_iron_ore',
    'copper_ore', 'deepslate_copper_ore', 'gold_ore', 'deepslate_gold_ore', 'redstone_ore',
    'deepslate_redstone_ore', 'lapis_ore', 'deepslate_lapis_ore', 'diamond_ore',
    'deepslate_diamond_ore', 'emerald_ore', 'deepslate_emerald_ore', 'nether_quartz_ore', 'nether_gold_ore'
)
$items = @('coal', 'raw_iron', 'raw_copper', 'raw_gold', 'redstone', 'lapis_lazuli', 'diamond', 'emerald', 'quartz', 'gold_nugget')

$cellWidth = 116
$cellHeight = 82
$headingHeight = 28
$columns = 10
$rowsPerProfile = 3
$canvasWidth = $columns * $cellWidth
$canvasHeight = $profiles.Count * ($headingHeight + $rowsPerProfile * $cellHeight)
$workspaceRoot = Join-Path $PSScriptRoot '..'
$outputDirectory = Join-Path $workspaceRoot 'docs\images'
$outputPath = Join-Path $outputDirectory '0.4.0-coverage.png'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$canvas = [Drawing.Bitmap]::new($canvasWidth, $canvasHeight, [Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [Drawing.Graphics]::FromImage($canvas)
$headingFont = [Drawing.Font]::new('Segoe UI', 12, [Drawing.FontStyle]::Bold)
$labelFont = [Drawing.Font]::new('Segoe UI', 7)
$headingBrush = [Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 235, 235, 235))
$labelBrush = [Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 215, 215, 215))
$cellBrush = [Drawing.SolidBrush]::new([Drawing.Color]::FromArgb(255, 42, 44, 48))

try {
    $graphics.Clear([Drawing.Color]::FromArgb(255, 24, 26, 29))
    $graphics.InterpolationMode = [Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $graphics.PixelOffsetMode = [Drawing.Drawing2D.PixelOffsetMode]::Half

    for ($profileIndex = 0; $profileIndex -lt $profiles.Count; $profileIndex++) {
        $profile = $profiles[$profileIndex]
        $profileTop = $profileIndex * ($headingHeight + $rowsPerProfile * $cellHeight)
        $graphics.DrawString($profile.ToUpperInvariant(), $headingFont, $headingBrush, 8, $profileTop + 3)

        $entries = @()
        foreach ($name in $blocks) { $entries += ,@('block', $name) }
        foreach ($name in $items) { $entries += ,@('item', $name) }

        for ($index = 0; $index -lt $entries.Count; $index++) {
            $category = $entries[$index][0]
            $name = $entries[$index][1]
            $column = $index % $columns
            $row = [Math]::Floor($index / $columns)
            $left = $column * $cellWidth
            $top = $profileTop + $headingHeight + $row * $cellHeight
            $graphics.FillRectangle($cellBrush, $left + 2, $top + 2, $cellWidth - 4, $cellHeight - 4)

            $texturePath = Join-Path $workspaceRoot "src\main\resources\resourcepacks\$profile\assets\minecraft\textures\$category\$name.png"
            $texture = [Drawing.Bitmap]::new($texturePath)
            try {
                $graphics.DrawImage($texture, $left + 34, $top + 5, 48, 48)
            }
            finally {
                $texture.Dispose()
            }
            $graphics.DrawString($name, $labelFont, $labelBrush, $left + 4, $top + 58)
        }
    }

    $canvas.Save($outputPath, [Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Generated $outputPath"
}
finally {
    $cellBrush.Dispose()
    $labelBrush.Dispose()
    $headingBrush.Dispose()
    $labelFont.Dispose()
    $headingFont.Dispose()
    $graphics.Dispose()
    $canvas.Dispose()
}
