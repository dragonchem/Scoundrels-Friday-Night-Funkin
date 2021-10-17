package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
import Random;

class Credits extends MusicBeatState
{
	private var grpControls:FlxTypedGroup<Alphabet>;
    private var credits:Array<Credit> = new Array<Credit>();
	var curSelected:Int = 1;
	public var versionShit:Alphabet;
    var name = "You";

	var txtEnter:FlxText;
	var blackBorder:FlxSprite;
    var bQuestion = false;
    override function create()
    {
        #if cpp
        var envs = Sys.environment();
        
	    if (envs.exists("USERNAME"))
        {
            name =  envs["USERNAME"];
        }
        else if (envs.exists("USER")) {
            name =  envs["USER"];
        }
        #end

        credits.push(new Credit('a mod by', false, '', ''));
        credits.push(new Credit('The Scoundrels', true, 'https://www.youtube.com/channel/UCUjZlboApDksiecwzbiKomQ', 'Scoundrels YouTube channel'));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('code and animation by', false, '', ''));
        credits.push(new Credit('TheLazyKitten', true, 'https://www.youtube.com/channel/UCzvcYe9Km0VZy9SAtZlNCdg', "TheLazyKitten's YouTube channel"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('art assets by', false, '', ''));
        credits.push(new Credit('KingOfShells', true, 'https://twitter.com/kingofshells', "KingOfShells's Twitter"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('art references', false, '', ''));
        credits.push(new Credit('BOllet', true, 'https://www.youtube.com/channel/UCX6ts-wfdL1eNWySIgZZeUQ', "B0llet's YouTube channel"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('maps and music by', false, '', ''));
        credits.push(new Credit('TheLazyKitten', true, 'https://www.youtube.com/channel/UCzvcYe9Km0VZy9SAtZlNCdg', "TheLazyKitten's YouTube channel"));
        credits.push(new Credit('BOllet', true, 'https://www.youtube.com/channel/UCX6ts-wfdL1eNWySIgZZeUQ', "B0llet's YouTube channel"));
        credits.push(new Credit('Alm', true, '', 'no link.'));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('icon by', false, '', ''));
        credits.push(new Credit('Mrtoni', true, 'https://twitter.com/murtoni_98', "Mrtoni's Twitter"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('kade engine by', false, '', ''));
        credits.push(new Credit('KadeDev', true, 'https://twitter.com/kadedeveloper', "KadeDev's Twitter"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('special thanks', false, '', ''));
        credits.push(new Credit('NyxTheShield (various tools)', true, 'https://twitter.com/nyxtheshield', "NyxTheShield's Twitter"));
        credits.push(new Credit('Thee Apple in yer Snapple (idea)', true, 'https://twitter.com/TheeSnApple', "Thee Apple in yer Snapple's Twitter"));
        credits.push(new Credit('', false, '', ''));
        credits.push(new Credit('and', false, '', ''));
        credits.push(new Credit(name, true, 'https://www.youtube.com/watch?v=pkKf0fR9b0A', '???'));
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuDesat"));

        menuBG.color = 0xFFea71fd;
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);

        grpControls = new FlxTypedGroup<Alphabet>();
        add(grpControls);

		txtEnter = new FlxText(30, FlxG.height - 40, 0, "Press ENTER to open link ", 32);
		txtEnter.scrollFactor.set();
		txtEnter.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		blackBorder = new FlxSprite(-30,FlxG.height - 42).makeGraphic((Std.int(FlxG.width + 30)),Std.int(txtEnter.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.75;

		add(blackBorder);

        add(txtEnter);

        for (i in 0...credits.length)
        {
            var controlLabel:Alphabet = new Alphabet(0, credits[i].getClickable()? (70 * i) + 30 : (70 * i), credits[i].getName(), !credits[i].getClickable(), false);
            controlLabel.isMenuItem = true;
            controlLabel.targetY = i;
            controlLabel.credit = !credits[i].getClickable();
            grpControls.add(controlLabel);
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
                if (credit.getUrl() != '') {
                    #if linux
                    Sys.command('/usr/bin/xdg-open', [credit.getUrl(), "&"]);
                    #else
                    FlxG.openURL(credit.getUrl());
                    #end
                }
            }
        }
        if (bQuestion) {
            txtEnter.text = "Press ENTER to open link - " + Random.string(36);
        }
        FlxG.save.flush();
    }

    function changeSelection(change:Int = 0)
    {
        #if !switch
        // NGio.logEvent("Fresh");
        #end

        curSelected += change;

        if (curSelected < 0)
            curSelected = grpControls.length - 1;
        if (curSelected >= grpControls.length)
            curSelected = 0;

        if (!credits[curSelected].getClickable()) {
            changeSelection(change);
        }
        else if (change != 0) {
            FlxG.sound.play(Paths.sound("scrollMenu"), 0.2);
        }

        // selector.y = (70 * curSelected) + 30;

        // if (credits[curSelected].getUrl() == '') {
        //     txtEnter.text = "no link";
        // }
        if (credits[curSelected].getDesc() == '???') {
            bQuestion = true;
        }
        else {
            bQuestion = false;
            txtEnter.text = "Press ENTER to open link ";
    
            if (credits[curSelected].getDesc() != '') {
                txtEnter.text += "- " + credits[curSelected].getDesc();
            }
        }

        var bullShit:Int = 0;

        for (item in grpControls.members)
        {
            item.targetY = bullShit - curSelected;
            bullShit++;

            item.alpha = 0.6;
            // item.setGraphicSize(Std.int(item.width * 0.8));

            if (item.targetY == 0 || item.credit)
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
    private var description: String = "";

    public function new(_name: String, _clickable: Bool, _url: String, _desc: String)
    {
		super();
        name = _name;
        clickable = _clickable;
        url = _url;
        description = _desc;
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

    public final function getDesc(): String
    {
        return description;
    }
}