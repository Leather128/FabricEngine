package funkin.scenes.subscenes;

/**
 * Subscene to allow you to select a mod from anywhere supported.
 * @author Leather128
 */
class ModSelect extends FunkinSubScene {
    var hud_camera:flixel.FlxCamera = new flixel.FlxCamera();

    /**
     * Icon `Sprite` for the selected mod.
     */
    public var mod_icon:Sprite = new Sprite();

    /**
     * Title text for the name of the mod.
     */
    public var mod_title:flixel.text.FlxText = new flixel.text.FlxText();

    /**
     * Description text for the description of the mod.
     */
    public var mod_desc:flixel.text.FlxText = new flixel.text.FlxText();

    public function new() {
        super();

        hud_camera.bgColor.alpha = 0;
        FlxG.cameras.add(hud_camera, false);

        var bg:Sprite = cast new Sprite().makeGraphic(FlxG.width - 16, FlxG.height - 16, flixel.util.FlxColor.BLACK);
        bg.screenCenter(); bg.alpha = 0.6;
        bg.cameras = [hud_camera];
        add(bg);

        mod_title.setFormat(Assets.font('vcr.ttf'), 32, 0xFFFFFF, LEFT, OUTLINE, 0x000000);
        mod_desc.setFormat(Assets.font('vcr.ttf'), 16, 0xFFFFFF, LEFT, OUTLINE, 0x000000);

        add(mod_icon);
        add(mod_title);
        add(mod_desc);
    }

    override function update(elapsed:Float):Void {
        if (Input.is('exit')) { FlxG.cameras.remove(hud_camera); close(); }
        
        super.update(elapsed);
    }
}