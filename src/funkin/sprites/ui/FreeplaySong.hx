package funkin.sprites.ui;

import flixel.math.FlxMath;

/**
 * UI Element to represent a song you can play in the `Freeplay` menu.
 * @author Leather128
 */
class FreeplaySong extends flixel.group.FlxSpriteGroup {
	// All of these are equivalents to the variables in 'FreeplaySongData'
	public var song_name:String = 'Test';
	public var song_icon:String = 'face';
	public var song_icon_antialiased:Bool = true;
	public var song_color:flixel.util.FlxColor = flixel.util.FlxColor.WHITE;
	public var song_difficulties:Array<String> = ['EASY', 'NORMAL', 'HARD'];
	public var song_bpm:Float = 0.0;

	/**
	 * Current song alphabet in this freeplay song.
	 */
	public var song:Alphabet;

	/**
	 * Current health icon in this freeplay song.
	 */
	public var icon:HealthIcon;

	public function new(x:Float = 0.0, y:Float = 0.0, song_info:FreeplaySongData, ?index:Int = 0) {
		super(x, y);

		// set properties
		song_name = song_info.name;
		song_icon = song_info.icon;

		if (song_info.color != null)
			song_color = song_info.color;
		if (song_info.difficulties != null)
			song_difficulties = song_info.difficulties;
		if (song_info.icon_antialiased != null)
			song_icon_antialiased = song_info.icon_antialiased;
		if (song_info.bpm != null)
			song_bpm = song_info.bpm;

		// start spawning sprites

		song = new Alphabet(0, 0, song_name);
		song.is_menu_item = true;
		song.ID = index;
		add(song);

		icon = new HealthIcon(0, 0, song_icon, song_icon_antialiased);
		icon.tracked = song;
		add(icon);
	}
}

/**
 * Data for any given song in the freeplay menu.
 * @author Leather128
 */
typedef FreeplaySongData = {
	/**
	 * Name of the song.
	 */
	var name:String;

	/**
	 * Health Icon of the song.
	 */
	var icon:String;

	/**
	 * Health Icon's antialiasing setting.
	 */
	var ?icon_antialiased:Null<Bool>;

	/**
	 * Background color of the song.
	 */
	var ?color:Null<flixel.util.FlxColor>;

	/**
	 * Difficulties of the song.
	 */
	var ?difficulties:Null<Array<String>>;

	/**
	 * BPM (Beats per minute) of the song.
	 */
	var ?bpm:Null<Float>;
}
