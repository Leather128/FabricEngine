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
    
    public static var default_options:haxe.xml.Access;

    /**
     * Initializes save data.
     */
    public static function init():Void {
        // set flixel save manually since it comes from FlxG.save
        FlxG.save.bind('${save_name}-flixel', save_path);
        saves.set('flixel', FlxG.save);

        default_options = new haxe.xml.Access(Xml.parse(Assets.text('data/default-options.xml')).firstElement());

        // loop through all saves
        for (save in default_options.nodes.save) {
            var key:String = save.has.key ? save.att.key : save.att.name;

            make_save(save.att.name, key);

            // different option types
            for (opt in save.nodes.bool) set_default(opt.att.key, opt.att.value == 'true', key);
            // numbers
            for (opt in save.nodes.float) set_default(opt.att.key, Std.parseFloat(opt.att.value), key);
            for (opt in save.nodes.int) set_default(opt.att.key, Std.parseInt(opt.att.value), key);
            // string
            for (opt in save.nodes.string) set_default(opt.att.key, opt.att.value, key);
        }

        // set parameters here
        Main.fps_counter.visible = get('fps-counter', 'appearance');
        Assets.preferred_mod = get('mod', 'engine');
        FlxG.sound.volume = get('volume', 'flixel');
        FlxG.stage.frameRate = get('fps-cap', 'appearance');
        FlxG.autoPause = get('auto-pause', 'misc');
    }

    /**
     * Creates new save under name `[save_name]-[name]` ex: fabric-engine-gameplay
     * and sets it's key in the `saves` map.
     * @param name Name of the save to create.
     * @param key (Optional) Key to set to in the `saves` `Map` (by default is `name`)
     */
    public static function make_save(name:String, ?key:String):Void {
        if (key == null) key = name;

        saves.set(key, new flixel.util.FlxSave());
        saves.get(key).bind('${save_name}-${name}', save_path);
        saves.get(key).flush();
    }

    /**
     * Gets specified `key` from `save`.
     * @param key Key to get value of.
     * @param save (Optional) Save to check (defaults to searching through all saves).
     * @return Value of `key`.
     */
    public static function get(key:String, ?save:String):Dynamic {
        if (save != null && saves.get(save) != null) return Reflect.getProperty(saves.get(save).data, key);

        // otherwise
        for (save in saves) {
            // if this is true, go to the next save lol
            if (save == null || Reflect.getProperty(save.data, key) == null) continue;

            return Reflect.getProperty(save.data, key);
        }

        // fallback
        return null;
    }

    /**
     * Sets `key` to `value` in `save`.
     * @param key Key to set.
     * @param value Value to set `key` to.
     * @param save Save to set data in.
     */
    public static function set(key:String, value:Dynamic, save:String):Void {
        if (saves.get(save) == null) return;

        Reflect.setProperty(saves.get(save).data, key, value);
        saves.get(save).flush();
    }

    /**
     * Sets `key` to `value` in `save` if the key doesn't already have a value.
     * @param key Key to set.
     * @param value Default value to set `key` to.
     * @param save Save to set data in.
     */
    public static function set_default(key:String, value:Dynamic, save:String):Void {
        if (get(key, save) == null) set(key, value, save);
    }
}
