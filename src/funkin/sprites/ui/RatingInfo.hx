package funkin.sprites.ui;

/**
 * Little sprite group to make rating info creation easy.
 * @author Leather128
 */
class RatingInfo extends flixel.group.FlxSpriteGroup {
    /**
     * Container for the info about `this`.
     */
    public var data:RatingData;

    /**
     * `Sprite` for the rating used.
     */
    public var rating:Sprite;

    /**
     * `FlxSpriteGroup` of all the current combo number sprites.
     */
    public var numbers:flixel.group.FlxSpriteGroup = new flixel.group.FlxSpriteGroup();

    public function new(x:Float = 0.0, y:Float = 0.0, data:RatingData) {
        super(x, y);
        
        this.data = data;

        rating = new Sprite().load('gameplay/ui/ratings/${data.rating}', IMAGE, [ 'persist' => true ]);
        rating.scale.set(0.7, 0.7); rating.updateHitbox();

        rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

        flixel.tweens.FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.time_between_beats * 0.001,
            onComplete: function(_):Void { remove(rating, true); rating.destroy(); }
		});

        add(rating);

        var string_combo:String = Std.string(data.combo);

        for (i in 0...string_combo.length) {
            var num:String = string_combo.charAt(i);

            // og code: numScore.x = coolText.x + (43 * daLoop) - 90;

            var num_spr:Sprite = new Sprite(43.0 * i).load('gameplay/ui/numbers/num${num}', IMAGE, [ 'persist' => true ]);
            num_spr.y += 80.0;
            num_spr.scale.set(0.5, 0.5); num_spr.updateHitbox();

			num_spr.acceleration.y = FlxG.random.int(200, 300);
			num_spr.velocity.y -= FlxG.random.int(140, 160);
			num_spr.velocity.x = FlxG.random.float(-5.0, 5.0);

            add(num_spr);

            flixel.tweens.FlxTween.tween(num_spr, {alpha: 0}, 0.2, {
				onComplete: function(_):Void { remove(num_spr, true); num_spr.destroy(); },
				startDelay: Conductor.time_between_beats * 0.002
			});
        }
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (members.length == 0) destroy();
    }
}

/**
 * `typedef` to store data about one `RatingInfo`.
 * @author Leather128
 */
typedef RatingData = {
    /**
     * Rating to display.
     */
    var rating:String;

    /**
     * Note Combo of the rating.
     */
    var combo:Int;

    // other shit later
}