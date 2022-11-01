package funkin.scenes;

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
     * Current song that the game is using.
     */
    public static var song:Song;

    /**
     * Array of all currently loaded `Script`s.
     */
    public var scripts:Array<Script> = [];

    public var vocals:FlxSound;

    public var bf:Character;
    public var dad:Character;
    public var gf:Character;

    override function create():Void {
        // load song fallbacks
        if (song == null) song = SongHelper.load_song('tutorial/normal');
        // if the shit failed to load
        if (song == null) { super.create(); return; }

        super.create();

        // song script inits
        load_song_scripts();

        // game shit lmao!!!
        gf = new Character(400, 130, 'gf');
        dad = new Character(100, 100, song.player2);
        bf = new Character(770, 450, song.player1, true);

        add(gf);
        add(dad);
        add(bf);

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

        call_scripts('update_post', [elapsed]); call_scripts('updatePost', [elapsed]);
    }

    override function on_beat():Void {
        // preferred function naming ig
        call_scripts('on_beat', [Conductor.beat, Conductor.beat_f]); call_scripts('beatHit', [Conductor.beat, Conductor.beat_f]);

        bf.dance();
        dad.dance();
        gf.dance();

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
    public function call_scripts(func:String, ?args:Array<Dynamic>):Void
        for (script in scripts) script.call(func, args);

    /**
     * Loads all scripts for the current script (global or not).
     */
    public function load_song_scripts():Void {
        // load song specific scripts
        for (dir in sys.FileSystem.readDirectory(Assets.asset('songs/tutorial'))) {
            var script:Script = Script.load(dir);
            if (script != null) { scripts.push(script); script.call('create'); }
        }
    }
}
