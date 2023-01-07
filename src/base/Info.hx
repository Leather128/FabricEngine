package base;

import external.memory.Memory;

/**
 * Simple extension of `openfl.text.TextField` that displays some basic
 * status info about the game (FPS, Memory, etc).
 * 
 * @author Leather128
 */
class Info extends openfl.text.TextField {
	/**
	 * Current frames per second of the program.
	 */
	public var fps:Int = 0;

	/**
	 * Current memory usage of the program in megabytes.
	 */
	public var memory_usage:Float = 0.0;

	/**
	 * The peak of the memory usage of the program in megabytes.
	 */
	public var memory_usage_peak:Float = 0.0;

	/**
	 * Current elapsed program time in milliseconds.
	 */
	public var current_time:Float = 0.0;

	/**
	 * Current amount of frames counted in the last second.
	 */
	public var _fps:Int = 0;

	/**
	 * Option to use outline shader or not.
	 */
	public var use_outline(default, set):Null<Bool>;

	private function set_use_outline(value:Null<Bool>):Null<Bool> {
		// this is inverted of the value we are setting to lol (at least it SHOULD be ;()
		if (use_outline) {
			this.x += 55; this.y += 10;
		} else {
			this.x -= 55; this.y -= 10;
		}

		return use_outline = value;
	}

	public function new(x:Float = 10, y:Float = 3, color:Int = 0xFFFFFF) {
		super();

		this.x = x; this.y = y;
		width = 1280; height = 720;

		selectable = mouseEnabled = false;
		// VCR OSD Mono is the font name of assets/funkin/fonts/vcr.ttf
		defaultTextFormat = new openfl.text.TextFormat('VCR OSD Mono', 14, color);

		FlxG.signals.postDraw.add(update);
	}

	public function update():Void {
		if (use_outline) {
			shader = new funkin.shaders.OutlineShader();
			scaleX = scaleY = 1.5;
		} else {
			shader = null;
			scaleX = scaleY = 1;
		}

		// Frames per second calculations
		current_time += FlxG.elapsed;
		if (_fps < FlxG.stage.frameRate)
			_fps += 1;

		if (current_time >= 1.0) {
			fps = _fps; _fps = 0;
			current_time = 0.0;
		}

		// Memory calculations for the 5 people who will use it.
		memory_usage = Std.parseFloat(StringUtils.format_bytes(Memory.getCurrentUsage(), true));
		memory_usage_peak = Std.parseFloat(StringUtils.format_bytes(Memory.getPeakUsage(), true));

		// Actual text
		text = '${fps} fps\n'
			+ '${StringUtils.format_bytes(Memory.getCurrentUsage())}/${StringUtils.format_bytes(Memory.getPeakUsage())}\n'
			+ '${#if debug 'debug-build-${Main.build_number} (${Main.commit_id})' #else '' #end}\n';
	}
}
