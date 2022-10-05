package assets;

/**
    Stores information about currently active mods.

    @author Leather128
**/
class Mods
{
    /**
        Current mod to search through for things first.
    **/
    public static var current_mod:String = 'funkin';

    /**
        `Array` of all currently active mods.
    **/
    public static var active_mods:Array<String> = ['funkin'];

    public static function get_mod_path(path:String):String
    {
        #if sys
        if (AssetPaths.exists('mods/$current_mod/$path'))
            return 'mods/$current_mod/$path';

        for (mod in active_mods)
        {
            // no unneccesary checking
            if (mod != current_mod && AssetPaths.exists('mods/$mod/$path'))
                return 'mods/$mod/$path';
        }
        #end
        
        return path;
    }
}