package openfl.display;

import openfl.display.Bitmap;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

import lime.graphics.ImageOutline;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(lime.graphics.ImageOutline)

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):UInt;

	public var bitmap:Bitmap;

	var peak:UInt = 0;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font('cambria.ttc'), 14, color);
		text = "";
		width += 200;

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end

		bitmap = ImageOutline.renderImage(this, 1, 0x000000, 1, true);
		(cast(Lib.current.getChildAt(0), Main)).addChild(bitmap);
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount)/2);

		var mem:Dynamic;

		if (currentCount != cacheCount)
		{
			if(ClientPrefs.showMEM)
			{
				mem = System.totalMemory;
				if (mem > peak)
					peak = mem;
			}

			text = (ClientPrefs.showFPS ? 'FPS: $currentFPS' + 
			    (ClientPrefs.showMEM ? '\nMEM: ' + getSizeLabel(System.totalMemory) + '\nMEM Peak: ${getSizeLabel(peak)}' : '') 
				: (ClientPrefs.showMEM ? 'MEM: ' + getSizeLabel(System.totalMemory) + '\nMEM Peak: ${getSizeLabel(peak)}' : ''));
		}

		visible = true;

		Main.instance.removeChild(bitmap);

		bitmap = ImageOutline.renderImage(this, 2, 0x000000, ClientPrefs.fpsAlpha);
		Main.instance.addChild(bitmap);

		alpha = ClientPrefs.fpsAlpha;

		visible = false;

		cacheCount = currentCount;
	}

	final dataTexts = ["B", "KB", "MB", "GB", "TB", "PB"];

	function getSizeLabel(num:UInt):String
	{
		var size:Float = num;
		var data = 0;
		while (size > 1024 && data < dataTexts.length - 1)
		{
			data++;
			size = size / 1024;
		}

		size = Math.round(size * 100) / 100;

		if (data <= 2)
			size = Math.round(size);

		return size + " " + dataTexts[data];
	}
}