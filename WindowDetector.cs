//credits to
//Microsoft Copilot b/c I really don't know C#
//https://stackoverflow.com/questions/5878963/getting-active-window-coordinates-and-height-width-in-c-sharp

using Godot;
using System;
using System.Runtime.InteropServices; //contains dll files

public partial class WindowDetector : Node
{
	[DllImport("user32.dll")] //imports the following function
	private static extern bool SetProcessDPIAware();

	[DllImport("user32.dll")] //imports the following function
	private static extern IntPtr GetForegroundWindow();

	[DllImport("user32.dll")] //imports the following function
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
	//function is GetWindowRect, not GetWindowsRect
	
	//define the data type here
	[StructLayout(LayoutKind.Sequential)]
	public struct RECT
	{
		public int Left; // upper-left x position
		public int Top; //upper-left y position
		public int Right; //lower-right x position
		public int Bottom; //lower-right y position
	}
	
	
	// active window getting function
	//private IntPtr GetActiveWindow()
	//{
	//	IntPtr handle = IntPtr.Zero;
	//	return GetForegroundWindow();
	//}
	
	// window to two opposite corners function
	
	//define a new custom signal
	[Signal]
	public delegate void ForegroundWindowEventHandler(int x1, int y1, int x2, int y2);
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		SetProcessDPIAware();
		GD.Print("WindowDetector ready."); //sure CoPilot . . .
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		//Rectangle t2; //bad, literally the wrong data type
		//GetWindowRect(GetForegroundWindow(), out t2);
		
		RECT rect;
		IntPtr hwnd = GetForegroundWindow();
		if (hwnd != IntPtr.Zero) //if the window exists
		{
			if (GetWindowRect(hwnd, out rect))
			{
				//I'll prob. have to change this into emitting a signal
				//GD.Print($"Foreground Window Rect: Left={rect.Left}, Top={rect.Top}, Right={rect.Right}, bottom={rect.Bottom}");
				GD.Print("Foreground window detected.");
				EmitSignal(SignalName.ForegroundWindow, rect.Left, rect.Top, rect.Right, rect.Bottom);
			}
			else
			{
				GD.Print("Failed to get window rectangle.");
			}
		}
		else
		{
			GD.Print("No foreground window detected.");
		}
	}
	
}
