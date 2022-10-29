package;

/**
 * The main class that starts our program.
 * @author Leather128
 */
class Main extends openfl.display.Sprite {
	/**
		The current info display being used (only shown on desktop platforms or in debug mode).
	**/
	public static var fps_counter:base.Info;

	/**
	 * The build number of the game.
	 */
	public static var build_number:Int = 0;

	/**
	 * Last commit of the game before this build was made.
	 */
	public static var commit_id:String = "";

	/**
	 * Current version of the game. (Grabs from the `Project.xml`)
	 */
	public static var version:String = 'unknown';

	/**
	 * Whether or not this build is being tested and developed actively.
	 */
	public static var developer_build:Bool = false;
	
	public function new() {
		super();

		// Simple loading of the build number and commit id on startup.
		#if sys
		if (sys.FileSystem.exists(sys.FileSystem.absolutePath('build.txt')) && sys.FileSystem.exists(sys.FileSystem.absolutePath('commit.txt'))) {
			build_number = Std.parseInt(sys.io.File.getContent(sys.FileSystem.absolutePath('build.txt')));
			commit_id = sys.io.File.getContent(sys.FileSystem.absolutePath('commit.txt')).trim();
		}

		#if debug if (Sys.args().contains('-livereload')) developer_build = true; #end
		#end

		// Load the version
		version = lime.app.Application.current.meta.get('version');

		addChild(new flixel.FlxGame(0, 0, funkin.scenes.TitleScreen));

		// Create FPS Counter even if it's not shown just in case.
		fps_counter = new base.Info(10, 3, 0xFFFFFFFF);
		#if (desktop || debug)
		// Only add FPS Counter if on desktop OR you're using a debug build.
		addChild(fps_counter);
		#end
		
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, key_down);
	}

	/**
	 * Function that gets called everytime a key is detected as being pressed down.
	 * @param evt OpenFL Event data.
	 */
	public static function key_down(evt:openfl.events.KeyboardEvent):Void {
		switch (evt.keyCode) {
			case openfl.ui.Keyboard.F5: FlxG.resetState();
			case openfl.ui.Keyboard.F11: FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
