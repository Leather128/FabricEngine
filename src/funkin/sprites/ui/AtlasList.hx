package funkin.sprites.ui;

/**
 * A list of `Sprite`s you can scroll through that use atlases.
 * @author Leather128
 */
class AtlasList extends flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup<AtlasItem> {
    /**
     * Current index of the selected item.
     */
    public var selected_index:Int = 0;

    /**
     * Has the user selected an item yet?
     */
    public var has_selected:Bool = false;

    /**
     * Whether this `AtlasList` is currently active and able to be used.
     */
    public var enabled:Bool = true;

    /**
     * Signal that gets called when any item is selected.
     */
    public var on_accept:flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void> = new flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void>();

    /**
     * Signal that gets called when an item is selected.
     */
    public var on_select:flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void> = new flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void>();
    
    public function new() { super(); }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (has_selected || !enabled) return;

        var vertical_axis:Int = (Input.is('down') ? 1 : 0) - (Input.is('up') ? 1 : 0);
        if (vertical_axis != 0) change_selection(vertical_axis);

        // When you press enter on an item
        if (Input.is('accept')) {
            var selected_item:AtlasItem = members[selected_index];
            // Call the accept function for this list in general
            on_accept.dispatch(selected_item);

            // Call the function for the item instantly if specified
            if (selected_item.call_instantly) selected_item.on_selected.dispatch(selected_item);
            else {
                // Play a sound and flicker the item if not instantly
                has_selected = true;

                FlxG.sound.play(Assets.audio('sfx/menus/confirm'));

                flixel.effects.FlxFlicker.flicker(selected_item, 1, 0.06, true, false, function(flicker):Void
                {
                    // And THEN call the function
                    has_selected = false;
                    selected_item.on_selected.dispatch(selected_item);
                });
            }
        }
    }
    
    /**
     * Adds an item to this list and returns it for chaining purposes.
     * 
     * @param x X position of the item.
     * @param y Y position of the item.
     * @param path Path to the item's atlas spritesheet.
     * @param animations Animation data for the item.
     * @return AtlasItem
     * @author Leather128
     */
    public function add_item(x:Float = 0.0, y:Float = 0.0, path:String, animations:AtlasAnimations, call_instantly:Bool = false):AtlasItem {
        var item:AtlasItem = cast new AtlasItem(x, y, call_instantly).load(path, SPARROW);
        item.add_animation('unselected', animations.unselected.name, animations.unselected.framerate, animations.unselected.looped);
        item.add_animation('selected', animations.selected.name, animations.selected.framerate, animations.selected.looped);

        item.play_animation('unselected', true);
        item.updateHitbox();

        item.ID = length;
        add(item);
        
        return item;
    }

    /**
     * Changes the currently selected item index.
     * 
     * @param amount Amount to change by (positive is down, negative is up).
     * @author Leather128
     */
    public function change_selection(amount:Int = 0):Void {
        selected_index += amount;

        if (selected_index < 0) selected_index = length - 1;
        else if (selected_index > length - 1) selected_index = 0;

        FlxG.sound.play(Assets.audio('sfx/menus/scroll'));

        forEach(function(item:AtlasItem):Void {
            item.play_animation(item.ID == selected_index ? 'selected' : 'unselected', true);
            item.updateHitbox();
            // offset stuff from week 7
            item.origin.set(item.frameWidth * 0.5, item.frameHeight * 0.5);
            item.offset.copyFrom(item.origin);
        });

        on_select.dispatch(members[selected_index]);
    }
}

/**
 * `Sprite` that is used for all items in a `AtlasList`
 * which has some extra variables to make it easier to use.
 * @author Leather128
 */
class AtlasItem extends Sprite {
    /**
     * Signal that gets called when this sprite is selected.
     */
    public var on_selected:flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void> = new flixel.util.FlxSignal.FlxTypedSignal<AtlasItem->Void>();

    public var call_instantly:Bool = false;

    public function new(x:Float = 0.0, y:Float = 0.0, call_instantly:Bool = false) {
        super(x, y);
        this.call_instantly = call_instantly;
    }
}

/**
 * Typedef to store animation data for `AtlasItem`s.
 * @author Leather128
 */
typedef AtlasAnimations = {
    /**
     * `AtlasAnimation` to play when you select a different item.
     */
    public var unselected:AtlasAnimation;

    /**
     * `AtlasAnimation` to play when you select this item.
     */
    public var selected:AtlasAnimation;
}

/**
 * Typedef that stores data about an animation for an `AtlasItem`.
 * @author Leather128
 */
typedef AtlasAnimation = {
    /**
     * The animation's name.
     */
    public var name:String;

    /**
     * The frames per second the animation runs at.
     */
    public var framerate:Int;

    /**
     * Whether the animation loops forever or not.
     */
    public var looped:Bool;
}