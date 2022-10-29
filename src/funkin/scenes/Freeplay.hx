package funkin.scenes;

import flixel.math.FlxMath;
import flixel.util.FlxColor;
import funkin.sprites.ui.FreeplaySong;

/**
 * The freeplay menu.
 * @author Leather128
 */
class Freeplay extends FunkinScene {
    // private variables
    var bg:Sprite = new Sprite().load('menus/background_grayscale');
    var songs:Array<FreeplaySongData> = [];

    var songs_group:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FreeplaySong> = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FreeplaySong>();

    var current_icon:funkin.sprites.ui.HealthIcon;

    var song_thread:sys.thread.Thread;
    var song_thread_active:Bool = true;

    /**
     * Current background color in freeplay.
     */
    public static var background_color:FreeplayBackgroundColor = new FreeplayBackgroundColor();

    /**
     * Current index of the song selected.
     */
    public static var index:Null<Int> = 0;

    public function new() {
        super();

        add(bg);
        add(songs_group);

        // Week 0
        add_song('Tutorial', 'gf', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF9271FD'), 100.0, true);
        // Week 1
        add_song('Bopeebo', 'dad', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF9271FD'), 100.0, true);
        add_song('Fresh', 'dad', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF9271FD'), 120.0, true);
        add_song('Dad Battle', 'dad', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF9271FD'), 180.0, true);
        // Week 2
        add_song('Spookeez', 'spooky', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF223344'), 150.0, true);
        add_song('South', 'spooky', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF223344'), 165.0, true);
        add_song('Monster', 'monster', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF223344'), 95.0, true);
        // Week 3
        add_song('Pico', 'pico', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF941653'), 150.0, true);
        add_song('Philly Nice', 'pico', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF941653'), 175.0, true);
        add_song('Blammed', 'pico', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFF941653'), 165.0, true);
        // Week 4
        add_song('Satin Panties', 'mom', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFC96D7'), 110.0, true);
        add_song('High', 'mom', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFC96D7'), 125.0, true);
        add_song('M.I.L.F', 'mom', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFC96D7'), 180.0, true);
        // Week 5
        add_song('Cocoa', 'parents', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFA0D1FF'), 100.0, true);
        add_song('Eggnog', 'parents', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFA0D1FF'), 150.0, true);
        add_song('Winter Horrorland', 'monster', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFA0D1FF'), 159.0, true);
        // Week 6
        add_song('Senpai', 'senpai', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFF78BF'), 144.0, false);
        add_song('Roses', 'senpai', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFF78BF'), 120.0, false);
        add_song('Thorns', 'spirit', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFFF78BF'), 190.0, false);
        // Week 7
        add_song('Ugh', 'tankman', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFF6B604'), 160.0, true);
        add_song('Guns', 'tankman', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFF6B604'), 185.0, true);
        add_song('Stress', 'tankman', [ 'EASY', 'NORMAL', 'HARD' ], FlxColor.fromString('0xFFF6B604'), 178.0, true);
    }

    override function create():Void {
        super.create();
        change_selection();
    }

    override function update(elapsed:Float):Void {
        var vertical_axis:Int = (Input.is('down') ? 1 : 0) - (Input.is('up') ? 1 : 0);
        if (vertical_axis != 0) change_selection(vertical_axis);

        background_color.interpolate(songs[index].color, 0.045);
        bg.color = FlxColor.fromRGBFloat(background_color.r, background_color.g, background_color.b);

        if (FlxG.sound.music.playing) {
            Conductor.song_position_raw = FlxG.sound.music.time;
            Conductor.song_position = Conductor.song_position_raw + Conductor.offset;
        }

        if (current_icon != null) current_icon.scale.set(FlxMath.lerp(current_icon.scale.x, 1, elapsed * 9.0), FlxMath.lerp(current_icon.scale.y, 1, elapsed * 9.0));

        if (Input.is('exit')) FlxG.switchState(new MainMenu());
        if (Input.is('space')) play_song();

        super.update(elapsed);
    }

    override function on_beat():Void {
        super.on_beat();

        if (current_icon != null) current_icon.scale.set(current_icon.scale.x + 0.2, current_icon.scale.y + 0.2);
    }

    /**
     * Changes selection by `amount`.
     * @param amount 
     */
    public function change_selection(amount:Int = 0):Void {
        index += amount;

        if (index < 0) index = songs.length - 1;
        else if (index > songs.length - 1) index = 0;

        FlxG.sound.play(Assets.audio('sfx/menus/scroll'));

        songs_group.forEach(function(item:FreeplaySong):Void {
            item.alpha = songs_group.members.indexOf(item) == index ? 1 : 0.6;
            item.index = songs_group.members.indexOf(item) - index;
        });
    }

    /**
     * Adds song with specified parameters to the menu.
     * @param name Song name.
     * @param icon Song icon name.
     * @param difficulties Song difficulties.
     * @param color Song color.
     * @param bpm Song BPM (Beats Per Minute).
     * @param icon_antialiased Icon's antialiased setting.
     */
    public function add_song(name:String, icon:String, ?difficulties:Array<String>, ?color:FlxColor, ?bpm:Float, ?icon_antialiased:Bool):Void {
        var song_data:FreeplaySongData = { name: name, icon: icon, difficulties: difficulties, color: color, bpm: bpm, icon_antialiased: icon_antialiased };
        songs.push(song_data);

        songs_group.add(new FreeplaySong(0, 0, song_data, songs.length));
    }

    /**
     * Plays the current song selected.
     */
    public function play_song():Void {
        if (song_thread == null) {
            song_thread = sys.thread.Thread.create(function():Void {
                while (true) {
                    // no more memory leaks
                    if ((!song_thread_active)) return;
                    // dont run the rest of the shit but also dont close this loop :D
                    if (sys.thread.Thread.readMessage(false) == null) continue;

                    // smoothly load audio
                    // fade out old music
                    if (FlxG.sound.music != null) FlxG.sound.music.fadeOut(0.2);

                    if (current_icon != null) current_icon.scale.set(1, 1);

                    current_icon = songs_group.members[index].icon;

                    // load new music
                    var audio_data:flixel.system.FlxAssets.FlxSoundAsset = Assets.audio('songs/${songs[index].name.toLowerCase()}/Inst');

                    // stop grrr memory leaks >:(
                    FlxG.sound.music.stop();
                    FlxG.sound.music.destroy();
                    
                    // play music when selected
                    FlxG.sound.playMusic(audio_data);
                    FlxG.sound.music.fadeIn();

                    Conductor.bpm = songs[index].bpm;
                }
            });
        }

        song_thread.sendMessage(index);
    }
}

/**
 * Class to hold freeplay background color information.
 */
class FreeplayBackgroundColor {
    /**
     * Red Color float value.
     */
    public var r:Float = 1.0;

    /**
     * Green Color float value.
     */
    public var g:Float = 1.0;

    /**
     * Blue Color float value.
     */
    public var b:Float = 1.0;

    /**
     * Interpolates the color.
     * @param color Color to interpolate to.
     * @param ratio Ratio to interpolate by.
     */
    public function interpolate(color:FlxColor, ratio:Float):Void {
        r = flixel.math.FlxMath.lerp(r, color.red / 255.0, ratio * (FlxG.elapsed / (1.0 / 60.0)));
        g = flixel.math.FlxMath.lerp(g, color.green / 255.0, ratio * (FlxG.elapsed / (1.0 / 60.0)));
        b = flixel.math.FlxMath.lerp(b, color.blue / 255.0, ratio * (FlxG.elapsed / (1.0 / 60.0)));
    }

    public function new() { }
}