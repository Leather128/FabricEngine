package;

/**
 * The main class that starts our program.
 * @author Leather128
 */
class Main extends openfl.display.Sprite {
	/**
		The current info display being used (only shown on desktop platforms or in debug mode).
		@author Leather128
	**/
	public static var fps_counter:base.Info;

	/**
	 * The build number of the game.
	 * @author Leather128
	 */
	public static var build_number:Int = 0;

	/**
	 * Last commit of the game before this build was made.
	 * @author Leather128
	 */
	public static var commit_id:String = "";
	
	public function new() {
		super();

		// Simple loading of the build number and commit id on startup.
		#if sys
		if (sys.FileSystem.exists(sys.FileSystem.absolutePath('build.txt')) && sys.FileSystem.exists(sys.FileSystem.absolutePath('commit.txt'))) {
			build_number = Std.parseInt(sys.io.File.getContent(sys.FileSystem.absolutePath('build.txt')));
			commit_id = sys.io.File.getContent(sys.FileSystem.absolutePath('commit.txt')).trim();
		}
		#end

		// Fixes some assets not loading properly
		flixel.graphics.FlxGraphic.defaultPersist = true;
		addChild(new flixel.FlxGame(0, 0, funkin.scenes.TitleScreen));

		// Create FPS Counter even if it's not shown just in case.
		fps_counter = new base.Info(10, 3, 0xFFFFFFFF);
		#if (desktop || debug)
		// Only add FPS Counter if on desktop OR you're using a debug build.
		addChild(fps_counter);
		#end
	}
}
