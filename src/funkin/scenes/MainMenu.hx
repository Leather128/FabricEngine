package funkin.scenes;

import funkin.sprites.ui.AtlasList;

/**
 * The main menu of the game.
 * @author Leather128
 */
class MainMenu extends FunkinScene {
	// background lmao
	var bg:Sprite = new Sprite().load('menus/background');

	/**
	 * Object that the current camera follows.
	 */
	public var cam_follow:flixel.FlxObject = new flixel.FlxObject(0, 0, 1, 1);

	/**
	 * `AtlasList` for all the items in this menu.
	 */
	public var menu_list:AtlasList = new AtlasList();

	override function create():Void {
		super.create();

		if (!FlxG.sound.music.playing)
			TitleScreen.play_music();

		bg.scrollFactor.set(0.0, 0.17);
		bg.scale.set(1.2, 1.2);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		var magenta:Sprite = new Sprite().load('menus/background_grayscale');
		magenta.scrollFactor.copyFrom(bg.scrollFactor);
		magenta.scale.copyFrom(bg.scale);
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFD719B;
		add(magenta);

		// Add the items
		var story_mode:AtlasItem = menu_list.add_item(0, 0, 'menus/main/items', {
			unselected: {name: 'story mode idle', framerate: 24, looped: true},
			selected: {
				name: 'story mode selected',
				framerate: 24,
				looped: true
			}
		});
		story_mode.scrollFactor.set();
		story_mode.on_selected.add(function(item:AtlasItem):Void {
			switch_scene(new StoryMenu());
		});

		var freeplay:AtlasItem = menu_list.add_item(0, 0, 'menus/main/items', {
			unselected: {name: 'freeplay idle', framerate: 24, looped: true},
			selected: {
				name: 'freeplay selected',
				framerate: 24,
				looped: true
			}
		});
		freeplay.scrollFactor.set();
		freeplay.on_selected.add(function(item:AtlasItem):Void {
			switch_scene(new Freeplay());
		});

		var options:AtlasItem = menu_list.add_item(0, 0, 'menus/main/items', {
			unselected: {name: 'options idle', framerate: 24, looped: true},
			selected: {
				name: 'options selected',
				framerate: 24,
				looped: true
			}
		});
		options.scrollFactor.set();
		options.on_selected.add(function(item:AtlasItem):Void {
			switch_scene(new OptionsMenu());
		});

		// Position the items
		var initial_y:Float = (FlxG.height - 160.0 * (menu_list.length - 1.0)) / 2.0;

		for (i in 0...menu_list.length)
			menu_list.members[i].setPosition(FlxG.width / 2.0, initial_y + (160.0 * i));

		// Add some event handlers
		menu_list.on_select.add(function(item:AtlasItem):Void {
			cam_follow.setPosition(item.getGraphicMidpoint().x, item.getGraphicMidpoint().y);
		});
		menu_list.on_accept.add(function(item:AtlasItem):Void {
			flixel.effects.FlxFlicker.flicker(magenta, 1.1, 0.15, false, true);
		});

		// Automatically call on_select for correct camera movement
		menu_list.change_selection();
		add(menu_list);

		// Version text
		var version_text:flixel.text.FlxText = new flixel.text.FlxText(5, FlxG.height - 18, 0, 'v${Main.version}', 16);
		version_text.scrollFactor.set();
		version_text.setFormat(Assets.font('vcr.ttf'), 16, flixel.util.FlxColor.WHITE, LEFT, OUTLINE, flixel.util.FlxColor.BLACK);
		add(version_text);

		FlxG.camera.follow(cam_follow, null, 0.06);
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if (Input.is('exit'))
			FlxG.switchState(new TitleScreen());
		if (Input.is('nine'))
			FlxG.switchState(new ScriptedScene('Test'));
	}

	/**
	 * Switch game's scene.
	 * @param next_scene Scene to switch to.
	 */
	public function switch_scene(next_scene:FunkinScene):Void {
		menu_list.enabled = false;
		menu_list.forEach(function(item:AtlasItem) {
			if (menu_list.selected_index != item.ID)
				flixel.tweens.FlxTween.tween(item, {alpha: 0}, 0.4, {ease: flixel.tweens.FlxEase.quadOut});
			else
				item.visible = false;
		});

		new flixel.util.FlxTimer().start(0.4, function(_):Void {
			FlxG.switchState(next_scene);
		});
	}
}
