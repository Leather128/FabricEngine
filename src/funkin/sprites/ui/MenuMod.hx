package funkin.sprites.ui;

import flixel.math.FlxMath;

/**
 * UI Element to represent a mod to select in the `ModSelect` menu.
 * 
 * (based off of `FreeplaySong`)
 * @author Leather128
 */
class MenuMod extends flixel.group.FlxSpriteGroup {
	/**
	 * Index of this song in a list of songs.
	 */
	public var index:Int = 0;

	/**
	 * Name of this mod.
	 */
	public var mod_name:String;

	/**
	 * Current mod alphabet in this mod.
	 */
	public var mod:Alphabet;

	/**
	 * Current health icon in this mod.
	 */
	public var icon:funkin.sprites.TrackingSprite;

	/**
	 * Current mod data.
	 */
	public var mod_data:haxe.xml.Access;

	public function new(x:Float = 0.0, y:Float = 0.0, mod_name:String, ?index:Int = 0) {
		super(x, y);
		this.index = index;
		this.mod_name = mod_name;

		mod_data = new haxe.xml.Access(Xml.parse(Assets.text('mod.xml', mod_name)).firstElement().elementsNamed('meta').next());

		// start spawning sprites

		mod = new Alphabet(0, 0, mod_data.node.title.innerData);
		add(mod);

		icon = new funkin.sprites.TrackingSprite();
		icon.load('mod', IMAGE, ['images_folder' => false, 'mod' => mod_name]);
		icon.tracked = mod;
		icon.setGraphicSize(150, 150);
		icon.updateHitbox();
		add(icon);
	}

	override function update(elapsed:Float):Void {
		var remapped_y:Float = FlxMath.remapToRange(index, 0, 1, 0, 1.3);
		// 60 fps elasped = 0.016, old lerp was 0.16, so around 10x elapsed is accurate
		setPosition(FlxMath.lerp(x, (index * 20.0) + 90.0, elapsed * 10.0), FlxMath.lerp(y, (remapped_y * 120.0) + (FlxG.height * 0.48), elapsed * 10.0));

		super.update(elapsed);
	}
}
