package funkin.sprites.ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

/**
 * A line of text using the game's custom alphabet font.
 * @author Leather128
 */
class Alphabet extends FlxTypedSpriteGroup<AlphabetChar> {
    /**
     * List of all characters in the alphabet.
     */
    public static final alphabet:String = 'abcdefghijklmnopqrstuvwxyz';

    /**
     * @param x X
     * @param y Y
     * @param text Line of text to display.
     * @param bold (Optional) Bold alphabet toggle.
     * @author Leather128
     */
    public function new(x:Float = 0.0, y:Float = 0.0, text:String, bold:Bool = true) {
        super(x, y);

        var alphabet_x:Float = 0.0;

        for (i in 0...text.length) {
            var character:String = text.charAt(i);

            if (character == ' ') {
                alphabet_x += 40;
                continue;
            }

            var alphabet_char:AlphabetChar = new AlphabetChar(alphabet_x, 0, character, bold);
            add(alphabet_char);

            alphabet_x += alphabet_char.width;
        }
    }
}

/**
 * A character from the game's custom alphabet font.
 * @author Leather128
 */
class AlphabetChar extends Sprite {
    /**
     * @param x X
     * @param y Y
     * @param character Character to display.
     * @param bold (Optional) Bold alphabet toggle.
     * @author Leather128
     */
    public function new(x:Float = 0.0, y:Float = 0.0, character:String, bold:Bool = true, row:Int = 0) {
        super(x, y);
        // shouldn't happen, but just in case
        if (character == ' ') return;

        character = convert(character);

        load('ui/alphabet', SPARROW);

        if (bold) add_animation('character', '${character.toUpperCase()} bold', 24, true);
        else {
            if (Alphabet.alphabet.contains(character.toLowerCase()))
                add_animation('character', '$character ${character.toUpperCase() == character ? 'capital' : 'lowercase'}', 24, true);
            else
                add_animation('character', character, 24, true);
        }

        play_animation('character', true);
        updateHitbox();

        if (!bold) {
            // TODO: add symbol / special character offsets
            y = (110 - height);
            y += row * 60;
        }
    }

    /**
     * Converts a character to the name in `alphabet.xml`.
     * @param raw_character Original text character to convert.
     * @return String
     * @author Leather128
     */
    public static function convert(raw_character:String):String {
        switch (raw_character) {
            default: return raw_character;
        }
    }
}