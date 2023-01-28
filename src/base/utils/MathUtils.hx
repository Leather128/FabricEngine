package base.utils;

/**
 * Class full of some math-related utility functions.
 * @author Leahther128
 */
class MathUtils {
    /**
     * Slightly more optimized version of `flixel.math.FlxMath`'s function
     * @param number Any number.
     * @param precision Number of decimals the result should have.
     * @return The rounded value of that number.
     */
    public static function round_decimal(number:Float, precision:Int):Float {
        return Math.fround(number * (10^precision)) / (10^precision);
    }
}