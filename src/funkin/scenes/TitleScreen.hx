package funkin.scenes;

import flixel.util.FlxColor;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxSpriteGroup;
import funkin.sprites.ui.Alphabet;

/**
 * The title screen for the game.
 * @author Leather128
 */
class TitleScreen extends FunkinScene {
	/**
	 * Current intro xml data.
	 */
	var data:haxe.xml.Access = new haxe.xml.Access(Xml.parse(Assets.text('data/intro-text.xml')).firstElement());

    /**
     * Array of all the xml line objects.
     */
    var lines:Array<haxe.xml.Access> = [];

    /**
     * Map of `String`s to the value of that randomized line of text.
     */
    var randomized_lines:Map<String, Dynamic> = new Map<String, Dynamic>();

    /**
     * Group of all the current other sprites on screen.
     */
    var intro_sprites:FlxSpriteGroup = new FlxSpriteGroup();

    /**
     * Group of all the current `Alphabet` instances on screen.
     */
    var intro_lines:FlxTypedSpriteGroup<Alphabet> = new FlxTypedSpriteGroup<Alphabet>();

    // sprites
	var title:Sprite = new Sprite(-150, -100).load('menus/title/logo', SPARROW);
    var gf:Sprite = new Sprite(FlxG.width * 0.4, FlxG.height * 0.07).load('menus/title/gf', SPARROW);
    var enter:Sprite = new Sprite(100, FlxG.height * 0.8).load('menus/title/enter', SPARROW);

    /**
     * Music file name
     */
    public static var music_title:String = 'normal';

    /**
     * Has TitleScreen been loaded at least once?
     */
    public static var initialized:Bool = false;

    /**
     * Is the game currently in the intro (credits).
     */
    public static var in_intro:Bool = true;

    /**
     * Has the user already pressed enter to exit the menu?
     */
    var pressed_enter:Bool = false;

