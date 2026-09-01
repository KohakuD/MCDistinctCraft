$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$resourcePackRoot = Join-Path $PSScriptRoot '..\src\main\resources\resourcepacks'

function New-Texture {
    param(
        [Parameter(Mandatory)] [string] $Profile,
        [Parameter(Mandatory)] [ValidateSet('block', 'item')] [string] $Category,
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string[]] $Rows,
        [Parameter(Mandatory)] [hashtable] $Palette
    )

    if ($Rows.Count -ne 16 -or ($Rows | Where-Object Length -ne 16)) {
        throw "$Profile/$Category/$Name must contain exactly 16 rows with 16 pixels each."
    }

    $outputDirectory = Join-Path $resourcePackRoot "$Profile\assets\minecraft\textures\$Category"
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    $bitmap = [System.Drawing.Bitmap]::new(16, 16, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        for ($y = 0; $y -lt 16; $y++) {
            for ($x = 0; $x -lt 16; $x++) {
                $symbol = [string] $Rows[$y][$x]
                if (-not $Palette.ContainsKey($symbol)) {
                    throw "Unknown palette symbol '$symbol' in $Profile/$Category/$Name at $x,$y."
                }
                $bitmap.SetPixel($x, $y, $Palette[$symbol])
            }
        }

        $path = Join-Path $outputDirectory "$Name.png"
        $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-Host "Generated $path"
    }
    finally {
        $bitmap.Dispose()
    }
}

function ConvertTo-Rows {
    param([Parameter(Mandatory)] [object[]] $Pixels)
    return @($Pixels | ForEach-Object { -join $_ })
}

function New-BackgroundRows {
    param([Parameter(Mandatory)] [int] $Seed)

    $pixels = @()
    for ($y = 0; $y -lt 16; $y++) {
        $row = @()
        for ($x = 0; $x -lt 16; $x++) {
            $value = ($x * 11 + $y * 7 + (($x * $y) % 5) + $Seed) % 10
            $row += if ($value -lt 2) { '0' } elseif ($value -lt 8) { '1' } else { '2' }
        }
        $pixels += ,$row
    }
    return $pixels
}

function Add-Glyph {
    param(
        [Parameter(Mandatory)] [object[]] $Pixels,
        [Parameter(Mandatory)] [string[]] $Glyph,
        [Parameter(Mandatory)] [int] $Left,
        [Parameter(Mandatory)] [int] $Top,
        [switch] $OnlyOpaque
    )

    for ($glyphY = 0; $glyphY -lt $Glyph.Count; $glyphY++) {
        for ($glyphX = 0; $glyphX -lt $Glyph[$glyphY].Length; $glyphX++) {
            $symbol = [string] $Glyph[$glyphY][$glyphX]
            $x = $Left + $glyphX
            $y = $Top + $glyphY
            if ($symbol -eq '.' -or $x -lt 0 -or $x -ge 16 -or $y -lt 0 -or $y -ge 16) { continue }
            if ($OnlyOpaque -and $Pixels[$y][$x] -eq '.') { continue }
            $Pixels[$y][$x] = $symbol
        }
    }
}

function New-OreRows {
    param(
        [Parameter(Mandatory)] [string[]] $Glyph,
        [Parameter(Mandatory)] [int] $Seed,
        [Parameter(Mandatory)] [object[]] $Placements
    )

    $pixels = New-BackgroundRows -Seed $Seed
    foreach ($placement in $Placements) {
        Add-Glyph -Pixels $pixels -Glyph $Glyph -Left $placement[0] -Top $placement[1]
    }
    return ConvertTo-Rows -Pixels $pixels
}

function Merge-OreMask {
    param(
        [Parameter(Mandatory)] [string[]] $MaskRows,
        [Parameter(Mandatory)] [int] $Seed
    )

    $pixels = New-BackgroundRows -Seed $Seed
    for ($y = 0; $y -lt 16; $y++) {
        for ($x = 0; $x -lt 16; $x++) {
            $symbol = [string] $MaskRows[$y][$x]
            if ($symbol -eq '3' -or $symbol -eq '4') { $pixels[$y][$x] = $symbol }
        }
    }
    return ConvertTo-Rows -Pixels $pixels
}

