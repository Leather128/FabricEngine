package funkin.scripting;

/**
 * Class to hold some of the custom "classes" from HScript's default variables.
 * @author Leather128
 */
class HScriptClasses {
    /**
     * Pointers to `Json.parse` & `Json.encode` basically.
     */
    public static var Json:Dynamic = {
        'parse': tjson.TJSON.parse,
        'encode': tjson.TJSON.encode
    };

    /**
     * Literally just all the static vars and functions from flixel.util.FlxColor.
     */
    public static var FlxColor:Dynamic = {
        // static vars
        'TRANSPARENT': flixel.util.FlxColor.TRANSPARENT,
        'WHITE': flixel.util.FlxColor.WHITE,
        'GRAY': flixel.util.FlxColor.GRAY,
        'BLACK': flixel.util.FlxColor.BLACK,
        'GREEN': flixel.util.FlxColor.GREEN,
        'LIME': flixel.util.FlxColor.LIME,
        'YELLOW': flixel.util.FlxColor.YELLOW,
        'ORANGE': flixel.util.FlxColor.ORANGE,
        'RED': flixel.util.FlxColor.RED,
        'PURPLE': flixel.util.FlxColor.PURPLE,
        'BLUE': flixel.util.FlxColor.BLUE,
        'BROWN': flixel.util.FlxColor.BROWN,
        'PINK': flixel.util.FlxColor.PINK,
        'MAGENTA': flixel.util.FlxColor.MAGENTA,
        'CYAN': flixel.util.FlxColor.CYAN,
        'colorLookup': flixel.util.FlxColor.colorLookup,
        // static funcs
        'fromInt': flixel.util.FlxColor.fromInt,
        'fromRGB': flixel.util.FlxColor.fromRGB,
        'fromRGBFloat': flixel.util.FlxColor.fromRGBFloat,
        'fromCMYK': flixel.util.FlxColor.fromCMYK,
        'fromHSB': flixel.util.FlxColor.fromHSB,
        'fromHSL': flixel.util.FlxColor.fromHSL,
        'fromString': flixel.util.FlxColor.fromString,
        'getHSBColorWheel': flixel.util.FlxColor.getHSBColorWheel,
        'interpolate': flixel.util.FlxColor.interpolate,
        'gradient': flixel.util.FlxColor.gradient,
        'multiply': flixel.util.FlxColor.multiply,
        'add': flixel.util.FlxColor.add,
        'subtract': flixel.util.FlxColor.subtract,
        'new': flixel.util.FlxColor.new
    };
}