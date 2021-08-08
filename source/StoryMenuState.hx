package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var wimpmode:Bool = false;
	var scoreText:FlxText;

	var weekData:Array<Dynamic> = [
		['Life Will Change', 'Take Over', 'Dance'],
		['Mantis Lords', 'Hornet'],
		['Cammy', 'Boxer', 'Blanka', 'Claw', 'Alex'],
		['Vitality'],
		['Main Menu', 'Tick Tock Clock', 'Waluigi Pinball'],
		['Running in the Nineties', 'Ram Ranch', 'Hell'],
		['Fist Bump'],
		['Gritzy Desert', 'Popple and Rookie', 'In The Final']
	];
	var curDifficulty:Int = 2;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['kitten', 'bf', 'gf'],
		['alm', 'bf', 'gf'],
		['b0llet', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['duo', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
	];

	var babymode:FlxText;

	var weekEnemy:Array<Array<String>> = [
		['kitten'],
		['alm'],
		['b0llet'],
		['delta'],
		['kitten', '&', 'b0llet'],
		['chantley'],
		['cuttle'],
		['niels']
	];

	var diffHeight:Float;

	var nameColors:Array<Array<Array<Int>>> = [
		[
			[0x00000000, 0xFFffa200]
		],
		[
			[0x00000000, 0xFF48ff00]
		],
		[
			[0x00000000, 0xFF7f1f8a]
		],
		[
			[0x00000000, 0xFFa43139]
		],
		[
			[0x00000000, 0xFFffa200],
			[0x00000000, 0xFFA80600],
			[0x00000000, 0xFF7f1f8a]
		],
		[
			[0x00000000, 0xFF0099FF]
		],
		[
			[0x00000000, 0xFFfffb00]
		],
		[
			[0x00000000, 0xFF2DABB5]
		],
	];

	var weekNames:Array<String> = [
		"Average Persona Fan",
		"German Twat",
		"Gremlin",
		"Horny",
		"Karting Kombo",
		"I'm sorry for your fingers",
		"Sondic :)",
		"M&L",
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup = new FlxGroup();
	var txtName:Array<FlxText> = [];

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
				FlxG.sound.playMusic(Paths.music('menutest'));
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			trace(weekData[i]);

			weekThing.setSize(1000, 500);
			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.18, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.15, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.20, true));

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		diffHeight = grpWeekText.members[0].y + 10;

		trace(curWeek);
		trace(nameColors);
		trace(nameColors[curWeek]);
		addText(weekEnemy[curWeek], nameColors[curWeek]);
		// txtName = new FlxText(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10, 400, weekEnemy[curWeek], 50);
		// txtName.setFormat(Paths.font("tf2build.ttf"), 50, 0xFFe55777, CENTER);
		// txtName.borderStyle = OUTLINE;
		// txtName.borderSize = 5;
		// txtName.borderQuality = 3;
		// txtName.borderColor = nameColors[curWeek][1];
		// txtName.color = nameColors[curWeek][0];
		// difficultySelectors.add(txtName);

		// leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		// leftArrow.frames = ui_tex;
		// leftArrow.animation.addByPrefix('idle', "arrow left");
		// leftArrow.animation.addByPrefix('press', "arrow push left");
		// leftArrow.animation.play('idle');
		// difficultySelectors.add(leftArrow);

		// sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		// sprDifficulty.frames = ui_tex;
		// sprDifficulty.animation.addByPrefix('easy', 'EASY');
		// sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		// sprDifficulty.animation.addByPrefix('hard', 'HARD');
		// sprDifficulty.animation.play('easy');
		// changeDifficulty();

		// difficultySelectors.add(sprDifficulty);

		// rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		// rightArrow.frames = ui_tex;
		// rightArrow.animation.addByPrefix('idle', 'arrow right');
		// rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		// rightArrow.animation.play('idle');
		// difficultySelectors.add(rightArrow);

		trace("Line 150");

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		txtTracklist.scale.x *= 0.85;
		txtTracklist.scale.y *= 0.85;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		trace("Line 165");

		super.create();
	}

	function resetText()
	{
		txtName = [];
		difficultySelectors.clear();
	}
	
	function addText(text: Array<String>, colors)
	{
		var i = 0;
		for (name in text)
		{
			var name = new FlxText((grpWeekText.members[0].x + 5) + grpWeekText.members[0].width + 10, diffHeight + (55 * i), 400, name, 50);
			name.setFormat(Paths.font("tf2build.ttf"), 65, 0xFFe55777, CENTER);
			name.borderStyle = OUTLINE;
			name.antialiasing = true;
			name.borderSize = 5;
			name.borderQuality = 5;
			name.borderColor = colors[i][1];
			name.color = colors[i][0];
			txtName.push(name);
			difficultySelectors.add(name);
			i++;
		}
		i = 3;
		var text = "no-fail disabled, press left or right to enable";
		trace(wimpmode);
		if (wimpmode) {
			text = "no-fail enabled, press left or right to disable";
		}
		var name = new FlxText((grpWeekText.members[0].x + 5) + grpWeekText.members[0].width + 10, diffHeight + (65 * i), 400, text, 10);
		name.setFormat(Paths.font("tf2build.ttf"), 20, FlxColor.WHITE, CENTER);
		name.borderStyle = OUTLINE;
		name.antialiasing = true;
		name.borderSize = 2;
		name.borderQuality = 2;
		name.borderColor = 0xFF872726;
		name.color = FlxColor.WHITE;
		txtName.push(name);
		difficultySelectors.add(name);
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
				{
					changeWeek(-1);
				}

				if (controls.DOWN_P)
				{
					changeWeek(1);
				}

				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic = "";

			switch (curDifficulty)
			{
				case 0:
					diffic = '-easy';
				case 2:
					diffic = '-hard';
			}

			PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				var playstate = new PlayState();
				playstate.cannotDie = wimpmode;
				LoadingState.loadAndSwitchState(playstate, true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		wimpmode = !wimpmode;
		resetText();
		addText(weekEnemy[curWeek], nameColors[curWeek]);
		// if (curDifficulty < 0)
		// 	curDifficulty = 2;
		// if (curDifficulty > 2)
		// 	curDifficulty = 0;

		// sprDifficulty.offset.x = 0;

		// switch (curDifficulty)
		// {
		// 	case 0:
		// 		sprDifficulty.animation.play('easy');
		// 		sprDifficulty.offset.x = 20;
		// 	case 1:
		// 		sprDifficulty.animation.play('normal');
		// 		sprDifficulty.offset.x = 70;
		// 	case 2:
		// 		sprDifficulty.animation.play('hard');
		// 		sprDifficulty.offset.x = 20;
		// }

		// sprDifficulty.alpha = 0;

		// // USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		// sprDifficulty.y = leftArrow.y - 15;
		// intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		// #if !switch
		// intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		// #end

		// FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData.length - 1;

		var bullShit:Int = 0;
		resetText();
		addText(weekEnemy[curWeek], nameColors[curWeek]);
		// txtName.text = weekEnemy[curWeek];
		// txtName.borderColor = nameColors[curWeek][1];
		// txtName.color = nameColors[curWeek][0];

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekCharacters[curWeek][0]);
		grpWeekCharacters.members[1].setCharacter(weekCharacters[curWeek][1]);
		grpWeekCharacters.members[2].setCharacter(weekCharacters[curWeek][2]);

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData[curWeek];

		for (i in stringThing)
		{
			txtTracklist.text += "\n" + i;
		}

		txtTracklist.text += "\n";
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}
}
