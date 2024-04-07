package states;

class GalleryState extends MusicBeatState
{
    override function create():Void
    {
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.screenCenter();
        bg.updateHitbox();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.color = 0x8B4FA7;
        add(bg);

        super.create();
    }

    var selected:Bool = false;

    override function update(elapsed:Float)
    {
        if(!selected)
        {
            if(controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
                selected = true;
            }
        }
        
        super.update(elapsed);
    }
}