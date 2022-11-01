package funkin.utils;

/**
 * JSON Data for any song in the game.
 * @author Leather128
 */
 typedef Song = {
    /**
     * Song name.
     */
    var song:String;

	/**
	 * Array of sections of notes in the song.
	 */
	var notes:Array<Section>;

	/**
	 * Song bpm (Beats Per Minute).
	 */
	var bpm:Float;

	/**
	 * Toggle for having a `Voices` audio file in the song.
	 */
	var needsVoices:Bool;

	/**
	 * Song scroll speed.
	 */
	var speed:Float;

	/**
	 * Song Player 1 (BF).
	 */
	var player1:String;

	/**
	 * Song Player 2 (Opponent).
	 */
	var player2:String;

	/**
	 * Whether or not to save the song's score to freeplay / story mode.
	 */
	var validScore:Bool;
}

/**
 * JSON Data for any section in a song.
 * @author Leather128
 */
typedef Section = {
	/**
	 * Array of notes in the section, notes are stored in this format:
     * 
     * `[strum_time, note_data, sustain_length]`
	 */
	var sectionNotes:Array<Dynamic>;

	/**
	 * Length of the section in steps (16 is the default).
	 */
	var lengthInSteps:Int;

	/**
	 * Whether or not this section is one that focuses on Player 1 (BF).
	 */
	var mustHitSection:Bool;

    /**
     * Whether or not the opponent in this section should use alt animations for singing.
     */
    var altAnim:Bool;

	/**
	 * BPM to change to (see `changeBPM`).
	 */
	var bpm:Float;

	/**
	 * Whether or not to change the song's bpm at the start of this section.
	 */
	var changeBPM:Bool;
}

/**
 * Helper class to load songs easier
 * @author Leather128
 */
class SongHelper {
    /**
     * Loads song from `path` and returns it.
     * @param path Path of the song to load (ex: `tutorial/normal` or `tutorial/normal.json`).
     * @return The song at `path` (if it exists).
     */
    public static function load_song(path:String):Song {
        if (!path.endsWith('.json')) path += '.json';
        var raw_data:String;

        try {
            raw_data = Assets.text('songs/${path}').trim();
        } catch(e) {
            trace('songs/${path} failed to load! Reloading into TitleScreen.hx as fallback!', ERROR);
            FlxG.switchState(new funkin.scenes.TitleScreen());

            return null;
        }

        return cast Json.parse(raw_data).song;
    }
}