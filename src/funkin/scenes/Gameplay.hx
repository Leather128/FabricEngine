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
    public var camera_bouncing:Bool = false;

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

    /**
     * Current combo of notes in the song.
     */
    public var combo:Int = 0;

    /**
     * `flixel.FlxObject` that the game camera tracks.
     */
    public var camera_tracker:flixel.FlxObject = new flixel.FlxObject();

    /**
     * Current 'speed' of the camera's movement (actual value is this divided by 100, ex: 12 = 0.12)
     */
    public var camera_speed(default, set):Float = 4.0;

    /**
     * Whether or not the camera is currently moving.
     */
    public var camera_moving(default, set):Bool = true;

    /**
     * Whether or not the song has started yet.
     */
    public var song_started:Bool = false;

    /**
     * Whether or not the countdown has started yet.
     */
    public var started_countdown:Bool = false;

    /**
     * Field for the `haxe.Constraints.Function` in `ui.note_input`.
     * 
     * (Used for scripting)
     */
    public var note_input(default, set):haxe.Constraints.Function;

    private function set_camera_speed(value:Float):Float {
        FlxG.camera.followLerp = value / 100.0; camera_speed = value;
        return value;
    }

    private function set_camera_moving(value:Bool):Bool {
        FlxG.camera.followActive = value; camera_moving = value;
        return value;
    }

    private function set_note_input(value:haxe.Constraints.Function):haxe.Constraints.Function {
        if (ui != null) ui.note_input = function():Void { Reflect.callMethod(null, value, [ ui ]); };
        return value;
    }

    override function create():Void {
        // load song fallbacks
        if (song == null) song = SongHelper.load_song('tutorial/normal');
        // if the shit failed to load
        if (song == null) { super.create(); return; }

        // camera management
        FlxG.cameras.reset();
        hud_cam.bgColor = flixel.util.FlxColor.TRANSPARENT;
        FlxG.cameras.add(hud_cam, false);

        FlxG.sound.music.stop();

        super.create();

        // load ui
        ui = new funkin.sprites.ui.GameplayUI(); ui.scrollFactor.set();
        ui.cameras = [hud_cam];
        note_input = ui.note_input;

        instance = this;

        // song script inits
        load_song_scripts();

        // game shit lmao!!!
        stage = new Stage(song.stage);
        FlxG.camera.zoom = default_cam_zoom;

        gf = new Character(400, 130, song.gf);
        dad = new Character(100, 100, song.player2);
        bf = new Character(770, 450, song.player1, true);

        // global position offsets
        gf.setPosition(gf.x + gf.global_offset.x, gf.y + gf.global_offset.y);
        dad.setPosition(dad.x + dad.global_offset.x, dad.y + dad.global_offset.y);
        bf.setPosition(bf.x + bf.global_offset.x, bf.y + bf.global_offset.y);

        add(stage);

        add(gf);
        add(dad);
        add(bf);

        scripts.push(stage.script); scripts.push(gf.script); scripts.push(dad.script); scripts.push(bf.script);

        // for tutorial type shit
        if (dad.character == gf.character) { scripts.remove(dad.script); remove(dad); dad.destroy(); dad = gf; }

        // add ui to screen
        add(ui);

        // load music
        // preload
        Assets.audio('songs/${song.song.toLowerCase()}/Inst');
        Assets.audio('songs/${song.song.toLowerCase()}/Voices');

        Conductor.bpm = song.bpm;
        Conductor.song_position = 0;
        
        update_camera_position();
        FlxG.camera.follow(camera_tracker, LOCKON, camera_speed / 100.0);
        FlxG.camera.followActive = camera_moving; // just in case it's set beforehand

        call_scripts('create_post'); call_scripts('createPost');

        start_countdown();
    }

    override function update(elapsed:Float):Void {
        call_scripts('update', [elapsed]);

        Conductor.song_position_raw += elapsed * 1000.0;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        if (started_countdown && !song_started && Conductor.song_position >= 0.0) play_song();

        // syncing
        if (song_started && (Math.abs(FlxG.sound.music.time - Conductor.song_position_raw) >= 25.0 || (vocals.playing && Math.abs(vocals.time - Conductor.song_position_raw) >= 25.0)))
            resync_song();

        // camera lerps
        if (camera_bouncing) {
            FlxG.camera.zoom = flixel.math.FlxMath.lerp(FlxG.camera.zoom, default_cam_zoom, elapsed * 3);
            hud_cam.zoom = flixel.math.FlxMath.lerp(hud_cam.zoom, default_hud_zoom, elapsed * 3);
        }

        // other stuff
        if (Input.is('exit')) FlxG.switchState(new Freeplay());
        update_camera_position();

        super.update(elapsed);

        call_scripts('update_post', [elapsed]); call_scripts('updatePost', [elapsed]);
    }

    override function on_beat():Void {
        // funny checks
        if (bf.animation.curAnim != null && !bf.animation.curAnim.name.startsWith('sing')) bf.dance();
        if (dad != gf && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing')) dad.dance();
        if (gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith('sing')) gf.dance();

        if (camera_bouncing && Conductor.beat % 4 == 0) { FlxG.camera.zoom += 0.015; hud_cam.zoom += 0.03; }

        ui.on_beat();

        // preferred function naming ig
        call_scripts('on_beat', [Conductor.beat, Conductor.beat_f]); call_scripts('beatHit', [Conductor.beat, Conductor.beat_f]);

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
    }

    /**
     * Sets `item` to `value` on all scripts.
     * @param item Item to set.
     * @param value Value to set `item` to.
     */
    public function set_scripts(item:String, value:Dynamic):Void {
        for (script in scripts) script.set(item, value);
    }

    /**
     * Loads all scripts for the current script (global or not).
     */
    public function load_song_scripts():Void {
        // load song specific scripts
        for (dir in sys.FileSystem.readDirectory(Assets.asset('songs/${song.song.toLowerCase()}'))) {
            var script:Script = Script.load('songs/${song.song.toLowerCase()}/${dir}');
            if (script != null) { scripts.push(script); script.call('create'); }
        }
    }

    /**
     * Updates the camera position to the current target. Pretty simple.
     */
    public function update_camera_position():Void {
        if (Conductor.beat < 0) return;
        if (song.notes.length - 1 < Math.floor(Conductor.beat / 4)) return;

        var must_hit_section:Bool = song.notes[Math.floor(Conductor.beat / 4)].mustHitSection;
        var target:Character = must_hit_section ? bf : dad;

        camera_tracker.setPosition(target.getMidpoint().x + target.camera_offset.x, target.getMidpoint().y + target.camera_offset.y);
    }

    /**
     * Starts the in-game countdown.
     */
    public function start_countdown():Void {
        call_scripts('start_countdown'); call_scripts('startCountdown');

        started_countdown = true;
        ui.start_countdown();

        Conductor.song_position_raw = -(Conductor.time_between_beats * 5.0);
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;
    }

    /**
     * Plays the loaded song.
     */
    public function play_song():Void {
        call_scripts('on_play'); call_scripts('play_song'); call_scripts('playSong');

        // loading vocals
        if (song.needsVoices != false) vocals = new FlxSound().loadEmbedded(Assets.audio('songs/${song.song.toLowerCase()}/Voices'));
        else { vocals = new FlxSound(); vocals.volume = 0.0; }

        FlxG.sound.list.add(vocals);

        // loading and playing inst
        FlxG.sound.playMusic(Assets.audio('songs/${song.song.toLowerCase()}/Inst'));
        FlxG.sound.music.play(true);
        FlxG.sound.music.onComplete = end_song;

        // play vocals
        vocals.play(true);

        song_started = true;
    }

    /**
     * Ends the loaded song and transitions to the next scene.
     */
    public function end_song():Void {
        call_scripts('on_end'); call_scripts('end_song'); call_scripts('endSong');

        // TODO: implement this properly lol
        FlxG.switchState(new Freeplay());
    }

    public function resync_song():Void {
        call_scripts('on_resync'); call_scripts('resync_song'); call_scripts('resyncSong');

        Conductor.song_position_raw = FlxG.sound.music.time;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        // resync vocals
        if (vocals == null) return;

        vocals.pause();
        vocals.time = FlxG.sound.music.time;
        vocals.play();

        call_scripts('on_resync_post'); call_scripts('resync_song_post'); call_scripts('resyncSongPost');
    }

    /**
     * Override destroy function for some extra stuff.
     */
    public override function destroy():Void {
        if (instance == this) instance = null;
        super.destroy();
    }
}