function New-ItemRows {
    param(
        [Parameter(Mandatory)] [ValidateSet('chunk', 'gem', 'dust', 'shard', 'nugget')] [string] $Shape,
        [Parameter(Mandatory)] [string[]] $Glyph
    )

    $pixels = @()
    for ($y = 0; $y -lt 16; $y++) { $pixels += ,(@('.') * 16) }

    switch ($Shape) {
        'chunk' {
            $bounds = @(@(5, 10), @(3, 12), @(2, 13), @(2, 13), @(3, 12), @(4, 11), @(6, 9))
            for ($offset = 0; $offset -lt $bounds.Count; $offset++) {
                $y = 4 + $offset
                for ($x = $bounds[$offset][0]; $x -le $bounds[$offset][1]; $x++) { $pixels[$y][$x] = '3' }
            }
        }
        'gem' {
            for ($y = 2; $y -le 13; $y++) {
                $distance = [Math]::Abs(7.5 - $y)
                $halfWidth = [Math]::Floor(6 - $distance)
                for ($x = 8 - $halfWidth; $x -le 7 + $halfWidth; $x++) { $pixels[$y][$x] = '3' }
            }
        }
        'dust' {
            $bounds = @(@(7, 8), @(5, 10), @(3, 12), @(2, 13), @(4, 11))
            for ($offset = 0; $offset -lt $bounds.Count; $offset++) {
                $y = 8 + $offset
                for ($x = $bounds[$offset][0]; $x -le $bounds[$offset][1]; $x++) { $pixels[$y][$x] = '3' }
            }
        }
        'shard' {
            for ($y = 2; $y -le 13; $y++) {
                $center = 11 - [Math]::Floor($y / 2)
                for ($x = $center - 2; $x -le $center + 2; $x++) { $pixels[$y][$x] = '3' }
            }
        }
        'nugget' {
            $bounds = @(@(6, 9), @(4, 11), @(3, 12), @(4, 11), @(6, 9))
            for ($offset = 0; $offset -lt $bounds.Count; $offset++) {
                $y = 6 + $offset
                for ($x = $bounds[$offset][0]; $x -le $bounds[$offset][1]; $x++) { $pixels[$y][$x] = '3' }
            }
        }
    }

    Add-Glyph -Pixels $pixels -Glyph $Glyph -Left 6 -Top 6 -OnlyOpaque
    return ConvertTo-Rows -Pixels $pixels
}

$andesiteRows = @(
    '1100112222110011', '1122331111223311', '0011110033111100', '2233221111002233',
    '1111002211110011', '0011223333221100', '3311110011112233', '1122001111220011',
    '0011332211113300', '2211110011112233', '1100221111002211', '0033111122331100',
    '3311112200111133', '1122001111330011', '0011223311112200', '2211110011221133'
)
$gravelRows = @(
    '1120001110022211', '1203401100233321', '0033300012333200', '0112000012200011',
    '0222101100012210', '0233211000123320', '0022100111233200', '1100012330022001',
    '1000123430012311', '0011233210023320', '0123320011002200', '0012200122100011',
    '1100012333210122', '0220123443201233', '0330012332000221', '1120012210112001'
)
$ironRows = @(
    '1122110011221100', '1234411122112211', '1340012211001122', '1340112244411221',
    '1233112340012211', '1122111340011122', '2211221343312211', '1100111233110044',
    '2211221100111140', '1144412211233340', '1140011121340033', '1240012211340011',
    '1233311121233311', '1122112234411221', '2211221134012112', '1100112233311221'
)
$coalRows = @(
    '2233224422332244', '2303223322443322', '3000322433224433', '2303223302243322',
    '2233223000322244', '3322442303224433', '2244332233223322', '4422333322443000',
    '2233224422334300', '3322443000323430', '2244332303223322', '4433223000322233',
    '3322444303443322', '2244333000322244', '4433224303443322', '3322442233224433'
)

$glyphs = [ordered] @{
    'coal' = @('.3.', '343', '.3.')
    'iron' = @('3..', '344', '3..')
    'copper' = @('34', '43', '34')
    'gold' = @('444', '4.4', '444')
    'redstone' = @('.3.', '343', '.4.')
    'lapis' = @('333', '.4.', '333')
    'diamond' = @('.4.', '4.4', '.3.')
    'emerald' = @('3.3', '.4.', '3.3')
    'quartz' = @('..4', '.43', '43.')
}

