package base;

/**
 * Simple extension to `flixel.FlxSprite` that is used for easier handling of
 * basic things that should be defaults.
 * @author Leather128
 */
class Sprite extends flixel.FlxSprite
{
    // Literally the same as the normal new function but automatically sets antialiasing to true.
    public function new(?x:Float = 0.0, ?y:Float = 0.0, ?antialiased:Bool = true)
    {
        super(x, y);
        antialiasing = antialiased;
    }

    /**
     * Loads the specified asset `type` from `path` into this Sprite and returns the `Sprite`.
     * 
     * @param path Path to asset (starts in folder already, ex: assets/images/ not needed).
     * @param type `base.assets.AssetType` to represent the type of asset to load.
     * @param options Map of options to use when loading the asset.
     * @return Sprite
     * @author Leather128
     */
    public function load(path:String, ?type:base.assets.AssetType = IMAGE, ?options:Map<Dynamic, Dynamic> = null):Sprite
    {
        // Most of the time this is true, but adding extra checks would probably make the code worse anyways
        if (options == null) options = new Map<Dynamic, Dynamic>();
        // Account for if someone used the image extension at the end of a path (not wanted in some cases, ex: would break SPARROW).
        if (path.endsWith(Assets.IMAGE_EXT)) path.substring(0, path.length - Assets.IMAGE_EXT.length);

        // Load different types of assets.
        switch (type)
        {
            case IMAGE:
                loadGraphic(Assets.image('images/${path}'), options.get('animated'), options.get('width'), options.get('height'));
            case SPARROW:
                frames = flixel.graphics.frames.FlxAtlasFrames.fromSparrow(Assets.image('images/${path}'), Assets.text('images/${path}.xml'));
            default:
                trace('${type} is unsupported to be loaded in a Sprite!');
        }

        // Update hitbox because yeah sometimes we need to ok?
        updateHitbox();

        return this;
    }
}