	override function create():Void {
		super.create();

        // we preload shit sometimes because performance?!?!?! //

        // how to preload audio part 1:
        Assets.audio('sfx/menus/confirm');

        lines = data.node.lines.nodes.line;

        // preload images that show up in the intro
        for (line in lines) if (line.att.type == 'sprite') Assets.image('images/menus/title/sprites/${line.att.value}');

        // overengineered as hell lol
        for (randomized_text in data.node.randomized_text.nodes.text) {
            var original_lines:Array<String> = Assets.text(randomized_text.att.path).trim().split('\n');
            var split_lines:Array<Array<String>> = [];

            for (data in original_lines) split_lines.push(data.split(randomized_text.att.delimeter));
            
            var value:Array<String> = FlxG.random.getObject(split_lines);
            var keys:Array<String> = randomized_text.att.values.trim().split(',');
            
            for (i in 0...keys.length) {
                if (value.length - 1 >= i)
                    randomized_lines.set(randomized_text.att.key + keys[i], value[i]);
            }
        }

        // so both are true
        persistentUpdate = persistentDraw;

        new flixel.util.FlxTimer().start(1, function(_):Void {
            Conductor.bpm = Std.parseFloat(data.att.bpm);
            play_music('normal');
            FlxG.sound.music.fadeIn(4, 0, 0.7);
            
            if (!initialized) {
                // copied from base game lmfao
                var diamond:flixel.graphics.FlxGraphic = flixel.graphics.FlxGraphic.fromClass(flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond);
                diamond.persist = true;

                FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				    new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			    FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				    {asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

                transIn = FlxTransitionableState.defaultTransIn;
                transOut = FlxTransitionableState.defaultTransOut;

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

            // make everything invisible at the start
            gf.visible = title.visible = enter.visible = false;

            add(intro_sprites);
            add(intro_lines);

            FlxG.mouse.visible = false;

            if (!in_intro) exit_intro();
        });
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        // cleaner code lol!!!
        if (!initialized) return;

        if (!in_intro && Input.is('mod_select')) openSubState(new funkin.scenes.subscenes.ModSelect());
        if (Input.is('exit')) {
            FlxG.sound.play(Assets.audio('sfx/menus/cancel'), 0.75).onComplete = function():Void {
                trace('Exiting the game!', LOG);
                openfl.system.System.exit(0);
            };
        }

        // song position
        Conductor.song_position_raw = FlxG.sound.music.time;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        // go to main menu lol
        if (Input.is('accept') && !in_intro) {
            if (pressed_enter) return;
            pressed_enter = true;

            enter.play_animation('press', true);

            FlxG.camera.flash(flixel.util.FlxColor.WHITE, 1);
            FlxG.sound.play(Assets.audio('sfx/menus/confirm'), 0.7);

            FlxG.switchState(new MainMenu());
        } else if (Input.is('accept')) exit_intro();
    }

    override function on_beat():Void {
        super.on_beat();

        if (title.animation.curAnim == null && gf.animation.curAnim == null) return;

        // funny animations
        title.play_animation('bump', true);
        gf.play_animation(gf.animation.curAnim.name == 'danceLeft' ? 'danceRight' : 'danceLeft', true);
        
        // haha if not in intro don't run intro code :O
        if (!in_intro) return;

        // parse lines
        for (line in lines) {
            // only parse line if it's the current beat (so no stupid duplicates!!!)
            if (Std.parseInt(line.att.beat) != Conductor.beat) continue;

            // giant switch case with all available line types
            switch (line.att.type) {
                case 'line':
                    trace(line.att.value, DEBUG);

                    // add text from all lines in the value property
                    add_text(line.att.value.split(','));
                case 'clear':
                    trace('CLEARING STUFF', DEBUG);
                    clear_intro_sprites();
                case 'sprite':
                    trace('SPAWNING SPRITE ${line.att.value}!', DEBUG);

                    // load sprite
                    var sprite:Sprite = new Sprite(0, 0, line.att.antialiased != 'false').load('menus/title/sprites/${line.att.value}');

                    // set scale
                    sprite.scale.set(Std.parseFloat(line.att.scale), Std.parseFloat(line.att.scale));
                    sprite.updateHitbox();

                    // allow for screen centering on x and y positions
                    if (line.att.x.toLowerCase() != 'center') sprite.x = Std.parseFloat(line.att.x);
                    else sprite.screenCenter(X);
                    
                    if (line.att.y.toLowerCase() != 'center') sprite.y = Std.parseFloat(line.att.y);
                    else sprite.screenCenter(Y);

                    // add to screen lol
                    intro_sprites.add(sprite);
                case 'randomized':
                    trace('DISPLAYING RANDOMIZED ${line.att.value} (${randomized_lines.get(line.att.value)})!', DEBUG);

                    // add randomized text from specified key (line.att.value is da key)
                    add_text([randomized_lines.get(line.att.value)]);
                case 'event':
                    trace('RUNNING EVENT ${line.att.value}!', DEBUG);

                    switch (line.att.value) {
                        case 'exit_intro':
                            trace('EXIT TO MAIN TITLE SCREEN', DEBUG);
                            exit_intro();
                        default:
                            trace('${line.att.value} NOT IMPLEMENTED AS AN EVENT!', WARNING);
                    }
                default:
                    trace('${line.att.type} NOT IMPLEMENTED AS A LINE TYPE!', WARNING);
            }
        }
    }

    /**
     * Plays the title screen music.
     * @param force_file Forcefully use a different file to play if you want.
     * @author Leather128
     */
    public static function play_music(?force_file:String):Void {
        music_title = Date.now().getDay() == 5 ? 'friday' : 'normal';
        if (force_file != null) music_title = force_file;

        // play specified music
        FlxG.sound.playMusic(Assets.audio('music/menus/${music_title}'));
    }

    /**
     * Add Alphabet text to all the lines of text currently on screen.
     * @param line_data Lines of text you want to add.
     * @author Leather128
     */
    public function add_text(line_data:Array<String>):Void {
        // because adding onto lines is important ig
        var has_lines:Bool = intro_lines.length > 0;

        for (i in 0...line_data.length) {
            var text:String = line_data[i].trim();
            
            var alphabet:Alphabet = new Alphabet(0, ((has_lines ? i + intro_lines.length : i) * 60.0) + 200.0, text, true);
            alphabet.screenCenter(X);
            intro_lines.add(alphabet);
        }
    }

    /**
     * Clears all sprites from the intro of the game.
     */
    public function clear_intro_sprites():Void {
        intro_sprites.forEachAlive(function(sprite:flixel.FlxSprite):Void { intro_sprites.remove(sprite, true); sprite.destroy(); });
        intro_sprites.clear();

        intro_lines.forEachAlive(function(sprite:Alphabet):Void { intro_lines.remove(sprite, true); sprite.destroy(); });
        intro_lines.clear();
    }

    /**
     * Exits from the intro of the game.
     */
    public function exit_intro():Void {
        clear_intro_sprites();
        FlxG.camera.flash(flixel.util.FlxColor.WHITE, 4);

        // make stuff visible lol
        gf.visible = title.visible = enter.visible = true;
        in_intro = false;
    }
}
