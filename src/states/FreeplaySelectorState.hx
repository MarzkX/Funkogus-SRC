package states;

import flixel.effects.FlxFlicker;

typedef SelectorData = {
    weeks:Array<Array<String>>
}

class FreeplaySelectorState extends MusicBeatState
{
    public static var weeks:Array<Array<String>> = [
		["test"],
		["week1we"],
		["test"],
        ["test"],
        ["test"]
	];

    var optionShit:Array<String> = [
        'Chapter 1',
        'Chapter 2',
        'Chapter 3',
        'Bonus',
        'Covers'
    ];

    var itemY1:FlxPoint = new FlxPoint(325, 300);
    var itemY2:FlxPoint = new FlxPoint(825, 800);

    public static var curSelected:Int = 0;
    static var selectUp:Bool = true;

    var menuItems:FlxSpriteGroup;
    var menuTexts:FlxSpriteGroup;
    var itemTween:FlxTween;
    var textTween:FlxTween;

    var arrowPoint:FlxPoint = new FlxPoint((FlxG.width/2)-75, FlxG.height - (45 + 30));
    var arrowPointPress:FlxPoint = new FlxPoint((FlxG.width/2)-125, FlxG.height - (95 + 30));

    var arrowGrp:FlxSpriteGroup;
    var arrowTween:FlxTween;

    var jsonFile:SelectorData;
 
    override function create()
    {
        try
        {
            jsonFile = Json.parse(Paths.getTextFromFile('data/freeplaySelect.json'));
            weeks = jsonFile.weeks;
        }
        catch(e)
        {
            logOpen('$e');
            trace('lol: $e');
        }

        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.screenCenter();
        bg.updateHitbox();
        bg.scrollFactor.set();
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        bg.color = 0x4F75A7;
        add(bg);

        menuItems = new FlxSpriteGroup();
        add(menuItems);

        menuTexts = new FlxSpriteGroup();
        add(menuTexts);

        for(i in 0...weeks.length)
        {
            var offset:Float = 25 - (Math.max(weeks.length, 4) - 4) * 75;
            var offsetTxt:Float = 25 - (Math.max(optionShit.length, 4) - 4) * 75;

            var menuText:FlxText = new FlxText(0, 0, FlxG.width, optionShit[i], 16);
            menuText.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            menuText.ID = i;

            var menuItem:FlxSprite = FlxSpriteUtil.drawRoundRect(new FlxSprite().makeGraphic(Math.floor(FlxG.width/3.2), 75, FlxColor.TRANSPARENT), 0, 0, Math.floor(FlxG.width/3.2), 75, 15, 15);
            menuItem.ID = i;

            for(j in 0...weeks.length-2)
            {
                for(u in weeks.length-2...weeks.length)
                {
                    if(menuItem.ID == j) {
                        menuText.x = (i * 405) + offsetTxt - 350;
                        menuText.y = itemY1.x;
                        menuItem.x = (i * 405) + offset + 92.5;
                        menuItem.y = itemY1.y;
                    }
                    if(menuItem.ID == u) {
                        menuText.x = (i * 405) + offsetTxt - 1375;
                        menuText.y = itemY2.x;
                        menuItem.x = (i * 405) + offset - 925;
                        menuItem.y = itemY2.y;
                    }
                }
            }
    
            menuItems.add(menuItem);
            menuTexts.add(menuText);

            trace('iy: ${menuItems.y} ty: ${menuTexts.y}');
        }

        arrowGrp = new FlxSpriteGroup(0, -150);
        add(arrowGrp);

        var arrow:FlxSprite = new FlxSprite();
        arrow.frames = Paths.getSparrowAtlas('NOTE_assets');
        arrow.animation.addByPrefix('up','green0',24,false);
        arrow.animation.addByPrefix('down','blue0',24,false);
        arrow.x = arrowPoint.x;
        arrow.y = arrowPoint.y;
        arrow.antialiasing = ClientPrefs.globalAntialiasing;

        var pressA:FlxSprite = new FlxSprite();
        pressA.frames = Paths.getSparrowAtlas('NOTE_assets');
        pressA.animation.addByPrefix('up','up confirm',24,false);
        pressA.animation.addByPrefix('down','down confirm',24,false);
        pressA.x = arrowPointPress.x;
        pressA.y = arrowPointPress.y;
        pressA.visible = false;
        pressA.antialiasing = ClientPrefs.globalAntialiasing;

        arrowGrp.add(arrow);
        arrowGrp.add(pressA);

        changeItem();
        changeSelection(true);

        super.create();
    }

