$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$outputDirectory = Join-Path $PSScriptRoot '..\src\main\resources\assets\minecraft\textures\block'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

function New-Texture {
    param(
        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [string[]] $Rows,

        [Parameter(Mandatory)]
        [hashtable] $Palette
    )

    if ($Rows.Count -ne 16 -or ($Rows | Where-Object Length -ne 16)) {
        throw "$Name must contain exactly 16 rows with 16 pixels each."
    }

    $bitmap = [System.Drawing.Bitmap]::new(16, 16, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        for ($y = 0; $y -lt 16; $y++) {
            for ($x = 0; $x -lt 16; $x++) {
                $symbol = [string] $Rows[$y][$x]
                if (-not $Palette.ContainsKey($symbol)) {
                    throw "Unknown palette symbol '$symbol' in $Name at $x,$y."
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

$andesitePalette = @{
    '0' = [System.Drawing.Color]::FromArgb(255, 83, 88, 91)
    '1' = [System.Drawing.Color]::FromArgb(255, 111, 116, 119)
    '2' = [System.Drawing.Color]::FromArgb(255, 142, 147, 150)
    '3' = [System.Drawing.Color]::FromArgb(255, 178, 182, 184)
}

New-Texture -Name 'andesite' -Palette $andesitePalette -Rows @(
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

$gravelPalette = @{
    '0' = [System.Drawing.Color]::FromArgb(255, 55, 55, 57)
    '1' = [System.Drawing.Color]::FromArgb(255, 83, 82, 84)
    '2' = [System.Drawing.Color]::FromArgb(255, 119, 117, 118)
    '3' = [System.Drawing.Color]::FromArgb(255, 159, 157, 157)
    '4' = [System.Drawing.Color]::FromArgb(255, 200, 198, 197)
}

New-Texture -Name 'gravel' -Palette $gravelPalette -Rows @(
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

$ironPalette = @{
    '0' = [System.Drawing.Color]::FromArgb(255, 75, 78, 80)
    '1' = [System.Drawing.Color]::FromArgb(255, 105, 108, 110)
    '2' = [System.Drawing.Color]::FromArgb(255, 133, 136, 138)
    '3' = [System.Drawing.Color]::FromArgb(255, 183, 171, 158)
    '4' = [System.Drawing.Color]::FromArgb(255, 235, 224, 210)
}

New-Texture -Name 'iron_ore' -Palette $ironPalette -Rows @(
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

$coalPalette = @{
    '0' = [System.Drawing.Color]::FromArgb(255, 24, 25, 27)
    '1' = [System.Drawing.Color]::FromArgb(255, 48, 50, 52)
    '2' = [System.Drawing.Color]::FromArgb(255, 91, 94, 96)
    '3' = [System.Drawing.Color]::FromArgb(255, 126, 129, 131)
    '4' = [System.Drawing.Color]::FromArgb(255, 154, 156, 158)
}

New-Texture -Name 'coal_ore' -Palette $coalPalette -Rows @(
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
