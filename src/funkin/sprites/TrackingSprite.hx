package funkin.sprites;

/**
 * A sprite that tracks another sprite with customizable offsets.
 * @author Leather128
 */
class TrackingSprite extends Sprite {
    /**
     * The offest in X and Y to the tracked object.
     */
    public var tracking_offset:flixel.math.FlxPoint = new flixel.math.FlxPoint(10.0, -30.0);

    /**
     * The object / sprite we are tracking.
     */
    public var tracked:flixel.FlxObject;

    /**
     * Tracking mode (or direction) of this sprite.
     */
    public var tracking_mode:TrackingMode = RIGHT;

    override function update(elapsed:Float):Void {
        // tracking modes
        if (tracked != null) {
            switch (tracking_mode) {
                case RIGHT: setPosition(tracked.x + tracked.width + tracking_offset.x, tracked.y + tracking_offset.y);
                case LEFT: setPosition(tracked.x + tracking_offset.x, tracked.y + tracking_offset.y);
                case UP: setPosition(tracked.x + (tracked.width / 2.0) + tracking_offset.x, tracked.y - height + tracking_offset.y);
                case DOWN: setPosition(tracked.x + (tracked.width / 2.0) + tracking_offset.x, tracked.y + tracked.height + tracking_offset.y);
            }
        }

        super.update(elapsed);
    }
}

/**
 * Enum to store the mode (or direction) that a tracking sprite tracks.
 */
enum TrackingMode {
    RIGHT;
    LEFT;
    UP;
    DOWN;
}