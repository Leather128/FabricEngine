package funkin.scenes;

/**
 * Base state class to use for all states in the `funkin` package.
 * @author Leather128
 */
class FunkinScene extends flixel.FlxState {
    /**
     * Beat (4th note) of the song on the previous frame.
     */
    private var last_beat:Int = 0;

    /**
     * Step (16th note) of the song on the previous frame.
     */
    private var last_step:Int = 0;

    /**
     * Whether or not to clear the cache on scene loading.
     */
    private var clear_cache:Bool = true;

    public function new(?clear_cache:Bool = true) {
        super();
        this.clear_cache = clear_cache;
    }

    override function create():Void {
        super.create();

        // Remove cached assets (prevents memory leaks that i can prevent)
        
        // Remove lingering sounds from the sound list
        FlxG.sound.list.forEachAlive(function(sound:flixel.system.FlxSound) { FlxG.sound.list.remove(sound, true); sound.stop(); sound.kill(); sound.destroy(); });
        FlxG.sound.list.clear();

        // Clear cached assets from the asset cache.
        Assets.clear_cache();

        FlxG.bitmap.mapCacheAsDestroyable();
        FlxG.bitmap.clearCache();

        // Clear actual assets from OpenFL itself
        var cache:openfl.utils.AssetCache = cast openfl.utils.Assets.cache;

        // this totally isn't copied from polymod/backends/OpenFLBackend.hx trust me
        for (key in cache.bitmapData.keys()) cache.bitmapData.remove(key);
        for (key in cache.font.keys()) cache.font.remove(key);
        for (key in cache.sound.keys()) cache.sound.remove(key);

        // this totally isn't copied from polymod/backends/LimeBackend.hx trust me
        for (key in lime.utils.Assets.cache.audio.keys()) lime.utils.Assets.cache.audio.remove(key);
		for (key in lime.utils.Assets.cache.font.keys()) lime.utils.Assets.cache.font.remove(key);
		for (key in lime.utils.Assets.cache.image.keys()) lime.utils.Assets.cache.image.remove(key);
		
        // Run built-in garbage collector
        openfl.system.System.gc();
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

        // Global controls //

        if (Input.is('f11')) FlxG.fullscreen = !FlxG.fullscreen;
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
}
