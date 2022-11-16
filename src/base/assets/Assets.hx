package base.assets;

import openfl.display.BitmapData;

/**
 * Custom Assets class created to load things in a simpler and more efficient fashion.
 * 
 * @author Leather128
 */
class Assets {
    /**
     * Image extension used for assets.
     */
    public static final IMAGE_EXT:String = ".png";

    /**
     * Audio extension used for assets.
     */
    public static final AUDIO_EXT:String = ".ogg";

    /**
     * Map of `String`s to `Dynamic`s used for faster loading times (file paths to file content).
     */
    public static var cache:Map<String, Dynamic> = [];

    /**
     * Current mod to prefer over others when checking for assets.
     */
    public static var preferred_mod:String = null;

    /**
     * Returns the absolute path from `rel_path` (`sys` only).
     * 
     * @param rel_path Path to make into an absolute path.
     * @return Absolute path to location at `rel_path`.
     */
    public static function absolute_path(rel_path):String
        return sys.FileSystem.absolutePath(rel_path);

    /**
     * Returns whether or not a file / directory exists from `path` (starts in `assets/`).
     * 
     * @param path Path to check for.
     * @param mod (Optional) Specific mod to check from first.
     * @return Whether or not `path` exists.
     */
    public static function exists(path:String, ?mod:String):Bool
        return sys.FileSystem.exists(asset(path, mod));

    /**
     * Returns the absolute path of `path` from the assets folder.
     * 
     * @param path Path to the asset.
     * @param mod (Optional) Specific mod to check from first.
     * @param override_developer_mode (Optional) Overrides `debug` mode's `Main.developer_build` setting.
     * @return Absolute path to `path` (in `assets/`).
     */
    public static function asset(path:String, ?mod:String, ?override_developer_mode:Bool = false):String {
        if (mod != null && sys.FileSystem.exists(absolute_path('assets/$mod/$path'))) // If the file exists in mod then return that.
            return absolute_path('assets/$mod/$path');

        if (preferred_mod != null && preferred_mod != 'funkin' && sys.FileSystem.exists(absolute_path('assets/$preferred_mod/$path'))) // If the file exists in preferred_mod then return that.
            return absolute_path('assets/$preferred_mod/$path');

        #if debug if (!Main.developer_build || override_developer_mode) { #end
        return absolute_path('assets/funkin/$path');
        #if debug } else { return absolute_path('../../../../assets/funkin/$path'); } #end
    }

    /**
     * Clears the cache manually for all assets.
     */
    public static function clear_cache():Void {
        // For now we literally just do this lmfao
        for (key in cache.keys()) remove(key);
    }

    /**
     * Removes asset from specified `key`.
     * @param key Key to the asset to remove.
     */
    public static function remove(key:String):Void {
        // special destroying for specific types
        if (cache.get(key) is openfl.media.Sound) {
            var casted:openfl.media.Sound = cast cache.get(key);
            casted.close();
        } else if (cache.get(key) is flixel.graphics.FlxGraphic) {
            var casted:flixel.graphics.FlxGraphic = cast cache.get(key);
            casted.persist = false;
            casted.destroyOnNoUse = true;
        }

        cache.set(key, null);
        cache.remove(key);
    }

    /**
     * Loads and returns the text from the specified `path`.
     * 
     * (starts in `assets` folder)
     * 
     * @param path Path to the text file.
     * @param mod (Optional) Specific mod to get asset from.
     * @return Content from `path`.
     */
    public static function text(path:String, ?mod:String):String
        return sys.io.File.getContent(asset(path, mod));

    /**
     * Load and return image from the specified `path`.
     * 
     * (starts in `assets` folder)
     * 
     * @param path Path to the image.
     * @param persist (Optional) Persist option for the graphic.
     * @param mod (Optional) Specific mod to get asset from.
     * @return Image asset from `path`.
     */
    public static function image(path:String, ?persist:Bool = true, ?mod:String):flixel.system.FlxAssets.FlxGraphicAsset {
        var suffix:String = '';
        if (mod != null) suffix = '-${mod}';

        // Automatically add image extension if not specified.
        if (!path.endsWith(IMAGE_EXT)) path += IMAGE_EXT;
        // If the image isn't already cached, load and cache it.
        if (!cache.exists(path + suffix)) cache.set(path + suffix, flixel.graphics.FlxGraphic.fromBitmapData(BitmapData.fromFile(asset(path, mod)), false, null, false));
        if (cache.get(path + suffix) != null) cache.get(path + suffix).persist = persist;

        return cache.get(path + suffix); // Return image from the cache.
    }

    /**
     * Load and return audio from the specified `path`.
     * 
     * (starts in `assets` folder)
     * 
     * @param path Path to the audio.
     * @param mod (Optional) Specific mod to get asset from.
     * @return Audio asset from `path`.
     */
    public static function audio(path:String, ?mod:String):flixel.system.FlxAssets.FlxSoundAsset {
        var suffix:String = '';
        if (mod != null) suffix = '-${mod}';

        // Automatically add audio extension if not specified.
        if (!path.endsWith(AUDIO_EXT)) path += AUDIO_EXT;
        // If the audio isn't already cached, load and cache it.
        if (!cache.exists(path + suffix)) cache.set(path + suffix, openfl.media.Sound.fromFile(asset(path, mod)));

        return cache.get(path + suffix); // Return audio from the cache.
    }

    /**
     * Load and return the name of the font from the specified `path`.
     * 
     * (starts in the `assets/fonts` folder if not specified)
     * 
     * @param path Path to the font.
     * @param mod (Optional) Specific mod to get asset from.
     * @return Font asset's name from `path`.
     */
    public static function font(path:String, ?mod:String):String {
        var suffix:String = '';
        if (mod != null) suffix = '-${mod}';

        // Automatically use the fonts folder if no other folder is specified.
        if (!path.contains('/')) path = 'fonts/${path}';
        // If the font's name isn't already cached, load the font and cache it's name.
        if (!cache.exists(path + suffix)) cache.set(path + suffix, openfl.text.Font.fromFile(asset(path, mod)).fontName);

        return cache.get(path + suffix);
    }
}