package funkin.scripting;

/**
 * Any script using Haxe / HScript for handling.
 * @author Leather128
 */
class HScript extends Script {
    // same docs as Script lmao
    public static var file_extensions:Array<String> = [
        'hx',
        'hxs',
        'hscript'
    ];

    /**
     * Parser that parses the HScript string.
     */
    public var parser:hscript.Parser = new hscript.Parser();

    /**
     * Interpreter to interpret the HScript and provide access
     * to other variables / functions in the script.
     */
    public var interp:hscript.Interp = new hscript.Interp();

    /**
     * Raw script data.
     */
    public var raw_script:String = '';

    /**
     * Creates and parses the HScript file at `path`.
     * @param path Path to the HScript file to use.
     */
    public function new(path:String) {
        parser.allowTypes = true; // Allow typing of variables ex: 'var three:Int = 3;'.
        parser.allowJSON = true; // Allows 'JSON Compatibility' in HScript.
        parser.allowMetadata = true; // Allows Haxe Metadata declarations in HScript.

        // loop through extensions to make sure the path exists
        for (ext in file_extensions) {
            if (Assets.exists(Assets.asset('${path}.${ext}'))) {
                raw_script = Assets.text('${path}.${ext}');
                break;
            }
        }

        // fallback
        if (raw_script == '') {
            trace('Could not find ${path} as a valid HScript file, returning.', ERROR);
            return;
        }

        var program:hscript.Expr = parser.parseString(raw_script);
        set_defaults();
        interp.execute(program);

        // call this at the end cuz it calls the create function
        super(path);
    }

    /**
     * Gets `item` and returns it.
     * @param item Item to return.
     * @return Value of `item`.
     */
    public override function get(item:String):Dynamic
        return interp.variables.get(item);

    /**
     * Sets `item` to `value`.
     * @param item Item to set.
     * @param value Value to set `item` to.
     */
    public override function set(item:String, value:Dynamic):Void
        return interp.variables.set(item, value);

    /**
     * Calls `func` with arguments `args` and returns the result.
     * @param func Function to call.
     * @param args Arguments to call with.
     * @return Result of the function.
     */
    public override function call(func:String, ?args:Array<Dynamic>):Dynamic {
        var real_func:Dynamic = get(func);

        // fallback shit
        try {
            if (real_func == null) return null;

            var return_value:Dynamic = Reflect.callMethod(null, real_func, args);
            return return_value;
        } catch (e) {
            trace('error returning value of ${func} with ${args}! details: ${e.details()}', ERROR);
        }

        return null;
    }

    /**
     * Sets default variables in HScript.
     */
    public override function set_defaults():Void {
        super.set_defaults();

        // import.hx
        add_classes([Input, Sprite, Utilities, Assets, PrintType, Conductor, FlxG, StringTools]);
        // actual custom imports
        add_classes([base.assets.AssetType, flixel.math.FlxMath, flixel.math.FlxPoint, flixel.math.FlxRect, flixel.system.FlxSound, Math, Std]);
        // custom class / abstract shits
        set('Json', HScriptClasses.Json); set('FlxColor', HScriptClasses.FlxColor);
        // functions and other stuff
        set('add', FlxG.state.add);
    }

    /**
     * Adds `class_to_add` to the current set of variables.
     * @param class_to_add Class to add.
     */
    public function add_class(class_to_add:Dynamic, ?custom_name:String):Void {
        if (custom_name == null) {
            var class_path_split:Array<String> = Type.getClassName(class_to_add).split('.');
            set(class_path_split[class_path_split.length - 1], class_to_add);
        } else
            set(custom_name, class_to_add);
    }

    /**
     * Adds all classes in the `classes` Array to the script.
     * @param classes Array of classes to add.
     */
    public function add_classes(classes:Array<Dynamic>):Void
        for (class_to_add in classes) add_class(class_to_add);

    /**
     * Destroys this script.
     */
    public override function destroy():Void {
        // set values to null to try and manually clear them from memory :)
        parser = null; interp.variables.clear(); interp = null; raw_script = null;

        super.destroy();
    }
}