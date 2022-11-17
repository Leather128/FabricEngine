package funkin.sprites.ui;

/**
 * A note in the game.
 * @author Leather128
 */
class Note extends Sprite {
    /**
     * `Map` of `Int`s (amounts of keys) to `Array`s of `String`s of the note directions.
     */
    public static var NOTE_DIRECTIONS:Map<Int, Array<String>> = [
        4 => ['left', 'down', 'up', 'right']
    ];

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

    public function new(is_player:Bool, strum_time:Float, id:Int, ?sustain_length:Float = 0.0, ?texture:String = 'default', ?antialiased:Bool = true) {
        super(antialiased);

        ID = id;
        this.id = id;
        this.strum_time = strum_time;
        this.sustain_length = sustain_length;
        this.is_player = is_player;

        load('gameplay/ui/notes/note-${texture}', SPARROW);

        add_animation('default', '${NOTE_DIRECTIONS[4][id]}0', 24, true);
        play_animation('default');

        scale.set(0.7, 0.7);
        updateHitbox();
    }
}