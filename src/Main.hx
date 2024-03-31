package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

//crash handler stuff
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

using StringTools;

class Main extends Sprite
{
	var gameData = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		state: TitleState, // initial game state
		zoom: -1.0, // game state bounds
		fps: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false, // if the game should start at fullscreen mode
		autoPaused: true // if game focus out, autopause on/off?
	};

	var game:FlxGame;
	var focusMusicTween:FlxTween;

	public static var fpsVar:FPS;
	public static var instance:Main;
	public static var appTitle:String = 'Funkogus';

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		instance = this;

		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (gameData.zoom == -1)
		{
			var ratioX:Float = stageWidth / gameData.width;
			var ratioY:Float = stageHeight / gameData.height;
			gameData.zoom = Math.min(ratioX, ratioY);
			gameData.width = Math.ceil(stageWidth / gameData.zoom);
			gameData.height = Math.ceil(stageHeight / gameData.zoom);
		}
	
		ClientPrefs.loadDefaultKeys();

		game = new FlxGame(gameData.width, 
			gameData.height, 
			gameData.state, 
			gameData.zoom, 
			gameData.fps, 
			gameData.fps, 
			gameData.skipSplash, 
			gameData.startFullscreen
		);

		addChild(game);

		#if !mobile
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#end

		#if html5
		FlxG.mouse.visible = false;
		#end
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		FlxG.autoPause = gameData.autoPaused;

		#if desktop
		if(!gameData.autoPaused)
		{
			Lib.application.window.onFocusOut.add(onWindowFocusOut);
			Lib.application.window.onFocusIn.add(onWindowFocusIn);
		}
		#end
	}

	var oldVol:Float = 1.0;
	var newVol:Float = 0.3;

	public static var focused:Bool = true;

	// thx for ur code ari
	function onWindowFocusOut()
	{
		focused = false;

		// Lower global volume when unfocused
		oldVol = FlxG.sound.volume;
		if (oldVol > 0.3)
		{
			newVol = 0.3;
		}
		else
		{
			if (oldVol > 0.1)
			{
				newVol = 0.1;
			}
			else
			{
				newVol = 0;
			}
		}

		trace("Game unfocused");

		if (focusMusicTween != null)
			focusMusicTween.cancel();
		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: newVol}, 0.5);

		// Conserve power by lowering draw framerate when unfocuced
		FlxG.drawFramerate = 20;
	}

	function onWindowFocusIn()
	{
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
		{
			focused = true;
		});

		// Lower global volume when unfocused
		trace("Game focused");

		// Normal global volume when focused
		if (focusMusicTween != null)
			focusMusicTween.cancel();

		focusMusicTween = FlxTween.tween(FlxG.sound, {volume: oldVol}, 0.5);

		// Bring framerate back when focused
		FlxG.drawFramerate = ClientPrefs.framerate;
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var errMsg:String = "";
		var path:String;
		var callStack = callStack;

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		var	appName:String = "Funkogus.exe";
		var dateNow:String = Date.now().toString();
		var parentPath = Sys.programPath().substr(0, Sys.programPath().length-appName.length);
		var cmd = "cd/D "+parentPath+" && FlixelCrashHandler.exe -"+errMsg+" -"+parentPath+" -"+appName;
		Sys.command(cmd);
		Sys.println("FOR LOXA " + cmd);

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crashlogs/" + "Funkogus_" + dateNow + ".txt";

		if (!FileSystem.exists("./crashlogs/"))
			FileSystem.createDirectory("./crashlogs/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		DiscordClient.shutdown();
		Sys.exit(-1);
	}
	#end
}
