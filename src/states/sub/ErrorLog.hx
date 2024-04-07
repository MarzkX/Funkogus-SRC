package states.sub;

class ErrorLog extends MusicBeatSubstate
{
    var errorName:String;
    var sprGroup:FlxSpriteGroup;

    public function new(name:String)
    {
        errorName = name;

        sprGroup = new FlxSpriteGroup();
        add(sprGroup);

        var bg:FlxSprite = new FlxSprite().makeGraphic(7000, 7000, 0xA1000000);
        bg.scrollFactor.set(0, 0);
        bg.screenCenter();
        sprGroup.add(bg);

        var text:FlxText = new FlxText(0, 0, FlxG.width, 'Oh! Error:\n$errorName', 16);
        text.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.scrollFactor.set(0, 0);
        text.screenCenter();
        sprGroup.add(text);
        
        sprGroup.forEach(function(spr:FlxSprite)
        {
            spr.alpha = 0;
            FlxTween.tween(spr, {alpha: 1}, 0.2, {ease: FlxEase.cubeOut});
        });

        new FlxTimer().start(2, function(t:FlxTimer)
        {
            t = null;
            
            sprGroup.forEach(function(spr:FlxSprite)
            {
                FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
            });
        });

        super();
    }

    override function create()
    {
        super.create();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}