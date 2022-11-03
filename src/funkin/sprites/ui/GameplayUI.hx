package funkin.sprites.ui;

import funkin.scenes.Gameplay;

class GameplayUI extends flixel.group.FlxSpriteGroup {
	public var health_bar:HealthBar;

	public function new() {
		super();

		if (Gameplay.instance != null)
			health_bar = new HealthBar(FlxG.height * 0.1, Gameplay.instance.bf.icon, Gameplay.instance.dad.icon, Gameplay.instance.bf.health_color,
				Gameplay.instance.dad.health_color);
		else health_bar = new HealthBar(FlxG.height * 0.1);
		add(health_bar);
	}

	public function on_beat():Void {
		health_bar.on_beat();
	}
}
