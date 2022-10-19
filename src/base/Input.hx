package base;

/**
 * Class to get input in a cleaner and more customizable fashion than regular flixel code.
 * 
 * @author Leather128
 */
class Input
{
    /**
     * Map of `String`s to `flixel.input.keyboard.FlxKey`s with easier to understand and modify names.
     * @author Leather128
     */
    public static var action_map:Map<String, flixel.input.keyboard.FlxKey> = [
        // Technically these should be redundant, but they are required for their alt versions to work, so yeah.
        "left" => LEFT, "left_alt" => A,
        "down" => DOWN, "down_alt" => S,
        "up" => UP, "up_alt" => W,
        "right" => RIGHT, "right_alt" => D,

        "accept" => ENTER, "accept_alt" => SPACE,

        "exit" => ESCAPE, "exit_alt" => BACKSPACE,
    ];

    /**
     * Gets and returns whether or not the specified `action` is currently of `state` state.
     * @param action Action to check (can be key name as well).
     * @param state State to check for (default is `JUST_PRESSED`).
     * @param exact Whether to be exact with the state detection (ex: if `false` a `PRESSED` check returns true if `JUST_PRESSED` is true).
     * @return Bool
     * @author Leather128
     */
    public static function is(action:String, ?state:flixel.input.FlxInput.FlxInputState = JUST_PRESSED, ?exact:Bool = false):Bool
    {
        // exact checks
        if (!exact)
        {
            if (state == PRESSED && is(action, JUST_PRESSED))
                return true;
            if (state == RELEASED && is(action, JUST_RELEASED))
                return true;
        }
        
        // If action is in the action map, check for that instead.
        if (action_map.exists(action))
            return flixel.FlxG.keys.checkStatus(action_map.get(action), state) || flixel.FlxG.keys.checkStatus(action_map.get('${action}_alt'), state);

        return flixel.FlxG.keys.checkStatus(flixel.input.keyboard.FlxKey.fromString(action), state);
    }

    /**
     * Gets and returns the value of `action`.
     * @param action 
     * @return flixel.input.FlxInput.FlxInputState
     * @author Leather128
     */
    public static function get(action:String):flixel.input.FlxInput.FlxInputState
    {
        // this shit dumb af but it works (for something that shouldn't be used often tbh)
        if (is(action, JUST_PRESSED)) return JUST_PRESSED;
        if (is(action, PRESSED)) return PRESSED;
        if (is(action, JUST_RELEASED)) return JUST_RELEASED;
        
        return RELEASED;
    }
}