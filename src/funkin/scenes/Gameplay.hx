package funkin.scenes;

import funkin.sprites.gameplay.Stage;
import funkin.sprites.gameplay.Character;
import funkin.scripting.*;
import funkin.utils.Song;
import flixel.system.FlxSound;

/**
 * The actual main gameplay of the game.
 * @author Leather128
 */
class Gameplay extends FunkinScene {
    /**
     * Current active instance of the `Gameplay` class.
     */
    public static var instance:Gameplay;

    /**
     * Current song that the game is using.
     */
    public static var song:Song;

    /**
     * Array of all currently loaded `Script`s.
     */
    public var scripts:Array<Script> = [];

    /**
     * Current vocals being played.
     */
    public var vocals:FlxSound;

    /**
     * Current Player 1 (Boyfriend) in the game.
     */
    public var bf:Character;

    /**
     * Current Player 2 (Opponent) in the game.
     */
    public var dad:Character;

    /**
     * Current Girlfriend Character in the game.
     */
    public var gf:Character;

    /**
     * Current Stage in the game.
     */
    public var stage:Stage;

    /**
     * Toggle for whether or not the camera is bouncing and lerping mid-song.
     */
    public var camera_bouncing:Bool = true;

    /**
     * Default zoom value for the game camera.
     */
    public var default_cam_zoom:Float = 1.05;

    /**
     * Default zoom value for the hud camera.
     */
    public var default_hud_zoom:Float = 1.0;

    /**
     * Current UI being used by `Gameplay`.
     */
    public var ui:funkin.sprites.ui.GameplayUI;

    /**
     * `flixel.FlxCamera` that all the HUD/UI goes on.
     */
    public var hud_cam:flixel.FlxCamera = new flixel.FlxCamera();

    /**
     * Current score of the song.
     */
    public var score:Int = 0;

    override function create():Void {
        // load song fallbacks
        if (song == null) song = SongHelper.load_song('tutorial/normal');
        // if the shit failed to load
        if (song == null) { super.create(); return; }

        // camera management
        FlxG.cameras.reset();
        hud_cam.bgColor = flixel.util.FlxColor.TRANSPARENT;
        FlxG.cameras.add(hud_cam, false);

        super.create();

        instance = this;

        // song script inits
        load_song_scripts();

        // game shit lmao!!!
        stage = new Stage();
        // default cam zoom shit
        default_cam_zoom = stage.default_camera_zoom;
        FlxG.camera.zoom = default_cam_zoom;

        gf = new Character(400, 130, 'gf');
        dad = new Character(100, 100, song.player2);
        bf = new Character(770, 450, song.player1, true);

        add(stage);

        add(gf);
        add(dad);
        add(bf);

        // load ui
        ui = new funkin.sprites.ui.GameplayUI(); ui.scrollFactor.set();
        ui.cameras = [hud_cam];
        add(ui);

        // load music
        // preload
        Assets.audio('songs/${song.song.toLowerCase()}/Inst');
        Assets.audio('songs/${song.song.toLowerCase()}/Voices');

        if (song.needsVoices != false) vocals = new FlxSound().loadEmbedded(Assets.audio('songs/${song.song.toLowerCase()}/Voices'));
        else vocals = new FlxSound();
        FlxG.sound.list.add(vocals);
        // play
        FlxG.sound.playMusic(Assets.audio('songs/${song.song.toLowerCase()}/Inst'));
        FlxG.sound.music.play(true);
        vocals.play(true);

        Conductor.bpm = song.bpm;

        call_scripts('create_post'); call_scripts('createPost');
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        call_scripts('update', [elapsed]);

        Conductor.song_position_raw += FlxG.elapsed * 1000.0;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        if (Math.abs(FlxG.sound.music.time - Conductor.song_position_raw) >= 25.0) {
            Conductor.song_position_raw = FlxG.sound.music.time;
            Conductor.song_position = Conductor.song_position_raw + Conductor.offset;
        }

        if (camera_bouncing) {
            FlxG.camera.zoom = flixel.math.FlxMath.lerp(FlxG.camera.zoom, default_cam_zoom, elapsed * 3);
            hud_cam.zoom = flixel.math.FlxMath.lerp(hud_cam.zoom, default_hud_zoom, elapsed * 3);
        }

        call_scripts('update_post', [elapsed]); call_scripts('updatePost', [elapsed]);
    }

    override function on_beat():Void {
        // preferred function naming ig
        call_scripts('on_beat', [Conductor.beat, Conductor.beat_f]); call_scripts('beatHit', [Conductor.beat, Conductor.beat_f]);

        // funny checks
        if (bf.animation.curAnim != null && !bf.animation.curAnim.name.startsWith('sing')) bf.dance();
        if (dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing')) dad.dance();
        if (gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith('sing')) gf.dance();

        if (camera_bouncing && Conductor.beat % 4 == 0) { FlxG.camera.zoom += 0.015; hud_cam.zoom += 0.03; }

        ui.on_beat();

        super.on_beat();
    }

    override function on_step():Void {
        // preferred function naming ig
        call_scripts('on_step', [Conductor.step, Conductor.step_f]); call_scripts('stepHit', [Conductor.step, Conductor.step_f]);

        super.on_step();
    }

    /**
     * Calls `func` with `args` on all scripts but DOES NOT return the value.
     * 
     * (use this only when a return value is discarded from the function)
     * @param func Function to call.
     * @param args Arguments to use.
     */
    public function call_scripts(func:String, ?args:Array<Dynamic>):Void {
        for (script in scripts) script.call(func, args);

        // call it on funny objects lmao!!
        stage.script.call(func, args);
        // (use order as created cuz fuck you lol!)
        gf.script.call(func, args);
        dad.script.call(func, args);
        bf.script.call(func, args);
    }

    /**
     * Loads all scripts for the current script (global or not).
     */
    public function load_song_scripts():Void {
        // load song specific scripts
        for (dir in sys.FileSystem.readDirectory(Assets.asset('songs/${song.song.toLowerCase()}'))) {
            var script:Script = Script.load(dir);
            if (script != null) { scripts.push(script); script.call('create'); }
        }
    }

    /**
     * Override destroy function for some extra stuff.
     */
    public override function destroy():Void {
        if (instance == this) instance = null;
        super.destroy();
    }
}
