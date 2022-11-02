package funkin.sprites.gameplay;

import funkin.scripting.Script;

/**
 * A stage in gameplay.
 * @author Leather128
 */
class Stage extends flixel.group.FlxSpriteGroup {
    public var script:Script;

    public var default_camera_zoom:Float = 1.05;

    public function new(stage:String = 'stage') {
        super();

        script = Script.load('stages/${stage}');

        if (script == null) {
            trace('${stage} doesn\'t have a stage script (stages/${stage})! This stage will be broken.', ERROR);
            script = new Script(); // everything here does nothing lmao
        }

        script.set('stage', this);
        script.set('add', this.add);
        // just in case you're crazy af
        script.set('_add', FlxG.state.add);
        // simple helper function
        script.set('stage_asset', function(input_path:String):String { return 'gameplay/stages/${stage}/${input_path}'; });

        script.call('create');

        if (script.exists('default_camera_zoom')) default_camera_zoom = script.get('default_camera_zoom');
        else if (script.exists('defaultCamZoom')) default_camera_zoom = script.get('defaultCamZoom');
    }
}