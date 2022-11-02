package funkin.sprites.ui;

import flixel.util.FlxColor;

/**
 * Health Bar in the game's ui (includes health bar AND score text).
 * @author Leather128
 */
class HealthBar extends flixel.group.FlxSpriteGroup {
    public static final ICON_OFFSET:Int = 26;
    
    public var health_value:Float = 1.0;

    public var bar_bg:Sprite = new Sprite(0.0, 0.0).load('gameplay/ui/health_bar');
    public var bar:flixel.ui.FlxBar;

    public var player_icon:HealthIcon;
    public var opponent_icon:HealthIcon;

    public var score_text:flixel.text.FlxText = new flixel.text.FlxText();

    public function new(y:Float = 0.0, player_icon:String = 'bf', opponent_icon:String = 'dad', player_color:FlxColor = FlxColor.LIME, opponent_color:FlxColor = FlxColor.RED) {
        super(0.0, y);

        // create health bar
        bar = new flixel.ui.FlxBar(bar_bg.x + 4.0, bar_bg.y + 4.0, RIGHT_TO_LEFT, Std.int(bar_bg.width - 8), Std.int(bar_bg.height - 8), this,
            'health_value', 0, 2);
        bar.createFilledBar(opponent_color, player_color);

        // create score text
        score_text.setPosition(bar_bg.x + bar_bg.width - 190.0, bar_bg.y + 30.0); score_text.antialiasing = true;
        score_text.setFormat(Assets.font('vcr.ttf'), 16, flixel.util.FlxColor.WHITE, RIGHT, OUTLINE, flixel.util.FlxColor.BLACK);

        // create icons
        this.player_icon = new HealthIcon(0.0, 0.0, player_icon); this.player_icon.flipX = true; this.player_icon.y = bar.y - (this.player_icon.height / 2.0);
        this.opponent_icon = new HealthIcon(0.0, 0.0, opponent_icon); this.opponent_icon.y = bar.y - (this.opponent_icon.height / 2.0);

        // layering
        add(bar_bg);
        add(bar);

        add(this.player_icon);
        add(this.opponent_icon);

        add(score_text);

        screenCenter(X);
    }

    override function update(elapsed:Float):Void {
		player_icon.x = bar.x + (bar.width * (flixel.math.FlxMath.remapToRange(bar.percent, 0, 100, 100, 0) * 0.01) - ICON_OFFSET);
		opponent_icon.x = bar.x + (bar.width * (flixel.math.FlxMath.remapToRange(bar.percent, 0, 100, 100, 0) * 0.01)) - (opponent_icon.width - ICON_OFFSET);

		if (health_value > 2) health_value = 2;

        player_icon.play_animation(bar.percent > 20 ? 'alive' : 'dead');
        opponent_icon.play_animation(bar.percent < 80 ? 'alive' : 'dead');

        if (funkin.scenes.Gameplay.instance != null) score_text.text = 'Score:${funkin.scenes.Gameplay.instance.score}';
        else score_text.text = 'Score:N/A';

        player_icon.scale.set(flixel.math.FlxMath.lerp(player_icon.scale.x, 1.0, elapsed * 9.0), flixel.math.FlxMath.lerp(player_icon.scale.y, 1.0, elapsed * 9.0));
        // lmao efficiency or something maybe? (prolly not but whatever)
        opponent_icon.scale.copyFrom(player_icon.scale);

        player_icon.updateHitbox(); opponent_icon.updateHitbox();

        super.update(elapsed);
    }

    public function on_beat():Void {
        player_icon.scale.add(0.2, 0.2);
        opponent_icon.scale.copyFrom(player_icon.scale);

        player_icon.updateHitbox(); opponent_icon.updateHitbox();
    }
}