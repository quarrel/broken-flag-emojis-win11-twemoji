Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

namespace FontApi {
    public static class Native {
        [DllImport("user32.dll")]
        public static extern int SendMessageW(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    }
}
"@

$WM_FONTCHANGE = 0x001D
$HWND_BROADCAST = [IntPtr]0xFFFF
[void][FontApi.Native]::SendMessageW($HWND_BROADCAST, $WM_FONTCHANGE, [IntPtr]::Zero, [IntPtr]::Zero)