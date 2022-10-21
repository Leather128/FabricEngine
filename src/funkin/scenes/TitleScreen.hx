package funkin.scenes;

class TitleScreen extends FunkinScene {
	var data:haxe.xml.Access = new haxe.xml.Access(Xml.parse(Assets.text('data/intro-text.xml')).firstElement());

	var title:Sprite = new Sprite(-150, -100).load('title-screen/logo', SPARROW);
    var gf:Sprite = new Sprite(FlxG.width * 0.4, FlxG.height * 0.07).load('title-screen/gf', SPARROW);
    var enter:Sprite = new Sprite(100, FlxG.height * 0.8).load('title-screen/enter', SPARROW);

    public static var music_title:String = 'normal';

	override function create():Void {
		super.create();

        Conductor.bpm = Std.parseFloat(data.att.bpm);
        play_music('normal');

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
	}

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        Conductor.song_position_raw = FlxG.sound.music.time;
        Conductor.song_position = Conductor.song_position_raw + Conductor.offset;

        if (Input.is('accept'))
            FlxG.switchState(new Test());
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

        FlxG.sound.playMusic(Assets.audio('music/title-screen/${music_title}'));
    }
}
