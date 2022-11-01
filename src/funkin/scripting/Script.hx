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

    // blank constructor since this class doesn't actually do anything
    public function new(?path:String) { call('create'); }

    /**
     * Gets `item` and returns it.
     * @param item Item to return.
     * @return Value of `item`.
     */
    public function get(item:String):Dynamic { return null; }

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

    // just in case \_(:3)_/
    public function destroy():Void {};
}