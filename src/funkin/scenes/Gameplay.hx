package funkin.scenes;

import funkin.scripting.*;
import funkin.utils.Song;

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

    override function create():Void {
        // load song fallbacks
        if (song == null) song = SongHelper.load_song('tutorial/normal');
        // if the shit failed to load
        if (song == null) { super.create(); return; }

        // song script inits
        load_song_scripts();

        // game shit lmao!!!

        call_scripts('create_post'); call_scripts('createPost');

        super.create();
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);
        call_scripts('update', [elapsed]);
    }

    override function on_beat():Void {
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
    public function call_scripts(func:String, ?args:Array<Dynamic>):Void
        for (script in scripts) script.call(func, args);

    /**
     * Loads all scripts for the current script (global or not).
     */
    public function load_song_scripts():Void {
        // load song specific scripts
        for (dir in sys.FileSystem.readDirectory(Assets.asset('songs/tutorial'))) {
            // HScript scripts
            for (ext in HScript.file_extensions) {
                if (dir.endsWith('.${ext}')) {
                    // this mess of a string basically means 'songs/song-name/`dir`-but-without-extension'
                    scripts.push(new HScript('songs/tutorial/${dir.split('.${ext}')[0]}'));
                    break;
                }
            }
        }
    }
}