$placements = [ordered] @{
    'copper' = @(@(2, 1), @(10, 3), @(5, 9), @(12, 12))
    'gold' = @(@(1, 2), @(9, 1), @(5, 10), @(12, 8))
    'redstone' = @(@(3, 1), @(11, 4), @(2, 10), @(9, 12))
    'lapis' = @(@(1, 3), @(9, 2), @(5, 8), @(11, 12))
    'diamond' = @(@(2, 1), @(11, 3), @(4, 11), @(9, 8))
    'emerald' = @(@(1, 2), @(8, 1), @(12, 8), @(5, 12))
    'quartz' = @(@(2, 2), @(10, 1), @(5, 9), @(12, 11))
    'nether_gold' = @(@(1, 1), @(10, 3), @(4, 9), @(11, 11))
}

$blockSpecs = [ordered] @{
    'andesite' = @{ Rows = $andesiteRows; Kind = 'fixed' }
    'gravel' = @{ Rows = $gravelRows; Kind = 'fixed' }
    'coal_ore' = @{ Rows = $coalRows; Host = 'stone'; Ore = 'coal'; Kind = 'legacy' }
    'deepslate_coal_ore' = @{ Rows = (Merge-OreMask -MaskRows $coalRows -Seed 31); Host = 'deepslate'; Ore = 'coal'; Kind = 'ore' }
    'iron_ore' = @{ Rows = $ironRows; Host = 'stone'; Ore = 'iron'; Kind = 'legacy' }
    'deepslate_iron_ore' = @{ Rows = (Merge-OreMask -MaskRows $ironRows -Seed 37); Host = 'deepslate'; Ore = 'iron'; Kind = 'ore' }
    'copper_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.copper -Seed 41 -Placements $placements.copper); Host = 'stone'; Ore = 'copper'; Kind = 'ore' }
    'deepslate_copper_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.copper -Seed 43 -Placements $placements.copper); Host = 'deepslate'; Ore = 'copper'; Kind = 'ore' }
    'gold_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.gold -Seed 47 -Placements $placements.gold); Host = 'stone'; Ore = 'gold'; Kind = 'ore' }
    'deepslate_gold_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.gold -Seed 53 -Placements $placements.gold); Host = 'deepslate'; Ore = 'gold'; Kind = 'ore' }
    'redstone_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.redstone -Seed 59 -Placements $placements.redstone); Host = 'stone'; Ore = 'redstone'; Kind = 'ore' }
    'deepslate_redstone_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.redstone -Seed 61 -Placements $placements.redstone); Host = 'deepslate'; Ore = 'redstone'; Kind = 'ore' }
    'lapis_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.lapis -Seed 67 -Placements $placements.lapis); Host = 'stone'; Ore = 'lapis'; Kind = 'ore' }
    'deepslate_lapis_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.lapis -Seed 71 -Placements $placements.lapis); Host = 'deepslate'; Ore = 'lapis'; Kind = 'ore' }
    'diamond_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.diamond -Seed 73 -Placements $placements.diamond); Host = 'stone'; Ore = 'diamond'; Kind = 'ore' }
    'deepslate_diamond_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.diamond -Seed 79 -Placements $placements.diamond); Host = 'deepslate'; Ore = 'diamond'; Kind = 'ore' }
    'emerald_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.emerald -Seed 83 -Placements $placements.emerald); Host = 'stone'; Ore = 'emerald'; Kind = 'ore' }
    'deepslate_emerald_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.emerald -Seed 89 -Placements $placements.emerald); Host = 'deepslate'; Ore = 'emerald'; Kind = 'ore' }
    'nether_quartz_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.quartz -Seed 97 -Placements $placements.quartz); Host = 'netherrack'; Ore = 'quartz'; Kind = 'ore' }
    'nether_gold_ore' = @{ Rows = (New-OreRows -Glyph $glyphs.gold -Seed 101 -Placements $placements.nether_gold); Host = 'netherrack'; Ore = 'gold'; Kind = 'ore' }
}

