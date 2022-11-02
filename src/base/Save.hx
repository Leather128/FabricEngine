package base;

/**
 * Class that provides a higher level way of accessing save data.
 * @author Leather128
 */
class Save {
    /**
     * Name of the save data.
     */
    public static var save_name:String = 'fabric-engine';

    /**
     * Path to the save data.
     */
    public static var save_path:String = 'leather128';

    /**
     * Map of `String(s)` to `flixel.util.FlxSave(s)` to store multiple saves.
     */
    public static var saves:Map<String, flixel.util.FlxSave> = [];
    
    /**
     * Initializes save data.
     */
    public static function init():Void {
        // set flixel save manually since it comes from FlxG.save
        FlxG.save.bind('${save_name}-flixel', save_path);
        saves.set('flixel', FlxG.save);

        make_save('gameplay');
        make_save('appearance');
    }

    public static function make_save(name:String, ?key:String):Void {
        if (key == null) key = name;
        // creates new save under name '[save_name]-[name]' ex: fabric-engine-main, fabric-engine-flixel
        // and sets it's key in the saves map
        saves.set(key, new flixel.util.FlxSave());
        saves.get(key).bind('${save_name}-${name}', save_path);
        saves.get(key).flush();
    }
}
