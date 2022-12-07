package funkin.sprites.gameplay;

import funkin.scripting.Script;

/**
 * A stage in gameplay.
 * @author Leather128
 */
class Stage extends flixel.group.FlxGroup.FlxTypedGroup<Sprite> {
    /**
     * Stage's current script.
     */
    public var script:Script;

    /**
     * Starting position of GF.
     */
    public var gf_position:flixel.math.FlxPoint = flixel.math.FlxPoint.get(400, 130);

    /**
     * Starting position of BF (Player One).
     */
    public var bf_position:flixel.math.FlxPoint = flixel.math.FlxPoint.get(770, 450);

    /**
     * Starting position of Dad (Player Two).
     */
    public var dad_position:flixel.math.FlxPoint = flixel.math.FlxPoint.get(100, 100);

    public function new(stage:String = 'stage') {
        super();

        script = Script.load('stages/${stage}');

        if (script == null) {
            trace('${stage} doesn\'t have a stage script (stages/${stage})! This stage will be broken.', WARNING);
            script = new Script(); // everything here does nothing lmao
        }

        script.set('stage', this);
        script.set('add', this.add);
        // just in case you're crazy af
        script.set('_add', FlxG.state.add);
        // simple helper function
        script.set('stage_asset', function(input_path:String, ?custom_stage:String):String { return 'gameplay/stages/${custom_stage != null ? custom_stage : stage}/${input_path}'; });

        script.call('create');
    }
}