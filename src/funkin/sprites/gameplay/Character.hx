package funkin.sprites.gameplay;

import funkin.scripting.Script;

/**
 * A character in gameplay.
 * @author Leather128
 */
class Character extends Sprite {
    /**
     * Name of the character.
     */
    public var character:String = 'bf';

    /**
     * Character's current script.
     */
    public var script:Script;

    /**
     * Animations to play for dancing (in order).
     */
    public var dance_steps:Array<String> = ['idle'];

    /**
     * Index of animation to play for dancing.
     */
    public var dance_step:Int = 0;

    /**
     * Character's health icon name.
     */
    public var icon:String;

    /**
     * Character's health bar color.
     */
    public var health_color:flixel.util.FlxColor = flixel.util.FlxColor.RED;

    /**
     * Toggle for whether or not this character is on the player's side.
     */
    public var is_player:Bool = false;

    /**
     * Character's camera offset stored as a `flixel.math.FlxPoint`.
     * 
     * ```
     * Default (Enemy): {x: 150, y: -100}
     * Default (Player): {x: -100, y: -100}
     * ```
     */
    public var camera_offset:flixel.math.FlxPoint = new flixel.math.FlxPoint();

    /**
     * Character's global position offset in `Gameplay`.
     */
    public var global_offset:flixel.math.FlxPoint = new flixel.math.FlxPoint();

    public function new(x:Float = 0.0, y:Float = 0.0, character:String = 'bf', ?is_player:Bool = false) {
        super(x, y);

        this.character = character;
        this.is_player = is_player;

        // default variable values that vary by player value
        if (this.is_player) { camera_offset.set(-100.0, -100.0); health_color = flixel.util.FlxColor.LIME; }
        else camera_offset.set(150.0, -100.0);

        icon = character; // can be customized in scripts

        script = Script.load('characters/${character}/character');

        if (script == null) {
            trace('${character} doesn\'t have a character script (characters/${character}/character)! This character will be broken.', WARNING);
            script = new Script(); // everything here does nothing lmao
        }

        script.set('character', this);
        script.call('create');

        if (is_player) flipX = !flipX;
    }

    /**
     * Makes the character play a 'dance' animation (by default just `idle`).
     * 
     * Can be customized with scripting and/or the `dance_steps` property.
     */
    public function dance():Void {
        // dance step incrementing
        dance_step += 1;
        if (dance_step > dance_steps.length - 1) dance_step = 0;
        // default behaviour
        play_animation(dance_steps[dance_step]);
        // custom behaviour
        script.call('dance');
    }

    /**
     * Loads offsets from a text file at `assets/characters/character_name/offsets.txt`.
     * 
     * File is formatted like:
     * ```
     * anim 0 0
     * anim2 57 2
     * anim3 -6 8
     * ```
     */
    public function load_offsets():Void {
        // error handling
        if (!Assets.exists('characters/${character}/offsets.txt')) {
            trace('characters/${character}/offsets.txt does not exist!', WARNING);
            return;
        }

        var lines:Array<String> = Assets.text('characters/${character}/offsets.txt').trim().split('\n');

        for (line in lines) {
            // split at every space
            var line_data:Array<String> = line.split(' ');
            // more error handling
            if (line_data.length < 3) {
                trace('line ${lines.indexOf(line)} (${line}) does not have at least 3 offset values, skipping.', WARNING);
                continue;
            }

            // set offset
            offsets.set(line_data[0], new flixel.math.FlxPoint(Std.parseFloat(line_data[1]), Std.parseFloat(line_data[2])));
        }
    }
}