package base;

/**
 * Class to hold all data about logging (and important variables / functions).
 * @author Leather128
 */
class Log {
	/**
	 * Simple map that contains useful ascii color strings
	 * that can be used when printing to console for nice colors.
	 * @author martinwells (https://gist.github.com/martinwells/5980517)
	 */
	public static var ascii_colors:Map<String, String> = [
		'black' => '\033[0;30m',
		'red' => '\033[31m',
		'green' => '\033[32m',
		'yellow' => '\033[33m',
		'blue' => '\033[1;34m',
		'magenta' => '\033[1;35m',
		'cyan' => '\033[0;36m',
		'grey' => '\033[0;37m',
		'white' => '\033[1;37m',
		'default' => '\033[0;37m' // grey apparently
	];

	/**
	 * Used to replace haxe.Log.trace
	 * @param value Value to trace.
	 * @param pos_infos (Optional) Info about where the trace came from and parameters for it.
	 * @author Leather128
	 */
	public static function haxe_print(value:Dynamic, ?pos_infos:haxe.PosInfos):Void {
		if (pos_infos.customParams == null)
			print(value, null, pos_infos);
		else {
			var type:PrintType = pos_infos.customParams.copy()[0];
			pos_infos.customParams = null; // so no stupid shit in the end of prints :D
			print(Std.string(value), type, pos_infos);
		}
	}

	/**
	 * Prints the specified `message` with `type` and `pos_infos`.
	 * @param message The message to print as a `String`.
	 * @param type (Optional) The type of print (aka, `LOG`, `DEBUG`, `WARNING`, or `ERROR`) as a `PrintType`.
	 * @param pos_infos (Optional) Info about where the print came from.
	 * @author Leather128
	 */
	public static function print(message:String, ?type:PrintType = DEBUG, ?pos_infos:haxe.PosInfos):Void {
		switch (type) {
			case LOG:
				haxe_trace('${ascii_colors['default']}[   LOG   ] $message', pos_infos);
			case DEBUG: #if debug haxe_trace('${ascii_colors['green']}[  DEBUG  ] ${ascii_colors['default']}$message', pos_infos); #end
			case WARNING:
				haxe_trace('${ascii_colors['yellow']}[ WARNING ] ${ascii_colors['default']}$message', pos_infos);
			case ERROR:
				haxe_trace('${ascii_colors['red']}[  ERROR  ] ${ascii_colors['default']}$message', pos_infos);
			case SCRIPT:
				haxe_trace('${ascii_colors['cyan']}[ SCRIPTS ] ${ascii_colors['default']}$message', pos_infos);
			// if you really want null, then here have it >:(
			default:
				haxe_trace(message, pos_infos);
		}
	}

	/**
	 * Access to the old `haxe.Log.trace` function.
	 * @author Leather128
	 */
	public static var haxe_trace:haxe.Constraints.Function;
}

/**
 * Type of print you want to do.
 */
enum PrintType {
	LOG;
	DEBUG;
	WARNING;
	ERROR;
	SCRIPT;
}
