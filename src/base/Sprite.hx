package base;

/**
 * Simple extension to `flixel.FlxSprite` that is used for easier handling of
 * basic things that should be defaults.
 * @author Leather128
 */
class Sprite extends flixel.FlxSprite {
	/**
	 * Map of the offsets for different animations in this sprite.
	 */
	public var offsets:Map<String, flixel.math.FlxPoint> = [];

	/**
	 * Toggle for playing animations that aren't forced.
	 */
	public var play_animations:Bool = true;

	// Literally the same as the normal new function but automatically sets antialiasing to true.
	public function new(?x:Float = 0.0, ?y:Float = 0.0, ?antialiased:Null<Bool> = null) {
		super(x, y);
		if (antialiased != null) antialiasing = antialiased;
	}

	/**
	 * Loads the specified asset into this sprite.
	 * 
	 * @param path Path to asset (starts in folder already, ex: assets/images/ not needed).
	 * @param type `base.assets.AssetType` to represent the type of asset to load.
	 * @param options Map of options to use when loading the asset.
	 * @return `this` (chaining purposes).
	 */
	public function load(path:String, ?type:base.assets.AssetType = IMAGE, ?options:Map<Dynamic, Dynamic> = null):Sprite {
		// Most of the time this is true, but adding extra checks would probably make the code worse anyways
		if (options == null)
			options = new Map<Dynamic, Dynamic>();
		// Account for if someone used the image extension at the end of a path (not wanted in some cases, ex: would break SPARROW).
		if (path.endsWith(Assets.IMAGE_EXT))
			path.substring(0, path.length - Assets.IMAGE_EXT.length);

		// Load different types of assets.
		switch (type) {
			case IMAGE:
				if (options.get('images_folder') != false)
					loadGraphic(Assets.image('images/${path}', options['persist'], options['mod']), options['animated'], options['width'], options['height']);
				else
					loadGraphic(Assets.image('${path}', options['persist'], options['mod']), options['animated'], options['width'], options['height']);
			case SPARROW:
				if (options.get('images_folder') != false)
					frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(Assets.image('images/${path}', options['persist'], options['mod']),
						Assets.text('images/${path}.xml'));
				else
					frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(Assets.image('${path}', options['persist'], options['mod']),
						Assets.text('${path}.xml'));
			default:
				trace('${type} is unsupported to be loaded in a Sprite!', WARNING);
		}

		// Update hitbox because yeah sometimes we need to ok?
		updateHitbox();

		return this;
	}

	/**
	 * Adds animation to this sprite.
	 * 
	 * @param name Name of the animation.
	 * @param prefix Prefix of the animation in the spritesheet.
	 * @param framerate Framerate of the animation (FPS).
	 * @param looped Whether the animation is looped.
	 * @param indices (Optional) List of ints corresponding to the frames to use.
	 * @return `this` (chaining purposes).
	 */
	public function add_animation(name:String, prefix:String, ?framerate:Int = 24, ?looped:Bool = false, ?indices:Array<Int>, ?offset:Array<Float>):Sprite {
		// actual animation adding
		if (indices != null)
			animation.addByIndices(name, prefix, indices, '', framerate, looped);
		else
			animation.addByPrefix(name, prefix, framerate, looped);
		// offsets
		if (offset != null)
			offsets.set(name, new flixel.math.FlxPoint(offset[0], offset[1]));

		return this;
	}

	/**
	 * Play the specified animation using `animation.play()`.
	 * @param name Name of the animation to play.
	 * @param forced Whether or not to force it to play.
	 * @param reverse Whether or not the animation is reversed.
	 * @param frame The frame to start the animation on.
	 * @return `this` (chaining purposes).
	 */
	public function play_animation(name:String, ?forced:Bool = false, ?reverse:Bool = false, ?frame:Int = 0):Sprite {
		if (!forced && !play_animations) return this;
		
		if (animation.exists(name))
			animation.play(name, forced, reverse, frame);
		// offsets
		if (animation.exists(name) && offsets.exists(name))
			offset.copyFrom(offsets.get(name));

		return this;
	}
}
