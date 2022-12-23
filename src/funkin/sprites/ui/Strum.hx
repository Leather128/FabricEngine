package funkin.sprites.ui;

/**
 * Strum / Receptor for the notes.
 * @author Leather128
 */
class Strum extends Sprite {
	/**
	 * Current ID of the `Strum` (usually from 0 to 3).
	 */
	public var id:Int = -1;

	/**
	 * Default position for this strum (used for easier modcharting).
	 */
	public var default_position:flixel.math.FlxPoint = new flixel.math.FlxPoint();

	/**
	 * Creates new `Strum` with specified parameters.
	 * @param x X
	 * @param y Y
	 * @param id ID of the strum (usually from 0 to 3 to signify note direction)
	 * @param texture (Optional) Texture to use for the strum (starts in `assets/images/gameplay/ui/notes/strum-`)
	 * @param antialiased (Optional) Antialiased parameter (from `Sprite`).
	 */
	public function new(x:Float = 0.0, y:Float = 0.0, id:Int = 0, ?texture:String = 'default', ?antialiased:Bool = true) {
		super(x, y, antialiased);

		ID = id;
		this.id = id;
		load('gameplay/ui/notes/strum-${texture}', SPARROW);

		add_animation('default', '${Note.NOTE_DIRECTIONS[4][id]} static', 24, true);
		add_animation('press', '${Note.NOTE_DIRECTIONS[4][id]} press', 24, false);
		add_animation('confirm', '${Note.NOTE_DIRECTIONS[4][id]} confirm', 24, false, null, [-13, -13]);

		play_animation('default');

		scale.set(0.7, 0.7);
		updateHitbox();
	}

	override public function play_animation(name:String, ?forced:Bool = false, ?reverse:Bool = false, ?frame:Int = 0):base.Sprite {
		super.play_animation(name, forced, reverse, frame);

		centerOffsets();
		if (offsets.exists(name))
			offset.add(offsets.get(name).x, offsets.get(name).y);

		return this;
	}
}
