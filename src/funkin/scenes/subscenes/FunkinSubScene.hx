package funkin.scenes.subscenes;

/**
 * Base substate class to use for all substates in the `funkin` package.
 * @author Leather128
 */
class FunkinSubScene extends flixel.addons.ui.FlxUISubState {
    /**
     * Beat (4th note) of the song on the previous frame.
     */
    private var last_beat:Int = 0;

    /**
     * Step (16th note) of the song on the previous frame.
     */
    private var last_step:Int = 0;

    override function create():Void {
        // set framerate just in case
		FlxG.stage.frameRate = Save.get('fps-cap');

        super.create();
    }

    override function update(elapsed:Float):Void {
        // Music stuff //

        // Set float beat and step
        Conductor.beat_f = Conductor.song_position / Conductor.time_between_beats;
        Conductor.step_f = Conductor.song_position / Conductor.time_between_steps;

        // Set normal beat and step
        Conductor.beat = Math.floor(Conductor.beat_f); Conductor.step = Math.floor(Conductor.step_f);

        if (Conductor.beat > last_beat) on_beat();
        if (Conductor.step > last_step) on_step();

        // Set old beat and step to the current ones after detecting changes
        last_beat = Conductor.beat; last_step = Conductor.step;

        // We reload state here instead of in the same place as fullscreen just to allow states to manually do things before the state gets reloaded (could be useful)
        if (Input.is('f5')) FlxG.resetState();

        super.update(elapsed);
    }

    // Replace these functions with your own in your states!

    /**
     * Function that gets called on every beat (4th note) of the song.
     */
    public function on_beat():Void {};

    /**
     * Function that gets called on every step (16th note) of the song.
     */
    public function on_step():Void {};

    override function onFocus():Void {
        super.onFocus();
        // re set the framerate here because it gets turned back to 60 if we don't
        FlxG.stage.frameRate = Save.get('fps-cap');
    }
}
