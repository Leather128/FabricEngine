package funkin.scenes;

import flixel.util.FlxColor;
import funkin.sprites.ui.FreeplaySong;

/**
 * The freeplay menu.
 * @author Leather128
 */
class Freeplay extends FunkinScene {
    var bg:Sprite = new Sprite().load('menus/background_grayscale');
    var songs:Array<FreeplaySongData> = [];

    var songs_group:flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FreeplaySong> = new flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<FreeplaySong>();

    /**
     * Current background color in freeplay.
     */
    public static var background_color:FreeplayBackgroundColor = new FreeplayBackgroundColor();

    /**
     * Current index of the song selected.
     */
    public static var index:Int = 0;

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

        change_selection();
    }

    override function update(elapsed:Float):Void {
        var vertical_axis:Int = (Input.is('down') ? 1 : 0) - (Input.is('up') ? 1 : 0);
        if (vertical_axis != 0) change_selection(vertical_axis);

        background_color.interpolate(songs[index].color, 0.045);
        bg.color = FlxColor.fromRGBFloat(background_color.r, background_color.g, background_color.b);

        super.update(elapsed);
    }

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
     * @param name 
     * @param icon 
     * @param difficulties 
     * @param color 
     * @param bpm 
     * @param icon_antialiased 
     */
    public function add_song(name:String, icon:String, ?difficulties:Array<String>, ?color:FlxColor, ?bpm:Float, ?icon_antialiased:Bool):Void {
        var song_data:FreeplaySongData = { name: name, icon: icon, difficulties: difficulties, color: color, bpm: bpm, icon_antialiased: icon_antialiased };
        songs.push(song_data);

        songs_group.add(new FreeplaySong(0, 0, song_data, songs.length));
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
     * Red Blue float value.
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