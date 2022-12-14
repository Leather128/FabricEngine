package funkin.scripting;

/**
 * Base script class all other scripts inherit from.
 * @author Leather128
 */
class Script implements flixel.util.FlxDestroyUtil.IFlxDestroyable {
    /**
     * File extensions that can be used for this script.
     */
    public static var file_extensions:Array<String> = [
        'script',
        'templatescript'
    ];

    /**
     * Loads the script at `path`.
     * @param path Path to script with (or without) file extension (starts in `assets/`).
     * @return The Script.
     */
    public static function load(path:String, call_new:Bool = true):Script {
        // HScript checks
        for (ext in HScript.file_extensions) {
            // with ext
            if (Assets.exists('${path}') && path.endsWith('.${ext}')) return new HScript('${path.substring(0, path.length - 1 - ext.length)}', call_new);
            // without ext
            if (Assets.exists('${path}.${ext}')) return new HScript('${path}.${ext}', call_new);
        }

        return null;
    }

    // blank constructor since this class doesn't actually do anything
    public function new(?path:String) {}

    /**
     * Gets `item` and returns it.
     * @param item Item to return.
     * @return Value of `item`.
     */
    public function get(item:String):Dynamic { return null; }

    /**
     * Returns whether or not `item` exists.
     * @param item Item to check.
     * @return Whether or not it exists.
     */
    public function exists(item:String):Bool { return false; }

    /**
     * Sets `item` to `value`.
     * @param item Item to set.
     * @param value Value to set `item` to.
     */
    public function set(item:String, value:Dynamic):Void {};

    /**
     * Calls `func` with arguments `args` and returns the result.
     * @param func Function to call.
     * @param args Arguments to call with.
     * @return Result of the function.
     */
    public function call(func:String, ?args:Array<Dynamic>):Dynamic { return null; }

    /**
     * Sets default variables / imports for the script.
     */
    public function set_defaults():Void {};

    /**
     * Sets the current script object to `obj`.
     * @param obj Object to set it to.
     */
    public function set_script_object(obj:Dynamic):Void {};

    // just in case \_(:3)_/
    public function destroy():Void {};
}