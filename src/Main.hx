package;

import openfl.events.KeyboardEvent;
import openfl.events.Event;
import flixel.FlxG;

/**
 * The main class that starts our program.
 * @author Leather128
 */
class Main extends openfl.display.Sprite
{
	/**
		The current info display being used (only shown on desktop platforms or in debug mode).
		@author Leather128
	**/
	public static var fps_counter:base.Info;
	
	public function new()
	{
		super();

		// Fixes some assets not loading properly
		flixel.graphics.FlxGraphic.defaultPersist = true;
		addChild(new flixel.FlxGame(0, 0, funkin.scenes.Test));

		// Create FPS Counter even if it's not shown just in case.
		fps_counter = new base.Info(10, 3, 0xFFFFFFFF);
		#if (desktop || debug)
		// Only add FPS Counter if on desktop OR you're using a debug build.
		addChild(fps_counter);
		#end
	}
}
