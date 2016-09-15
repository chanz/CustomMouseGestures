//register the hook
public static void WindowInitialized(Window window)
{
    IntPtr handle = (new WindowInteropHelper(window)).Handle;
    var hwndSource = HwndSource.FromHwnd(handle);
    if (hwndSource != null) 
    {
        hwndSource.AddHook(WindowProc);
    }
}

//the important bit
private static IntPtr WindowProc(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled)
{
    switch (msg)
    {
        case 0x0046: //WINDOWPOSCHANGING
            var winPos = (WINDOWPOS)Marshal.PtrToStructure(lParam, typeof(WINDOWPOS));
            var monitorInfo = new MONITORINFO();
            IntPtr monitorContainingApplication = MonitorFromWindow(hwnd, MonitorDefaultToNearest);
            GetMonitorInfo(monitorContainingApplication, monitorInfo);
            RECT rcWorkArea = monitorInfo.rcWork;
            //check for a framechange - but ignore initial draw. x,y is top left of current monitor so must be a maximise
            if (((winPos.flags & SWP_FRAMECHANGED) == SWP_FRAMECHANGED) && (winPos.flags & SWP_NOSIZE) != SWP_NOSIZE && winPos.x == rcWorkArea.left && winPos.y == rcWorkArea.top)
            {
                //set max size to the size of the *current* monitor
                var width = Math.Abs(rcWorkArea.right - rcWorkArea.left);
                var height = Math.Abs(rcWorkArea.bottom - rcWorkArea.top);
                winPos.cx = width;
                winPos.cy = height;
                Marshal.StructureToPtr(winPos, lParam, true);
                handled = true;
            }                       
            break;
    }
    return (IntPtr)0;
}


//all the helpers for dealing with this COM crap
[DllImport("user32")]
internal static extern bool GetMonitorInfo(IntPtr hMonitor, MONITORINFO lpmi);

[DllImport("user32")]
internal static extern IntPtr MonitorFromWindow(IntPtr handle, int flags);

private const int MonitorDefaultToNearest = 0x00000002;

[StructLayout(LayoutKind.Sequential)]
public struct WINDOWPOS
{
    public IntPtr hwnd;
    public IntPtr hwndInsertAfter;
    public int x;
    public int y;
    public int cx;
    public int cy;
    public int flags;
}

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
public class MONITORINFO
{
    public int cbSize = Marshal.SizeOf(typeof(MONITORINFO));
    public RECT rcMonitor;
    public RECT rcWork;
    public int dwFlags;
}

[StructLayout(LayoutKind.Sequential, Pack = 0)]
public struct RECT
{
    public int left;
    public int top;
    public int right;
    public int bottom;
}