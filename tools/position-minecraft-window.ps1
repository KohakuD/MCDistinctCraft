param(
    [int] $TimeoutSeconds = 120
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class DistinctCraftWindowPlacement
{
    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MoveWindow(
        IntPtr window,
        int x,
        int y,
        int width,
        int height,
        bool repaint);
}
'@

$deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
$minecraftProcess = $null

while ([DateTime]::UtcNow -lt $deadline) {
    $minecraftProcess = Get-Process -Name 'java', 'javaw' -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -like '*Minecraft*' } |
        Sort-Object StartTime -Descending |
        Select-Object -First 1

    if ($null -ne $minecraftProcess) {
        break
    }

    Start-Sleep -Milliseconds 250
}

if ($null -eq $minecraftProcess) {
    exit 0
}

# Minecraft may resize its window during the last startup steps. Reapply the
# placement briefly so the final window still occupies the intended area.
for ($attempt = 0; $attempt -lt 20; $attempt++) {
    $minecraftProcess.Refresh()
    if ($minecraftProcess.MainWindowHandle -eq 0) {
        break
    }

    $workingArea = [System.Windows.Forms.Screen]::FromHandle($minecraftProcess.MainWindowHandle).WorkingArea
    $targetWidth = [Math]::Floor($workingArea.Width * 2 / 3)
    [DistinctCraftWindowPlacement]::MoveWindow(
        $minecraftProcess.MainWindowHandle,
        $workingArea.Left,
        $workingArea.Top,
        $targetWidth,
        $workingArea.Height,
        $true) | Out-Null

    Start-Sleep -Milliseconds 250
}