$itemSpecs = [ordered] @{
    'coal' = @{ Ore = 'coal'; Shape = 'chunk'; Glyph = $glyphs.coal }
    'raw_iron' = @{ Ore = 'iron'; Shape = 'chunk'; Glyph = $glyphs.iron }
    'raw_copper' = @{ Ore = 'copper'; Shape = 'chunk'; Glyph = $glyphs.copper }
    'raw_gold' = @{ Ore = 'gold'; Shape = 'chunk'; Glyph = $glyphs.gold }
    'redstone' = @{ Ore = 'redstone'; Shape = 'dust'; Glyph = $glyphs.redstone }
    'lapis_lazuli' = @{ Ore = 'lapis'; Shape = 'shard'; Glyph = $glyphs.lapis }
    'diamond' = @{ Ore = 'diamond'; Shape = 'gem'; Glyph = $glyphs.diamond }
    'emerald' = @{ Ore = 'emerald'; Shape = 'gem'; Glyph = $glyphs.emerald }
    'quartz' = @{ Ore = 'quartz'; Shape = 'shard'; Glyph = $glyphs.quartz }
    'gold_nugget' = @{ Ore = 'gold'; Shape = 'nugget'; Glyph = $glyphs.gold }
}

$hostPalettes = [ordered] @{
    'subtle' = @{
        'stone' = @([Drawing.Color]::FromArgb(255, 88, 91, 94), [Drawing.Color]::FromArgb(255, 112, 116, 119), [Drawing.Color]::FromArgb(255, 137, 141, 144))
        'deepslate' = @([Drawing.Color]::FromArgb(255, 43, 47, 51), [Drawing.Color]::FromArgb(255, 62, 66, 70), [Drawing.Color]::FromArgb(255, 82, 86, 90))
        'netherrack' = @([Drawing.Color]::FromArgb(255, 91, 47, 43), [Drawing.Color]::FromArgb(255, 114, 57, 52), [Drawing.Color]::FromArgb(255, 139, 70, 64))
    }
    'clear' = @{
        'stone' = @([Drawing.Color]::FromArgb(255, 65, 68, 72), [Drawing.Color]::FromArgb(255, 104, 108, 112), [Drawing.Color]::FromArgb(255, 145, 149, 153))
        'deepslate' = @([Drawing.Color]::FromArgb(255, 25, 28, 32), [Drawing.Color]::FromArgb(255, 55, 59, 64), [Drawing.Color]::FromArgb(255, 90, 95, 100))
        'netherrack' = @([Drawing.Color]::FromArgb(255, 70, 28, 27), [Drawing.Color]::FromArgb(255, 109, 42, 39), [Drawing.Color]::FromArgb(255, 153, 61, 55))
    }
    'monochrome' = @{
        'stone' = @([Drawing.Color]::FromArgb(255, 45, 45, 45), [Drawing.Color]::FromArgb(255, 90, 90, 90), [Drawing.Color]::FromArgb(255, 145, 145, 145))
        'deepslate' = @([Drawing.Color]::FromArgb(255, 10, 10, 10), [Drawing.Color]::FromArgb(255, 45, 45, 45), [Drawing.Color]::FromArgb(255, 80, 80, 80))
        'netherrack' = @([Drawing.Color]::FromArgb(255, 35, 35, 35), [Drawing.Color]::FromArgb(255, 75, 75, 75), [Drawing.Color]::FromArgb(255, 120, 120, 120))
    }
}

