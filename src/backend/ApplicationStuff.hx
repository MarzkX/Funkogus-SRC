package backend;

import openfl.Lib;

class ApplicationStuff
{
	//All variables
	private static var windowTween:FlxTween;

	//Functions
	#if windows
	public static function obtainRAM():Int
	{
		return WindowsData.obtainRAM();
	}

	public static function darkMode()
	{
		WindowsData.setWindowColorMode(DARK);
	}

	public static function lightMode()
	{
		WindowsData.setWindowColorMode(LIGHT);
	}

	public static function setWindowOppacity(a:Float)
	{
		WindowsData.setWindowAlpha(a);
	}

	public static function _setWindowLayered()
	{
		WindowsData._setWindowLayered();
	}
	#end

	#if sys
    public static function restart(?thisResetScore:Bool = false)
	{
		var os = Sys.systemName();
		var args = "Test.hx";
		var app = "";
		var workingdir = Sys.getCwd();

		app = Sys.programPath();

		if(!thisResetScore)
			ClientPrefs.saveSettings();

		// Launch application:
		var result = systools.win.Tools.createProcess(app // app. path
			, args // app. args
			, workingdir // app. working directory
			, false // do not hide the window
			, false // do not wait for the application to terminate
		);
		// Show result:
		if (result == 0)
			Sys.exit(1337);
		else
			throw "Failed to restart bich";
    }
	#end

	public static function exit()
    {
		#if sys
        Sys.exit(0);
		#else
		flash.system.System.exit(0);
		#end
    }

	public static function size(Width:Int, Height:Int)
	{
		FlxG.resizeWindow(Width, Height);
		FlxG.resizeGame(Width, Height);
	}

	public static function title(t:String)
	{
		if(ClientPrefs.appText)
			Lib.application.window.title = Main.appTitle + ' - ' + t;
		else
			Lib.application.window.title = Main.appTitle;
	}

	public static function tween(Position:Array<Int>, Time:Float, Ease:String)
	{
		if(windowTween != null) {
			windowTween.cancel();
		}

		windowTween = FlxTween.tween(Lib.application.window, 
			{x: Position[0], y: Position[1]}, 
			Time, {ease: Reflect.field(FlxEase, Ease),
			onComplete: function(t:FlxTween)
			{
				t = null;
			}
		});
	}
}