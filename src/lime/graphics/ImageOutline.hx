package lime.graphics;

import openfl.display.*;
import openfl.geom.*;

using StringTools;

class ImageOutline
{
    /**
	 * antialias, alias and parseARGB settings. 
	 * 0 - alpha, 1 - brush, 2 - hex
	 */
	static var util_settings:Array<Dynamic> = [1.0, 4.0, ""];
    
    private static var _color:UInt;
    private static var _weight:Float = 2;
    private static var m:Matrix;

    public static function renderImage(Source:IBitmapDrawable, Weight:Int, Color:UInt, Alpha:Float = 1, Antialiasing:Bool = false, Threshold:Int = 150):Bitmap
    {
        var w:Int = 0;
        var h:Int = 0;

        if(Std.is(Source, DisplayObject))
        {
            var dsp:DisplayObject = cast(Source, DisplayObject);
            m = dsp.transform.matrix;
            w = Std.int(dsp.width);
            h = Std.int(dsp.height);
        }
        else if(Std.is(Source, BitmapData))
        {
            var bmp:BitmapData = cast(Source, BitmapData);
            w = Std.int(bmp.width);
            h = Std.int(bmp.height);
        }

        var render:BitmapData = new BitmapData(w, h, true, 0x000000);
        render.draw(Source, m);

        return new Bitmap(outline(render, Weight, Color, Alpha, Antialiasing, Threshold));
    }

    public static function outline(Source:BitmapData, Weight:Int, Color:UInt, Alpha:Float = 1, Antialiasing:Bool = false, Threshold:Int = 150):BitmapData
    {
        _color = Color;
        _weight = Weight;
        util_settings[0] = Alpha;
        util_settings[1] = (Weight * 2) + 1;
        util_settings[2] = toHexString(Color);

        var copy:BitmapData = new BitmapData(Std.int(Source.width + util_settings[1]), 
            Std.int(Source.height + util_settings[1]), true, 0x00000000);

        for (iy in 0...Source.height)
        {
            for (ix in 0...Source.width)
            {
                var a:Float = (Source.getPixel32(ix, iy) >> 24 & 0xFF);

                if(Antialiasing)
                {
                    antialias(copy, ix, iy, Std.int(a));
                }
                else if (a > Threshold)
                {
                    alias(copy, ix, iy);
                }
            }
        }

        copy.copyPixels(Source, new Rectangle(0, 0, copy.width, copy.height), new Point(_weight, _weight), null, null, true);
        return copy;
    }

	/**
	* Renders a antialiasing mode... idk
	*/
	public static function antialias(copy:BitmapData, x:Int, y:Int, a:Int):BitmapData
	{
		if (a > 0)
		{
			for (iy in y...Std.int(y + util_settings[1]))
			{
				for (ix in x...Std.int(x + util_settings[1]))
				{
					var px:Float = (copy.getPixel32(ix, iy) >> 24 & 0xFF);
					if(px < (a * util_settings[0]))
						copy.setPixel32(ix, iy, parseARGB(Std.int(a * util_settings[0])));
				}
			}
		}
		return copy;
	}

	/** 
	* Renders a alias...hmm	
	*/
	public static function alias(copy:BitmapData, x:Int, y:Int):BitmapData
	{
		copy.fillRect(new Rectangle(x, y, util_settings[1], util_settings[1]), parseARGB(Std.int(util_settings[0] * 255)));
		return copy;
	}

	/**
	* idk...hmm...rgb
	*/
	public static function parseARGB(intNum:Int):UInt
	{
		return Std.parseInt("0x" + StringTools.hex(intNum) + util_settings[2]);
	}

	public static function toHexString(hex:UInt):String
	{
		var r:Int = (hex >> 16);
		var g:Int = (hex >> 8 ^ r << 8);
		var b:Int = (hex ^ (r << 16 | g << 0));

		var red:String = StringTools.hex(r);
		var green:String = StringTools.hex(g);
		var blue:String = StringTools.hex(b);

		red = (red.length < 2) ? "0" + red : red;
		green = (green.length < 2) ? "0" + green : green;
		blue = (blue.length < 2) ? "0" + blue : blue;
		return (red + green + blue).toUpperCase();
	}
}