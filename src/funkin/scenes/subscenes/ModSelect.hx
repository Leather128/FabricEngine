package funkin.scenes.subscenes;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

/**
 * Subscene to allow you to select a mod from anywhere supported.
 * @author Leather128
 */
class ModSelect extends FunkinSubScene {
	var hud_camera:flixel.FlxCamera = new flixel.FlxCamera();

	public var mods:FlxTypedSpriteGroup<funkin.sprites.ui.MenuMod> = new FlxTypedSpriteGroup<funkin.sprites.ui.MenuMod>();

	/**
	 * Current index of the mod selected.
	 */
	public var index:Int = 0;

	public function new() {
		super();

		hud_camera.bgColor.alpha = 0;
		FlxG.cameras.add(hud_camera, false);

		var bg:Sprite = cast new Sprite().makeGraphic(FlxG.width - 16, FlxG.height - 16, flixel.util.FlxColor.BLACK);
		bg.screenCenter();
		bg.alpha = 0.6;
		bg.cameras = [hud_camera];
		add(bg);

		mods.cameras = [hud_camera];
		add(mods);

		// reads all folders / files in the assets folder
		for (dir in sys.FileSystem.readDirectory(Assets.absolute_path('assets'))) {
			if (!sys.FileSystem.isDirectory(Assets.absolute_path('assets/${dir}')))
				continue;

			if (dir == Assets.preferred_mod)
				index = mods.length;

			var mod:funkin.sprites.ui.MenuMod = new funkin.sprites.ui.MenuMod(0, (70.0 * (mods.length - 1)), dir, mods.length);
			mods.add(mod);
		}

		// dont load the menu if we literally have 0 or 1 mods
		if (mods.length < 2) {
			close();
			return;
		}

		change_selection();
	}

	override function update(elapsed:Float):Void {
		if (Input.is('exit')) {
			FlxG.cameras.remove(hud_camera);
			close();
		}

		if (Input.is('accept')) {
			Assets.preferred_mod = mods.members[index].mod_name;
			Save.set('mod', Assets.preferred_mod, 'engine');

			FlxG.cameras.remove(hud_camera);
			close();
			FlxG.resetState();
		}

		var vertical_axis:Int = (Input.is('down') ? 1 : 0) - (Input.is('up') ? 1 : 0);
		if (vertical_axis != 0)
			change_selection(vertical_axis);

		super.update(elapsed);
	}

	/**
	 * Changes the current selection in the menu by `amount`.
	 * @param amount Change in index (1 = one down, -1 = one up, etc)
	 */
	public function change_selection(amount:Int = 0):Void {
		index = flixel.math.FlxMath.wrap(index + amount, 0, mods.length - 1);

		FlxG.sound.play(Assets.audio('sfx/menus/scroll'));

		mods.forEach(function(item:funkin.sprites.ui.MenuMod):Void {
			item.alpha = mods.members.indexOf(item) == index ? 1 : 0.6;
			item.index = mods.members.indexOf(item) - index;
		});
	}
}