$orePalettes = [ordered] @{
    'subtle' = @{
        'coal' = @([Drawing.Color]::FromArgb(255, 54, 56, 58), [Drawing.Color]::FromArgb(255, 82, 84, 86)); 'iron' = @([Drawing.Color]::FromArgb(255, 151, 140, 127), [Drawing.Color]::FromArgb(255, 183, 169, 150)); 'copper' = @([Drawing.Color]::FromArgb(255, 144, 91, 67), [Drawing.Color]::FromArgb(255, 188, 126, 91)); 'gold' = @([Drawing.Color]::FromArgb(255, 174, 143, 54), [Drawing.Color]::FromArgb(255, 218, 185, 75)); 'redstone' = @([Drawing.Color]::FromArgb(255, 128, 49, 43), [Drawing.Color]::FromArgb(255, 178, 65, 55)); 'lapis' = @([Drawing.Color]::FromArgb(255, 48, 74, 131), [Drawing.Color]::FromArgb(255, 69, 102, 174)); 'diamond' = @([Drawing.Color]::FromArgb(255, 71, 143, 142), [Drawing.Color]::FromArgb(255, 106, 188, 184)); 'emerald' = @([Drawing.Color]::FromArgb(255, 55, 137, 76), [Drawing.Color]::FromArgb(255, 76, 181, 99)); 'quartz' = @([Drawing.Color]::FromArgb(255, 174, 156, 145), [Drawing.Color]::FromArgb(255, 218, 202, 188))
    }
    'clear' = @{
        'coal' = @([Drawing.Color]::FromArgb(255, 15, 16, 18), [Drawing.Color]::FromArgb(255, 53, 55, 58)); 'iron' = @([Drawing.Color]::FromArgb(255, 183, 171, 158), [Drawing.Color]::FromArgb(255, 235, 224, 210)); 'copper' = @([Drawing.Color]::FromArgb(255, 151, 73, 44), [Drawing.Color]::FromArgb(255, 235, 137, 82)); 'gold' = @([Drawing.Color]::FromArgb(255, 190, 139, 18), [Drawing.Color]::FromArgb(255, 255, 221, 55)); 'redstone' = @([Drawing.Color]::FromArgb(255, 125, 15, 18), [Drawing.Color]::FromArgb(255, 235, 48, 44)); 'lapis' = @([Drawing.Color]::FromArgb(255, 29, 55, 133), [Drawing.Color]::FromArgb(255, 77, 126, 240)); 'diamond' = @([Drawing.Color]::FromArgb(255, 38, 139, 145), [Drawing.Color]::FromArgb(255, 108, 238, 231)); 'emerald' = @([Drawing.Color]::FromArgb(255, 24, 130, 55), [Drawing.Color]::FromArgb(255, 77, 235, 112)); 'quartz' = @([Drawing.Color]::FromArgb(255, 168, 145, 132), [Drawing.Color]::FromArgb(255, 255, 238, 218))
    }
    'monochrome' = @{
        'coal' = @([Drawing.Color]::FromArgb(255, 0, 0, 0), [Drawing.Color]::FromArgb(255, 35, 35, 35)); 'iron' = @([Drawing.Color]::FromArgb(255, 185, 185, 185), [Drawing.Color]::FromArgb(255, 255, 255, 255)); 'copper' = @([Drawing.Color]::FromArgb(255, 120, 120, 120), [Drawing.Color]::FromArgb(255, 235, 235, 235)); 'gold' = @([Drawing.Color]::FromArgb(255, 165, 165, 165), [Drawing.Color]::FromArgb(255, 250, 250, 250)); 'redstone' = @([Drawing.Color]::FromArgb(255, 25, 25, 25), [Drawing.Color]::FromArgb(255, 210, 210, 210)); 'lapis' = @([Drawing.Color]::FromArgb(255, 70, 70, 70), [Drawing.Color]::FromArgb(255, 200, 200, 200)); 'diamond' = @([Drawing.Color]::FromArgb(255, 145, 145, 145), [Drawing.Color]::FromArgb(255, 255, 255, 255)); 'emerald' = @([Drawing.Color]::FromArgb(255, 95, 95, 95), [Drawing.Color]::FromArgb(255, 230, 230, 230)); 'quartz' = @([Drawing.Color]::FromArgb(255, 190, 190, 190), [Drawing.Color]::FromArgb(255, 255, 255, 255))
    }
}

$fixedPalettes = [ordered] @{
    'subtle' = @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 105, 110, 113); '1' = [Drawing.Color]::FromArgb(255, 121, 126, 129); '2' = [Drawing.Color]::FromArgb(255, 138, 143, 146); '3' = [Drawing.Color]::FromArgb(255, 158, 162, 164) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 77, 77, 79); '1' = [Drawing.Color]::FromArgb(255, 94, 93, 95); '2' = [Drawing.Color]::FromArgb(255, 116, 114, 115); '3' = [Drawing.Color]::FromArgb(255, 139, 137, 137); '4' = [Drawing.Color]::FromArgb(255, 160, 158, 157) }
    }
    'clear' = @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 83, 88, 91); '1' = [Drawing.Color]::FromArgb(255, 111, 116, 119); '2' = [Drawing.Color]::FromArgb(255, 142, 147, 150); '3' = [Drawing.Color]::FromArgb(255, 178, 182, 184) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 55, 55, 57); '1' = [Drawing.Color]::FromArgb(255, 83, 82, 84); '2' = [Drawing.Color]::FromArgb(255, 119, 117, 118); '3' = [Drawing.Color]::FromArgb(255, 159, 157, 157); '4' = [Drawing.Color]::FromArgb(255, 200, 198, 197) }
    }
    'monochrome' = @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 45, 45, 45); '1' = [Drawing.Color]::FromArgb(255, 80, 80, 80); '2' = [Drawing.Color]::FromArgb(255, 140, 140, 140); '3' = [Drawing.Color]::FromArgb(255, 210, 210, 210) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 20, 20, 20); '1' = [Drawing.Color]::FromArgb(255, 60, 60, 60); '2' = [Drawing.Color]::FromArgb(255, 115, 115, 115); '3' = [Drawing.Color]::FromArgb(255, 180, 180, 180); '4' = [Drawing.Color]::FromArgb(255, 240, 240, 240) }
    }
}

