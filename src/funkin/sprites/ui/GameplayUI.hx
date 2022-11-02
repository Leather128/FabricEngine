package funkin.sprites.ui;

class GameplayUI extends flixel.group.FlxSpriteGroup {
    public var health_bar:HealthBar;

    public function new() {
        super();

        health_bar = new HealthBar(FlxG.height * 0.1);
        add(health_bar);
    }

    public function on_beat():Void {
        health_bar.on_beat();
    }
}