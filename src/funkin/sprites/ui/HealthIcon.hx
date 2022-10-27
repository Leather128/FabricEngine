package funkin.sprites.ui;

/**
 * Icon to be used for a character on the health bar.
 * @author Leather128
 */
class HealthIcon extends TrackingSprite {
    public function new(x:Float = 0.0, y:Float = 0.0, character:String = 'face', antialiased:Bool = true) {
        super(x, y, antialiased);
        load_icon(character, antialiased);
    }

    /**
     * Loads specified icon and sets the antialiasing property.
     * @param character Icon to load (starts at 'assets/images/gameplay/icons/icon-')
     * @param antialiased What to set antialiasing to.
     */
    public function load_icon(character:String = 'face', antialiased:Bool = true) {
        antialiasing = antialiased;

        // load icons
        load('gameplay/icons/icon-${character}', IMAGE, [ 'animated' => true, 'width' => 150, 'height' => 150 ]);

        // add aniamtions
        animation.add('alive', [0], 24, true);
        if (frames.frames.length > 1) animation.add('dying', [1], 24, true); else animation.add('dying', [0], 24, true);
        if (frames.frames.length > 2) animation.add('winning', [2], 24, true); else animation.add('winning', [0], 24, true);

        animation.play('alive');
    }
}