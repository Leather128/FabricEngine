package funkin.sprites.ui;

/**
 * A note in the game.
 * @author Leather128
 */
class Note extends Sprite {
	/**
	 * `Map` of `Int`s (amounts of keys) to `Array`s of `String`s of the note directions.
	 */
	public static var NOTE_DIRECTIONS:Map<Int, Array<String>> = [4 => ['left', 'down', 'up', 'right']];

	/**
	 * Default width for any note (used for placing `Strum`s correctly).
	 */
	public static var DEFAULT_WIDTH:Float = 154.0 * 0.7;

	/**
	 * Current ID of the `Strum` (usually from 0 to 3).
	 */
	public var id:Int = -1;

	/**
	 * Current time of the note in the song in milliseconds.
	 */
	public var strum_time:Float = -1;

	/**
	 * Length of the sustain / hold note for this note in milliseconds.
	 */
	public var sustain_length:Float = -1;

	/**
	 * Whether or not this note is part of a sustain.
	 */
	public var is_sustain(get, never):Bool;

	private function get_is_sustain():Bool
		return sustain_length > 0.0;

	/**
	 * Whether or not this note is the end of a sustain.
	 * (`null` if not a sustain)
	 */
	public var is_sustain_end:Null<Bool> = null;

	/**
	 * Array of all sustain notes attached to this note.
	 */
	public var sustain_notes:Array<Note> = [];

	/**
	 * Parent of a sustain note (base regular note it's from).
	 */
	public var sustain_parent:Note;

	/**
	 * Variable for if a note was hit or not (used only in sustain notes atm).
	 */
	public var was_hit:Bool = false;

	/**
	 * Is this note meant to be hit by the player?
	 */
	public var is_player:Bool = false;

	/**
	 * Raw note data.
	 */
	public var raw_data:Array<Dynamic>;

	/**
	 * Current type of this note.
	 */
	public var type:String = 'default';

	public function new(is_player:Bool, strum_time:Float, id:Int, ?sustain_length:Float = 0.0, ?is_sustain_end:Null<Bool>, ?texture:String = 'default',
			?type:String = 'default', ?antialiased:Bool = true) {
		super(antialiased);

		ID = id;
		this.id = id;
		this.strum_time = strum_time;
		this.sustain_length = sustain_length;
		this.is_sustain_end = is_sustain_end;
		this.is_player = is_player;
		this.type = type;

		load('gameplay/ui/notes/note-${texture}', SPARROW);

		if (!is_sustain)
			add_animation('default', '${NOTE_DIRECTIONS[4][id]}0', 24, true);
		else {
			add_animation('default', '${NOTE_DIRECTIONS[4][id]} hold${this.is_sustain_end ? ' end' : ''}0', 24, true);
			alpha = 0.6;
		}

		play_animation('default');

		scale.set(0.7, 0.7 * (is_sustain
			&& !is_sustain_end ? Conductor.time_between_steps / 100.0 * 1.5 * funkin.scenes.Gameplay.song.speed : 1.0));
		updateHitbox();
	}
}
