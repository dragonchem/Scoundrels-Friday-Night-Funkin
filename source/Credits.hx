package;

import flixel.FlxBasic;
import flixel.effects.FlxFlicker;
import flixel.FlxObject;
import openfl.Lib;
import Options;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class Credits extends MusicBeatState
{
	private var grpControls:FlxTypedGroup<Alphabet>;
    private var credits:Array<Credit> = new Array<Credit>();
	var curSelected:Int = 1;
    override function create()
    {
        credits.push(new Credit('a mod by', false, ''));
        credits.push(new Credit('The Scoundrels', true, 'https://www.youtube.com/channel/UCUjZlboApDksiecwzbiKomQ'));
        credits.push(new Credit('', false, ''));
        credits.push(new Credit('programmed by', false, ''));
        credits.push(new Credit('TheLazyKitten', true, 'https://www.youtube.com/channel/UCzvcYe9Km0VZy9SAtZlNCdg'));
        credits.push(new Credit('', false, ''));
        credits.push(new Credit('art by', false, ''));
        credits.push(new Credit('KingOfShells', true, 'https://twitter.com/kingofshells'));
        credits.push(new Credit('', false, ''));
        credits.push(new Credit('maps and music by', false, ''));
        credits.push(new Credit('TheLazyKitten', true, 'https://www.youtube.com/channel/UCzvcYe9Km0VZy9SAtZlNCdg'));
        credits.push(new Credit('BOllet', true, 'https://www.youtube.com/channel/UCX6ts-wfdL1eNWySIgZZeUQ'));
        credits.push(new Credit('DeltaUnknown', true, 'https://www.youtube.com/channel/UCfRBw20j2mWn_QSREv7ngjg'));
        credits.push(new Credit('Alm', true, 'https://www.youtube.com/channel/UCr9Ertq8EjBoAjTYwdwTAWQ'));
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

        menuBG.color = 0xFFea71fd;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);

        grpControls = new FlxTypedGroup<Alphabet>();
        add(grpControls);

        for (i in 0...credits.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, credits[i].getClickable()? (70 * i) + 30 : (70 * i), credits[i].getName(), !credits[i].getClickable(), false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            grpControls.add(controlLabel);
            trace(controlLabel);
        }

        super.create();
        changeSelection(0);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.BACK)
            FlxG.switchState(new MainMenuState());
        if (controls.UP_P)
            changeSelection(-1);
        if (controls.DOWN_P)
            changeSelection(1);
        if (controls.ACCEPT) {
            var credit: Credit = credits[curSelected];
            if (credit.getClickable()) {
                #if linux
                Sys.command('/usr/bin/xdg-open', [credit.getUrl(), "&"]);
                #else
                FlxG.openURL(credit.getUrl());
                #end
            }
        }
        FlxG.save.flush();
    }

    function changeSelection(change:Int = 0)
    {
        #if !switch
        // NGio.logEvent("Fresh");
        #end
        
        FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

        curSelected += change;

        if (curSelected < 0)
            curSelected = grpControls.length - 1;
        if (curSelected >= grpControls.length)
            curSelected = 0;

        trace(credits[curSelected].getName());

        if (!credits[curSelected].getClickable()) {
            changeSelection(change);
        }

        // selector.y = (70 * curSelected) + 30;

        var bullShit:Int = 0;

        for (item in grpControls.members)
        {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;
            // item.setGraphicSize(Std.int(item.width * 0.8));

            if (item.targetY == 0)
            {
                item.alpha = 1;
                // item.setGraphicSize(Std.int(item.width));
            }
        }
    }
}

class Credit extends FlxBasic
{
    private var name: String = "";
    private var clickable: Bool = false;
    private var url: String = "";

    public function new(_name: String, _clickable: Bool, _url: String)
    {
		super();
        name = _name;
        clickable = _clickable;
        url = _url;
    }

    public final function getName(): String
    {
        return name;
    }

    public final function getClickable(): Bool
    {
        return clickable;
    }

    public final function getUrl(): String
    {
        return url;
    }
}