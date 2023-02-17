package funkin;

/**
 * Typedef to store data about a change of bpm in a song.
 * @author Leather128
 */
typedef BPMChange = {
    var bpm:Float;

    /**
     * Time of the BPM Change in milliseconds.
     */
    var time:Float;

    /**
     * Step of the BPM Change.
     */
    var step:Float;
}

/**
 * Class to store all variables and functions related to music and timing
 * in the game.
 * @author Leather128
 */
class Conductor {
    /**
     * Current beats per minute of the song that's playing.
     */
    public static var bpm:Float;

    /**
     * Current offset for the song position in milliseconds.
     */
    public static var offset:Float;

    /**
     * Current position of the song that's playing in milliseconds. (with offsets!)
     */
    public static var song_position:Float;

    /**
     * Current position of the song that's playing in milliseconds. (without offsets!)
     */
    public static var song_position_raw:Float;

    /**
     * Time between beats in milliseconds.
     */
    public static var time_between_beats(get, never):Float;

    /**
     * Time between steps in milliseconds.
     */
    public static var time_between_steps(get, never):Float;

    /**
     * Current 'beat' or 4th note of the song that's playing.
     */
    public static var beat(get, never):Int;

    /**
     * Current 'beat' or 4th note of the song that's playing. (`Float` version)
     */
    public static var beat_f(get, never):Float;

    /**
     * Current 'step' or 16th note of the song that's playing.
     */
    public static var step(get, never):Int;

    /**
     * Current 'step' or 16th note of the song that's playing. (`Float` version)
     */
    public static var step_f(get, never):Float;

    /**
     * An array of all bpm changes for the song that's playing.
     */
    public static var bpm_changes:Array<BPMChange> = [];

    public static var safe_frames:Int = 10;

    public static var safe_zone_offset(get, never):Float;

    public static function set_bpm(value:Float, ?song:funkin.utils.Song = null):Float {
        bpm = value;

        if (song == null)
            song = {
                song: null,
                validScore: false,
                speed: 1.0,
                player1: null,
                player2: null,
                notes: [],
                bpm: value,
                needsVoices: false,
            };

        set_bpm_changes(song);
        return bpm;
    }

    private static function get_time_between_beats():Float {
        return (60.0 / bpm) * 1000.0;
    }

    private static function get_time_between_steps():Float {
        return time_between_beats / 4.0;
    }

    private static function get_beat():Int {
        return Math.floor(beat_f);
    }

    private static function get_beat_f():Float {
        // does bpm changes too uwu
        if (bpm_changes.length == 0)
            set_bpm(bpm);

        var last_change:BPMChange = bpm_changes[0];

        for (change in bpm_changes) {
            if (song_position < change.time)
                break;

            last_change = change;
            bpm = change.bpm;
        }

        return (last_change.step / 4.0) + ((song_position - last_change.time) / time_between_beats);
    }

    private static function get_step():Int {
        return Math.floor(step_f);
    }

    private static function get_step_f():Float {
        // does bpm changes too uwu
        if (bpm_changes.length == 0)
            set_bpm(bpm);
        
        var last_change:BPMChange = bpm_changes[0];

        for (change in bpm_changes) {
            if (song_position < change.time)
                break;

            last_change = change;
            bpm = change.bpm;
        }

        return last_change.step + ((song_position - last_change.time) / time_between_steps);
    }

    private static function get_safe_zone_offset():Float {
        return (safe_frames / 60.0) * 1000.0;
    }

    /**
     * Creates bpm changes for the current song based on the input `song_sections`.
     * @param song_sections Sections to use from a song (most likely coming from `[your song here].notes`).
     */
    public static function set_bpm_changes(song:funkin.utils.Song):Array<BPMChange> {
        // this is not stolen from https://github.com/Leather128/LeatherEngineGodot/blob/main/Scripts/Autoload/Conductor.gd do not check
        bpm_changes = [{
            bpm: song.bpm,
            step: 0.0,
            time: 0.0,
        }];

        var bpm:Float = song.bpm;
        var step:Float = 0.0;
        var time:Float = 0.0;

        for (section in song.notes) {
            if (section.changeBPM && section.bpm != bpm && section.bpm > 0.0) {
                bpm = section.bpm;
                bpm_changes.push({
                    bpm: bpm,
                    step: step,
                    time: time,
                });
            }

            if (section.lengthInSteps == null)
                section.lengthInSteps = 16;

            step += section.lengthInSteps;
            time += ((60.0 / bpm) * 1000.0 / 4.0) * section.lengthInSteps;
        }

        return bpm_changes;
    }
}