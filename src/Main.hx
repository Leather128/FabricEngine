package;

/**
 * The main class that starts our program.
 * @author Leather128
 */
class Main extends openfl.display.Sprite {
	/**
		The current info display being used (only shown on desktop platforms or in debug mode).
	**/
	public static var fps_counter:base.Info = new base.Info(10, 3, 0xFFFFFFFF);

	/**
	 * The build number of the game.
	 */
	public static var build_number(default, never):Int = funkin.macros.BuildInfoMacros.get_build_number();

	/**
	 * Last commit of the game before this build was made.
	 */
	public static var commit_id(default, never):String = funkin.macros.BuildInfoMacros.get_build_commit_id();

	/**
	 * Current version of the game. (Grabs from the `Project.xml`)
	 * (Read Only)
	 */
	@:keep
	public static var version(get, never):String;

	private static function get_version():String
		return lime.app.Application.current.meta['version'];

	/**
	 * Whether or not this build is being tested and developed actively.
	 */
	public static var developer_build:Bool = false;
	
	public function new() {
		super();

		// new way of tracing (nicer to work with for errors and such)
		base.Log.haxe_trace = haxe.Log.trace;
		haxe.Log.trace = base.Log.haxe_print;

		// simple loading of the build number and commit id on startup.
		#if (sys && debug)
		developer_build = Sys.args().contains('-livereload');
		#end

		addChild(new flixel.FlxGame(0, 0, funkin.scenes.TitleScreen));
		// create fps counter even if it's not shown just in case.
		addChild(fps_counter);
		fps_counter.visible = false;
		
		base.Save.init();
		// default flixel type beats
		FlxG.stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, key_down);
		flixel.graphics.FlxGraphic.defaultPersist = true;
	}

	/**
	 * Function that gets called everytime a key is detected as being pressed down.
	 * @param evt OpenFL Event data.
	 */
	public static function key_down(evt:openfl.events.KeyboardEvent):Void {
		switch (evt.keyCode) {
			case openfl.ui.Keyboard.F11: FlxG.fullscreen = !FlxG.fullscreen;
		}
	}
}
