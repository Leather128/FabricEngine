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
	public var memory_usage:Float = 0;

	/**
	 * The peak of the memory usage of the program in megabytes.
	 */
	public var memory_usage_peak:Float = 0;

	/**
	 * Current elapsed program time in milliseconds.
	 */
	public var current_time:Float = 0.0;

	/**
	 * Array of all previous times (in milliseconds).
	 */
	public var times:Array<Float> = [];

	public function new(x:Float = 10, y:Float = 3, color:Int = 0xFFFFFF) {
		super();

		this.x = x;
		this.y = y;
		width = 1280;
		height = 720;

		selectable = mouseEnabled = false;
		// VCR OSD Mono is the font name of assets/funkin/fonts/vcr.ttf
		defaultTextFormat = new openfl.text.TextFormat('VCR OSD Mono', 14, color);
	}

	/**
	 * Function that gets called every frame with the `deltaTime` to update the display's values.
	 * 
	 * @param deltaTime Time between now and the last frame (in milliseconds).
	 * @author Leather128
	 */
	public override function __enterFrame(deltaTime:Float):Void {
		// Frames per second calculations
		current_time += deltaTime;
		times.push(current_time);

		while (times[0] < current_time - 1000) times.shift();

		fps = times.length;

		// Memory calculations for the 5 people who will use it.
		memory_usage = Std.parseFloat(Utilities.format_bytes(Memory.getCurrentUsage(), true));
		memory_usage_peak = Std.parseFloat(Utilities.format_bytes(Memory.getPeakUsage(), true));

		// Actual text
		text = '${fps} fps
		${Utilities.format_bytes(Memory.getCurrentUsage(), true)}/${Utilities.format_bytes(Memory.getPeakUsage())}
		${#if debug 'debug-build-${Main.build_number} (${Main.commit_id})' #else '' #end}
		';
	}
}
