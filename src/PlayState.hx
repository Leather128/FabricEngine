package;

import flixel.FlxG;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();

		var bg_reg:FlxSprite = new FlxSprite().loadGraphic(BitmapData.fromFile(sys.FileSystem.absolutePath(AssetPaths.asset("images/menuBG.png"))));
		bg_reg.setGraphicSize(640);
		bg_reg.updateHitbox();
		add(bg_reg);

		var bg_desat:FlxSprite = new FlxSprite().loadGraphic(BitmapData.fromFile(sys.FileSystem.absolutePath(AssetPaths.asset("images/menuDesat.png"))));
		bg_desat.setGraphicSize(640);
		bg_desat.updateHitbox();
		bg_desat.x = FlxG.width - bg_desat.width;
		add(bg_desat);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
