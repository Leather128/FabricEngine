package funkin.sprites.gameplay;

import funkin.scripting.*;

class Character extends Sprite {
    public var character:String = 'bf';
    public var script:Script;
    public var dance_steps:Array<String> = ['idle'];
    public var dance_step:Int = 0;

    public var icon:String;
    public var health_color:flixel.util.FlxColor = flixel.util.FlxColor.RED;

    public var is_player:Bool = false;

    public function new(x:Float = 0.0, y:Float = 0.0, character:String = 'bf', ?is_player:Bool = false) {
        super(x, y);

        this.character = character;
        this.is_player = is_player;
        icon = character; // can be customized in scripts

        script = Script.load('characters/${character}/character');

        if (script == null) {
            trace('${character} doesn\'t have a character script! This character will be broken.', ERROR);
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
}