Add-Type -AssemblyName System.Drawing
$projectRoot = Split-Path $PSScriptRoot -Parent
[xml]$svg = Get-Content (Join-Path $projectRoot 'web/favicon.svg') -Raw
$segments = [regex]::Matches($svg.svg.path.d, 'M32 32\s+(\d+)\s+(\d+)')
if ($segments.Count -ne 8) { throw 'Expected eight rays in the SewaSkill SVG.' }

function Write-LogoIcon([string]$relativePath, [int]$size, [double]$scale, [bool]$opaque) {
    $bitmap = [System.Drawing.Bitmap]::new($size, $size)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    if ($opaque) { $graphics.Clear([System.Drawing.Color]::White) }
    $padding = $size * (1 - $scale) / 2
    $graphics.TranslateTransform($padding, $padding)
    $graphics.ScaleTransform($size * $scale / 64, $size * $scale / 64)
    $pen = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($svg.svg.path.stroke), [single]$svg.svg.path.'stroke-width')
    foreach ($segment in $segments) {
        $graphics.DrawLine($pen, [single]32, [single]32, [single]$segment.Groups[1].Value, [single]$segment.Groups[2].Value)
    }
    $bitmap.Save((Join-Path $projectRoot $relativePath), [System.Drawing.Imaging.ImageFormat]::Png)
    $pen.Dispose()
    $graphics.Dispose()
    $bitmap.Dispose()
}

Write-LogoIcon 'web/favicon.png' 64 1 $false
foreach ($size in @(192, 512)) {
    Write-LogoIcon "web/icons/Icon-$size.png" $size 0.72 $true
    Write-LogoIcon "web/icons/Icon-maskable-$size.png" $size 0.64 $true
}
foreach ($entry in @(@('mdpi',48), @('hdpi',72), @('xhdpi',96), @('xxhdpi',144), @('xxxhdpi',192))) {
    Write-LogoIcon "android/app/src/main/res/mipmap-$($entry[0])/ic_launcher.png" $entry[1] 0.72 $true
}
Write-Output 'Updated web and Android icons from web/favicon.svg.'
