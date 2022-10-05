package assets;

#if sys
import sys.FileSystem;
#end

/**
    Class to get different assets from the game easier.

    @author Leather128
**/
class AssetPaths
{
    /**
        Returns the relative path to any given `original_path`.

        @param original_path The original path to check
        @return Relative path to the `original_path` (with mods included).
    **/
    public static function asset(original_path:String):String
    {
        var mod:String = Mods.current_mod;

        if (exists('mods/$mod/$original_path'))
            return 'mods/$mod/$original_path';

        // loop through all mods
        for (active_mod in Mods.active_mods)
        {
            // don't duplicate checks cuz file system checks are kinda slow sometimes
            if (active_mod != mod)
            {
                if (exists('mods/$active_mod/$original_path'))
                    return 'mods/$active_mod/$original_path';
            }
        }
        
        return 'assets/$original_path';
    }

    /**
        Check if a given `path` exists on the `FileSystem` and returns true if it does.

        @param path The relative path to check.
        @return Whether or not the path exists.
    **/
    public static function exists(path:String):Bool
    {
        // #if sys so we can have html5 support but not really lol
        #if sys
        if (FileSystem.exists(FileSystem.absolutePath(path)))
            return true;
        #end

        return false;
    }
}
