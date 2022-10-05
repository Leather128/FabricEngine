package;

import flixel.FlxGame;
import openfl.display.Sprite;

/**
	The main class that starts our program.
**/
class Main extends Sprite
{
	/**
		The current `openfl.display.FPS` being used (only shown on desktop platforms).
	**/
	public static var fps_counter:openfl.display.FPS;
	
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, PlayState));

		fps_counter = new openfl.display.FPS(10, 3, 0xFFFFFFFF);
		#if desktop
		addChild(fps_counter);
		#end
	}
}
