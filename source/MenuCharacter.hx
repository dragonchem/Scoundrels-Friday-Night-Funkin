package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'bf' => new CharacterSetting(10, 0, 4.8, true),
		'gf' => new CharacterSetting(80, 230, 3, true),
		'dad' => new CharacterSetting(140, 220),
		'spooky' => new CharacterSetting(20, 30),
		'pico' => new CharacterSetting(0, 0, 1.0, true),
		'mom' => new CharacterSetting(-30, 140, 0.85),
		'parents-christmas' => new CharacterSetting(100, 130, 1.8),
		'senpai' => new CharacterSetting(-40, -45, 1.4),
		'kitten' => new CharacterSetting(-30, 300, 2),
		'b0llet' => new CharacterSetting(120, 260, 5),
		'alm' => new CharacterSetting(20, 320, 2.2),
		'duo' => new CharacterSetting(40, 350, 2.8),
		'cuttle' => new CharacterSetting(20, 300, 2.4),
		'chantley' => new CharacterSetting(20, 300, 2.4),
		'scoundrel' => new CharacterSetting(60, 260, 3.4),
		'kingofshells' => new CharacterSetting(20, 340, 1.8)
	];

	private var flipped:Bool = false;

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = true;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('bf', "BF idle dance white", 24);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('gf', "GF Dancing Beat WHITE", 24);
		animation.addByPrefix('dad', "Dad idle dance BLACK LINE", 24);
		animation.addByPrefix('spooky', "spooky dance idle BLACK LINES", 24);
		animation.addByPrefix('pico', "Pico Idle Dance", 24);
		animation.addByPrefix('mom', "Mom Idle BLACK LINES", 24);
		animation.addByPrefix('parents-christmas', "Parent Christmas Idle", 24);
		animation.addByPrefix('senpai', "SENPAI idle Black Lines", 24);
		animation.addByPrefix('kitten', "Kitten", 24);
		animation.addByPrefix('b0llet', "B0llet", 24);
		animation.addByPrefix('alm', "Alm", 24);
		animation.addByPrefix('duo', "Duo", 24);
		animation.addByPrefix('cuttle', "Cuttle", 24);
		animation.addByPrefix('chantley', "Chantley", 24);
		animation.addByPrefix('scoundrel', "Scoundrel", 24);
		animation.addByPrefix('kingofshells', "KOS", 24);

		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}

		trace(character);

		animation.play(character);

		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}