$legacyOrePalettes = [ordered] @{
    'subtle' = @{
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 92, 94, 96); '1' = [Drawing.Color]::FromArgb(255, 108, 110, 112); '2' = [Drawing.Color]::FromArgb(255, 126, 128, 130); '3' = [Drawing.Color]::FromArgb(255, 151, 140, 127); '4' = [Drawing.Color]::FromArgb(255, 183, 169, 150) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 65, 67, 69); '1' = [Drawing.Color]::FromArgb(255, 76, 78, 80); '2' = [Drawing.Color]::FromArgb(255, 97, 99, 101); '3' = [Drawing.Color]::FromArgb(255, 116, 119, 121); '4' = [Drawing.Color]::FromArgb(255, 133, 135, 137) }
    }
    'clear' = @{
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 75, 78, 80); '1' = [Drawing.Color]::FromArgb(255, 105, 108, 110); '2' = [Drawing.Color]::FromArgb(255, 133, 136, 138); '3' = [Drawing.Color]::FromArgb(255, 183, 171, 158); '4' = [Drawing.Color]::FromArgb(255, 235, 224, 210) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 24, 25, 27); '1' = [Drawing.Color]::FromArgb(255, 48, 50, 52); '2' = [Drawing.Color]::FromArgb(255, 91, 94, 96); '3' = [Drawing.Color]::FromArgb(255, 126, 129, 131); '4' = [Drawing.Color]::FromArgb(255, 154, 156, 158) }
    }
    'monochrome' = @{
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 55, 55, 55); '1' = [Drawing.Color]::FromArgb(255, 90, 90, 90); '2' = [Drawing.Color]::FromArgb(255, 125, 125, 125); '3' = [Drawing.Color]::FromArgb(255, 200, 200, 200); '4' = [Drawing.Color]::FromArgb(255, 255, 255, 255) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 5, 5, 5); '1' = [Drawing.Color]::FromArgb(255, 20, 20, 20); '2' = [Drawing.Color]::FromArgb(255, 90, 90, 90); '3' = [Drawing.Color]::FromArgb(255, 150, 150, 150); '4' = [Drawing.Color]::FromArgb(255, 210, 210, 210) }
    }
}

foreach ($profile in $hostPalettes.Keys) {
    foreach ($textureName in $blockSpecs.Keys) {
        $spec = $blockSpecs[$textureName]
        if ($spec.Kind -eq 'fixed') { $palette = $fixedPalettes[$profile][$textureName] }
        elseif ($spec.Kind -eq 'legacy') { $palette = $legacyOrePalettes[$profile][$textureName] }
        else {
            $hostColors = $hostPalettes[$profile][$spec.Host]
            $ore = $orePalettes[$profile][$spec.Ore]
            $palette = @{ '0' = $hostColors[0]; '1' = $hostColors[1]; '2' = $hostColors[2]; '3' = $ore[0]; '4' = $ore[1] }
        }
        New-Texture -Profile $profile -Category block -Name $textureName -Rows $spec.Rows -Palette $palette
    }

    foreach ($itemName in $itemSpecs.Keys) {
        $spec = $itemSpecs[$itemName]
        $ore = $orePalettes[$profile][$spec.Ore]
        $palette = @{ '.' = [Drawing.Color]::Transparent; '3' = $ore[0]; '4' = $ore[1] }
        $rows = New-ItemRows -Shape $spec.Shape -Glyph $spec.Glyph
        New-Texture -Profile $profile -Category item -Name $itemName -Rows $rows -Palette $palette
    }
}
