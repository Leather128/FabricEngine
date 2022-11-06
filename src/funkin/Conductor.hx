package funkin;

/**
 * Class to store all variables and functions related to music and timing
 * in the game.
 * @author Leather128
 */
class Conductor {
    /**
     * Current beats per minute of the song that's playing.
     */
    public static var bpm(default, set):Float;

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
    public static var time_between_beats:Float;

    /**
     * Time between steps in milliseconds.
     */
    public static var time_between_steps:Float;

    /**
     * Current 'beat' or 4th note of the song that's playing.
     */
    public static var beat:Int;

    /**
     * Current 'beat' or 4th note of the song that's playing. (`Float` version)
     */
    public static var beat_f:Float;

    /**
     * Current 'step' or 16th note of the song that's playing.
     */
    public static var step:Int;

    /**
     * Current 'step' or 16th note of the song that's playing. (`Float` version)
     */
    public static var step_f:Float;

    ///**
    // * An array of all bpm changes for the song that's playing.
    // */
    // TODO: Implement this lmao
    //public static var bpm_changes:Array<BPMChange> = [];

    public static var safe_frames:Int = 10;

    public static var safe_zone_offset:Float = (safe_frames / 60.0) * 1000.0;

    /**
     * Changes the current bpm and recalculates values in relation to it.
     * 
     * @param new_bpm BPM to change to
     * @author Leather128
     */
     public static function set_bpm(new_bpm:Float):Float {
        // this is dumb but whatever lol
        bpm = new_bpm;
        recalculate_values();
        return bpm;
    }

    /**
     * Recalculates all values related to the current bpm.
     * @author Leather128
     */
    public static function recalculate_values():Void {
        time_between_beats = (60.0 / bpm) * 1000.0;
        // 4 steps per beat for now (only works on 4/4!)
        // TODO: make an option to have different time signatures
        time_between_steps = time_between_beats / 4.0;
    }
}