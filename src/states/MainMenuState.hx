package states;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = [
		'freeplay',
		'story_mode',
		'options',
		'credits',
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'gallery'
	];

	var magenta:FlxSprite;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, 0);
		bg.setGraphicSize(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, 0);
		magenta.setGraphicSize(FlxG.width, FlxG.height);
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x85FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		grid.scrollFactor.set(0, 0);
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.75;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...2)
		{
			for (j in 3...optionShit.length)
			{
				var offset:Float = 25 - (Math.max(3, 4) - 4) * 75;
				var menuItem1:FlxSprite = new FlxSprite((i * 380)  + offset, 0);
				menuItem1.scale.x = scale;
				menuItem1.scale.y = scale;
				menuItem1.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem1.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
				menuItem1.animation.addByPrefix('selected', optionShit[i] + " white", 24);
				menuItem1.animation.play('idle');
				menuItem1.ID = i;
				menuItem1.screenCenter(Y);
				menuItem1.scrollFactor.set(0, 0);
				menuItem1.antialiasing = ClientPrefs.globalAntialiasing;
				menuItem1.updateHitbox();
				menuItems.add(menuItem1);

				var menuItem2:FlxSprite = new FlxSprite(FlxG.width - 380, 0);
				menuItem2.scale.x = scale;
				menuItem2.scale.y = scale;
				menuItem2.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[2]);
				menuItem2.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
				menuItem2.animation.addByPrefix('selected', optionShit[2] + " white", 24);
				menuItem2.animation.play('idle');
				menuItem2.ID = 2;
				menuItem2.screenCenter(Y);
				menuItem2.scrollFactor.set(0, 0);
				menuItem2.antialiasing = ClientPrefs.globalAntialiasing;
				menuItem2.updateHitbox();
				menuItems.add(menuItem2);

				var offset1:Float = 25 - (Math.max(6, 4) - 4) * 25;
				var menuItem3:FlxSprite = new FlxSprite((j * 415)  + offset1 - 1175, 0);
				menuItem3.scale.x = scale;
				menuItem3.scale.y = scale;
				menuItem3.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[j]);
				menuItem3.animation.addByPrefix('idle', optionShit[j] + " basic", 24);
				menuItem3.animation.addByPrefix('selected', optionShit[j] + " white", 24);
				menuItem3.animation.play('idle');
				menuItem3.ID = j;
				menuItem3.screenCenter(Y);
				menuItem3.y += 150;
				menuItem3.scrollFactor.set(0, 0);
				menuItem3.antialiasing = ClientPrefs.globalAntialiasing;
				menuItem3.updateHitbox();
				menuItems.add(menuItem3);
			}
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine (modified) v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + openfl.Lib.application.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						if(ClientPrefs.flashing) FlxFlicker.flicker(spr, 1, 0.06, false, false);
						
						new FlxTimer().start(1, function(t:FlxTimer)
						{
							enterItem();
							t = null;
						});
					}
				});
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		/*menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(Y);
		});*/
	}

	function enterItem()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story_mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
				LoadingState.loadAndSwitchState(new FreeplaySelectorState());
			case 'awards':
				MusicBeatState.switchState(new AchievementsMenuState());
			case 'gallery':
				MusicBeatState.switchState(new GalleryState());
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
			case 'options':
				LoadingState.loadAndSwitchState(new OptionsState());
		}
	}

	function changeItem(huh:Int = 1)
	{
		curSelected += huh;

		if (curSelected >= optionShit.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = optionShit.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
			}
		});
	}
}
