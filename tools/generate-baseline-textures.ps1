$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$resourcePackRoot = Join-Path $PSScriptRoot '..\src\main\resources\resourcepacks'

function New-Texture {
    param(
        [Parameter(Mandatory)] [string] $Profile,
        [Parameter(Mandatory)] [string] $Name,
        [Parameter(Mandatory)] [string[]] $Rows,
        [Parameter(Mandatory)] [hashtable] $Palette
    )

    if ($Rows.Count -ne 16 -or ($Rows | Where-Object Length -ne 16)) {
        throw "$Profile/$Name must contain exactly 16 rows with 16 pixels each."
    }

    $outputDirectory = Join-Path $resourcePackRoot "$Profile\assets\minecraft\textures\block"
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
    $bitmap = [System.Drawing.Bitmap]::new(16, 16, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        for ($y = 0; $y -lt 16; $y++) {
            for ($x = 0; $x -lt 16; $x++) {
                $symbol = [string] $Rows[$y][$x]
                if (-not $Palette.ContainsKey($symbol)) {
                    throw "Unknown palette symbol '$symbol' in $Profile/$Name at $x,$y."
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

$textureRows = [ordered] @{
    'andesite' = @(
        '1100112222110011'
        '1122331111223311'
        '0011110033111100'
        '2233221111002233'
        '1111002211110011'
        '0011223333221100'
        '3311110011112233'
        '1122001111220011'
        '0011332211113300'
        '2211110011112233'
        '1100221111002211'
        '0033111122331100'
        '3311112200111133'
        '1122001111330011'
        '0011223311112200'
        '2211110011221133'
    )
    'gravel' = @(
        '1120001110022211'
        '1203401100233321'
        '0033300012333200'
        '0112000012200011'
        '0222101100012210'
        '0233211000123320'
        '0022100111233200'
        '1100012330022001'
        '1000123430012311'
        '0011233210023320'
        '0123320011002200'
        '0012200122100011'
        '1100012333210122'
        '0220123443201233'
        '0330012332000221'
        '1120012210112001'
    )
    'iron_ore' = @(
        '1122110011221100'
        '1234411122112211'
        '1340012211001122'
        '1340112244411221'
        '1233112340012211'
        '1122111340011122'
        '2211221343312211'
        '1100111233110044'
        '2211221100111140'
        '1144412211233340'
        '1140011121340033'
        '1240012211340011'
        '1233311121233311'
        '1122112234411221'
        '2211221134012112'
        '1100112233311221'
    )
    'coal_ore' = @(
        '2233224422332244'
        '2303223322443322'
        '3000322433224433'
        '2303223302243322'
        '2233223000322244'
        '3322442303224433'
        '2244332233223322'
        '4422333322443000'
        '2233224422334300'
        '3322443000323430'
        '2244332303223322'
        '4433223000322233'
        '3322444303443322'
        '2244333000322244'
        '4433224303443322'
        '3322442233224433'
    )
}

$profilePalettes = [ordered] @{
    'subtle' = [ordered] @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 105, 110, 113); '1' = [Drawing.Color]::FromArgb(255, 121, 126, 129); '2' = [Drawing.Color]::FromArgb(255, 138, 143, 146); '3' = [Drawing.Color]::FromArgb(255, 158, 162, 164) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 77, 77, 79); '1' = [Drawing.Color]::FromArgb(255, 94, 93, 95); '2' = [Drawing.Color]::FromArgb(255, 116, 114, 115); '3' = [Drawing.Color]::FromArgb(255, 139, 137, 137); '4' = [Drawing.Color]::FromArgb(255, 160, 158, 157) }
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 92, 94, 96); '1' = [Drawing.Color]::FromArgb(255, 108, 110, 112); '2' = [Drawing.Color]::FromArgb(255, 126, 128, 130); '3' = [Drawing.Color]::FromArgb(255, 151, 140, 127); '4' = [Drawing.Color]::FromArgb(255, 183, 169, 150) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 65, 67, 69); '1' = [Drawing.Color]::FromArgb(255, 76, 78, 80); '2' = [Drawing.Color]::FromArgb(255, 97, 99, 101); '3' = [Drawing.Color]::FromArgb(255, 116, 119, 121); '4' = [Drawing.Color]::FromArgb(255, 133, 135, 137) }
    }
    'clear' = [ordered] @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 83, 88, 91); '1' = [Drawing.Color]::FromArgb(255, 111, 116, 119); '2' = [Drawing.Color]::FromArgb(255, 142, 147, 150); '3' = [Drawing.Color]::FromArgb(255, 178, 182, 184) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 55, 55, 57); '1' = [Drawing.Color]::FromArgb(255, 83, 82, 84); '2' = [Drawing.Color]::FromArgb(255, 119, 117, 118); '3' = [Drawing.Color]::FromArgb(255, 159, 157, 157); '4' = [Drawing.Color]::FromArgb(255, 200, 198, 197) }
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 75, 78, 80); '1' = [Drawing.Color]::FromArgb(255, 105, 108, 110); '2' = [Drawing.Color]::FromArgb(255, 133, 136, 138); '3' = [Drawing.Color]::FromArgb(255, 183, 171, 158); '4' = [Drawing.Color]::FromArgb(255, 235, 224, 210) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 24, 25, 27); '1' = [Drawing.Color]::FromArgb(255, 48, 50, 52); '2' = [Drawing.Color]::FromArgb(255, 91, 94, 96); '3' = [Drawing.Color]::FromArgb(255, 126, 129, 131); '4' = [Drawing.Color]::FromArgb(255, 154, 156, 158) }
    }
    'monochrome' = [ordered] @{
        'andesite' = @{ '0' = [Drawing.Color]::FromArgb(255, 45, 45, 45); '1' = [Drawing.Color]::FromArgb(255, 80, 80, 80); '2' = [Drawing.Color]::FromArgb(255, 140, 140, 140); '3' = [Drawing.Color]::FromArgb(255, 210, 210, 210) }
        'gravel' = @{ '0' = [Drawing.Color]::FromArgb(255, 20, 20, 20); '1' = [Drawing.Color]::FromArgb(255, 60, 60, 60); '2' = [Drawing.Color]::FromArgb(255, 115, 115, 115); '3' = [Drawing.Color]::FromArgb(255, 180, 180, 180); '4' = [Drawing.Color]::FromArgb(255, 240, 240, 240) }
        'iron_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 55, 55, 55); '1' = [Drawing.Color]::FromArgb(255, 90, 90, 90); '2' = [Drawing.Color]::FromArgb(255, 125, 125, 125); '3' = [Drawing.Color]::FromArgb(255, 200, 200, 200); '4' = [Drawing.Color]::FromArgb(255, 255, 255, 255) }
        'coal_ore' = @{ '0' = [Drawing.Color]::FromArgb(255, 5, 5, 5); '1' = [Drawing.Color]::FromArgb(255, 20, 20, 20); '2' = [Drawing.Color]::FromArgb(255, 90, 90, 90); '3' = [Drawing.Color]::FromArgb(255, 150, 150, 150); '4' = [Drawing.Color]::FromArgb(255, 210, 210, 210) }
    }
}

foreach ($profile in $profilePalettes.Keys) {
    foreach ($texture in $textureRows.Keys) {
        New-Texture -Profile $profile -Name $texture -Rows $textureRows[$texture] -Palette $profilePalettes[$profile][$texture]
    }
}
