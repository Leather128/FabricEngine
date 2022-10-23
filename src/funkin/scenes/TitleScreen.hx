package funkin.scenes;

import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import funkin.sprites.ui.Alphabet;

/**
 * The title screen for the game.
 * @author Leather128
 */
class TitleScreen extends FunkinScene {
    // xml data :D
	var data:haxe.xml.Access = new haxe.xml.Access(Xml.parse(Assets.text('data/intro-text.xml')).firstElement());

    // sprites
	var title:Sprite = new Sprite(-150, -100).load('menus/title/logo', SPARROW);
    var gf:Sprite = new Sprite(FlxG.width * 0.4, FlxG.height * 0.07).load('menus/title/gf', SPARROW);
    var enter:Sprite = new Sprite(100, FlxG.height * 0.8).load('menus/title/enter', SPARROW);

    public static var music_title:String = 'normal';

    public static var initialized:Bool = false;

	override function create():Void {
		super.create();

        // how to preload audio part 1:
        Assets.audio('sfx/menus/confirm');

        new flixel.util.FlxTimer().start(1, function(_):Void {
            if (!initialized) {
                // copied from base game lmfao
                var diamond:flixel.graphics.FlxGraphic = flixel.graphics.FlxGraphic.fromClass(flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond);
                diamond.persist = true;

                FlxTransitionableState.defaultTransIn = new TransitionData(FADE, flixel.util.FlxColor.BLACK, 1, new flixel.math.FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
                    new flixel.math.FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
                FlxTransitionableState.defaultTransOut = new TransitionData(FADE, flixel.util.FlxColor.BLACK, 0.7, new flixel.math.FlxPoint(0, 1),
                    {asset: diamond, width: 32, height: 32}, new flixel.math.FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

                transIn = FlxTransitionableState.defaultTransIn;
                transOut = FlxTransitionableState.defaultTransOut;

                Conductor.bpm = Std.parseFloat(data.att.bpm);
                play_music('normal');
                FlxG.sound.music.fadeIn(4, 0, 0.7);

                initialized = true;
            }

            gf.add_animation('danceLeft', 'gfDance', 24, false, [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
            gf.add_animation('danceRight', 'gfDance', 24, false, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]);
            gf.play_animation('danceLeft', true);
            add(gf);

            title.add_animation('bump', 'logo bumpin');
            title.play_animation('bump', true);
            add(title);

            enter.add_animation('idle', 'Press Enter to Begin', 24, true);
            enter.add_animation('press', 'ENTER PRESSED', 24, true);
            enter.play_animation('idle', true);
            add(enter);
        });
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        // cleaner code lol!!!
        if (!initialized) return;

        Conductor.song_position_raw = FlxG.sound.music.time;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        if (Input.is('accept')) {
            enter.play_animation('press', true);

            FlxG.camera.flash(flixel.util.FlxColor.WHITE, 1);
            FlxG.sound.play(Assets.audio('sfx/menus/confirm'), 0.7);

            FlxG.switchState(new MainMenu());
        }

        if (Input.is('exit')) openfl.system.System.exit(0);
    }

    override function on_beat():Void {
        super.on_beat();

        title.play_animation('bump', true);
        gf.play_animation(gf.animation.curAnim.name == 'danceLeft' ? 'danceRight' : 'danceLeft', true);
    }

    /**
     * Plays the title screen music.
     * @param force_file Forcefully use a different file to play if you want.
     * @author Leather128
     */
    public static function play_music(?force_file:String):Void {
        music_title = Date.now().getDay() == 5 ? 'friday' : 'normal';
        if (force_file != null) music_title = force_file;

        FlxG.sound.playMusic(Assets.audio('music/menus/${music_title}'));
    }
}