    var select:Bool = false;

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

        if(!select)
        {
            if(controls.BACK)
            {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                select = true;
                MusicBeatState.switchState(new MainMenuState());
            }

            if(controls.ACCEPT)
            {
                enterItem();
            }

            if(controls.UI_LEFT_P) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
                changeItem(-1);
            }
            if(controls.UI_RIGHT_P) {
                FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);
                changeItem(1);
            }

            if(controls.UI_UP_P) {
                changeSelection();
            }

            if(controls.UI_DOWN_P) {
                changeSelection();
            }
        }

        if(arrowGrp.members[1].animation != null && arrowGrp.members[1].animation.finished)
        {
            arrowGrp.members[1].visible = false;
            arrowGrp.members[0].visible = true;
        }

        super.update(elapsed);
    }

    function changeSelection(?starting:Bool = false)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.7);

        if(!starting)
            selectUp = !selectUp;
        
        if(selectUp) {
            if(textTween != null)
                textTween.cancel();

            if(itemTween != null)
                itemTween.cancel();

            if(arrowTween != null)
                arrowTween.cancel();

            textTween = FlxTween.tween(menuTexts, {y: 0}, 0.4, {ease: FlxEase.quadOut});
            itemTween = FlxTween.tween(menuItems, {y: 0}, 0.4, {ease: FlxEase.quadOut});

            arrowTween = FlxTween.tween(arrowGrp, {y: -150}, 0.4, {ease: FlxEase.quadOut});

            if(!starting)
            {
                arrowGrp.members[1].visible = true;
                arrowGrp.members[0].visible = false;
                arrowGrp.members[1].animation.play('up');
            }
            arrowGrp.members[0].animation.play('down');
            
            changeItem();
        } else {
            if(textTween != null)
                textTween.cancel();

            if(itemTween != null)
                itemTween.cancel();

            if(arrowTween != null)
                arrowTween.cancel();

            textTween = FlxTween.tween(menuTexts, {y: -500}, 0.4, {ease: FlxEase.quadOut});
            itemTween = FlxTween.tween(menuItems, {y: -500}, 0.4, {ease: FlxEase.quadOut});

            arrowTween = FlxTween.tween(arrowGrp, {y: -575}, 0.4, {ease: FlxEase.quadOut});

            if(!starting)
            {
                arrowGrp.members[1].visible = true;
                arrowGrp.members[0].visible = false;
                arrowGrp.members[1].animation.play('down');
            }
            arrowGrp.members[0].animation.play('up');

            changeItem(3);
        }
    }

    function enterItem()
    {
        FlxG.sound.play(Paths.sound('confirmMenu'));
        select = true;

        menuTexts.forEach(function(spr:FlxSprite)
        {
            if(spr.ID != curSelected)
                FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
            else
                if(ClientPrefs.flashing) FlxFlicker.flicker(spr, 1, 0.06, false, false);
        });

        menuItems.forEach(function(spr:FlxSprite)
        {
            if(spr.ID != curSelected)
            {
                FlxTween.tween(spr, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
            }
            else
            {
                if(ClientPrefs.flashing) FlxFlicker.flicker(spr, 1, 0.06, false, false);

                new FlxTimer().start(1, function(t:FlxTimer)
                {
                    MusicBeatState.switchState(new FreeplayState(weeks[curSelected]));
                    t = null;
                });
            }
        });
    }

    function changeItem(num:Int = 0)
    {
        curSelected += num;

		if(selectUp)
        {
            if (curSelected >= weeks.length-2)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = weeks.length - 3;
        }
        else
        {
            if (curSelected >= weeks.length)
                curSelected = weeks.length - 2;
            if (curSelected < weeks.length-2)
                curSelected = weeks.length-1;
        }

        menuItems.forEach(function(spr:FlxSprite)
        {
            spr.alpha = 0.6;
            spr.color = 0x000000;

            if(spr.ID == curSelected)
            {
                spr.alpha = 1;
                spr.color = 0xFFFFFF;
            }
        });

        trace('$curSelected');
    }
}