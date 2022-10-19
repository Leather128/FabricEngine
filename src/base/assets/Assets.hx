package base.assets;

import openfl.display.BitmapData;

/**
 * Custom Assets class created to load things in a simpler and more efficient fashion.
 * 
 * @author Leather128
 */
class Assets
{
    /**
     * Image extension used for assets.
     * @author Leather128
     */
    public static final IMAGE_EXT:String = ".png";

    /**
     * Audio extension used for assets.
     * @author Leather128
     */
    public static final AUDIO_EXT:String = ".ogg";

    /**
     * Map of `String`s to `Dynamic`s (file paths to file content).
     * @author Leather128
     */
    public static var cache:Map<String, Dynamic> = [];

    /**
     * Current mod to prefer over others when checking for assets.
     * @author Leather128
     */
    public static var preferred_mod(default, null):String;

    /**
     * Returns the absolute path from `rel_path` (`sys` only).
     * 
     * @param rel_path Path to make into an absolute path.
     * @return String
     * @author Leather128
     */
    public static function absolute_path(rel_path):String
    {
        #if sys
        return sys.FileSystem.absolutePath(rel_path);
        #else
        return rel_path;
        #end
    }

    /**
     * Returns whether or not a file exists from `path` (absolute path) (`sys` only).
     * 
     * @param path Path to check on the file system (absolute).
     * @return Bool
     * @author Leather128
     */
    public static function exists(path:String):Bool
    {
        #if sys
        return sys.FileSystem.exists(path);
        #else
        return openfl.Assets.exists(path);
        #end
    }

    /**
     * Returns the absolute path of `path` from the assets folder.
     * 
     * @param path Path to the asset.
     * @return String
     * @author Leather128
     */
    public static function asset(path:String):String
    {
        if (preferred_mod != null) // If the file exists in preferred_mod then return that.
            if (exists(absolute_path('assets/$preferred_mod/$path')))
                return absolute_path('assets/$preferred_mod/$path');

        return absolute_path('assets/funkin/$path');
    }

    /**
     * Loads and returns the text from the specified `path`.
     * 
     * @param path Path to the text file.
     * @return String
     * @author Leather128
     */
    public static function text(path:String):String
    {
        #if sys
        return sys.io.File.getContent(asset(path));
        #else
        return openfl.Assets.getText(asset(path));
        #end
    }

    /**
     * Load and return image from the specified `path`
     * (starts in `assets` folder)
     * 
     * @param path Path to the image.
     * @return flixel.system.FlxAssets.FlxGraphicAsset
     * @author Leather128
     */
    public static function image(path:String):flixel.system.FlxAssets.FlxGraphicAsset
    {
        // Automatically add image extension if not specified
        if (!path.endsWith(IMAGE_EXT)) path += IMAGE_EXT;
        // If the image isn't already cached, load and cache it.
        if (!cache.exists(path)) cache.set(path, flixel.graphics.FlxGraphic.fromBitmapData(BitmapData.fromFile(asset(path)), false, null, false));

        return cache.get(path); // Return image from the cache.
    }
}