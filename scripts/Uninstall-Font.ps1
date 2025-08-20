## Function: Uninstall Sys Font
function Uninstall-SysFont {
    <#
      Removes TrueType / OpenType fonts that were installed using Install-SysFont.

      EXAMPLE
      -------
      Uninstall-SysFont "Some-Font.ttf"
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,
                   Position = 0,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [Alias('Path')]
        [string[]]$FontFileName
    )

    begin {
        if (-not ([Type]::GetType('FontApi.Native'))) {
$src = @"
using System;
using System.Runtime.InteropServices;

namespace FontApi
{
    public static class Native
    {
        [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
        public static extern bool RemoveFontResourceExW(
           string lpFileName, uint fl, IntPtr pdv);

        [DllImport("user32.dll")]
        public static extern int SendMessageW(
           IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    }
}
"@
            Add-Type -TypeDefinition $src | Out-Null
        }

        $FR_PRIVATE     = 0x10
        $WM_FONTCHANGE  = 0x001D
        $HWND_BROADCAST = [IntPtr]0xFFFF

        $FontsDir   = Join-Path $env:WINDIR 'Fonts'
        $RegPath    = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'

        if (-not ([Security.Principal.WindowsPrincipal] `
                  [Security.Principal.WindowsIdentity]::GetCurrent()
                 ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
            throw 'Uninstall-SysFont must run elevated (Run PowerShell as admin or deploy as SYSTEM).'
        }
    }

    process {
        foreach ($item in $FontFileName) {

            $leaf     = Split-Path $item -Leaf
            $fontPath = Join-Path $FontsDir $leaf

            if (-not (Test-Path $fontPath)) {
                Write-Warning "Font file not found: $leaf"
                continue
            }

            if ($PSCmdlet.ShouldProcess($leaf, 'Uninstall system font')) {

                [FontApi.Native]::RemoveFontResourceExW($fontPath, $FR_PRIVATE, [IntPtr]::Zero) | Out-Null
                [FontApi.Native]::RemoveFontResourceExW($fontPath, 0,           [IntPtr]::Zero) | Out-Null

                try {
                    $props = Get-ItemProperty -Path $RegPath
                    $props.PSObject.Properties |
                        Where-Object { $_.Value -ieq $leaf } |
                        ForEach-Object {
                            Remove-ItemProperty -Path $RegPath -Name $_.Name -Force
                            Write-Verbose "Removed registry entry: $($_.Name)"
                        }
                } catch {
                    Write-Warning "Registry cleanup failed for $leaf : $_"
                }

                try {
                    Remove-Item -LiteralPath $fontPath -Force
                    Write-Verbose "Deleted file: $leaf"
                } catch {
                    Write-Warning "Failed to delete $leaf : $_"
                }
            }
        }
    }

    end {
        # broadcast font
        [FontApi.Native]::SendMessageW($HWND_BROADCAST,
                                       $WM_FONTCHANGE,
                                       [IntPtr]::Zero,
                                       [IntPtr]::Zero) | Out-Null
    }
}