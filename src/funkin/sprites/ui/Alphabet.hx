package funkin.sprites.ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

/**
 * A line of text using the game's custom alphabet font.
 * @author Leather128
 */
class Alphabet extends FlxTypedSpriteGroup<AlphabetChar> {
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
	 * List of all characters in the alphabet.
	 */
	public static final alphabet:String = 'abcdefghijklmnopqrstuvwxyz';

	/**
	 * List of all numbers in the decimal system.
	 */
	public static final numbers:String = '0123456789';

	/**
	 * Whether this character uses the bold outline shader.
	 */
	public var uses_outline:Bool = false;

	/**
	 * Current character string used for this alphabet character.
	 */
	public var character:String;

	/**
	 * Raw character input string used for this alphabet character.
	 */
	public var raw_character:String;

	/**
	 * @param x X
	 * @param y Y
	 * @param character Character to display.
	 * @param bold (Optional) Bold alphabet toggle.
	 * @param row (Optional) Row of the character (NON BOLD ONLY).
	 */
	public function new(x:Float = 0.0, y:Float = 0.0, raw_character:String, bold:Bool = true, row:Int = 0) {
		super(x, y);
		// shouldn't happen, but just in case
		if (character == ' ')
			return;

		character = convert(raw_character);

		uses_outline = bold && !alphabet.contains(character.toLowerCase());
		load('ui/alphabet/${bold && !uses_outline ? 'bold' : 'default'}', SPARROW);

		if (bold) {
			add_animation('character', '${character.toUpperCase()}0', 24, true);
		} else {
			if (alphabet.contains(character.toLowerCase()))
				add_animation('character', '${character} ${character.toUpperCase() == character ? 'capital' : 'lowercase'}0', 24, true);
			else
				add_animation('character', '${character}0', 24, true);
		}

		// not copied from plasma engine which didn't copy from yoshicrafter engine
		if (uses_outline) {
			add_animation('character', '${character}0', 24, true);
			play_animation('character', true);

			// i love scaling and offsets
			scale.set(1.5, 1.5);
			updateHitbox();

			set_offsets(raw_character, bold, row);
		} else {
			play_animation('character', true);
			updateHitbox();
			set_offsets(raw_character, bold, row);
		}
	}

	/**
	 * Overriden draw function to make the outline shader work correctly.
	 */
	override function draw():Void {
        if (!uses_outline) {
            colorTransform.redMultiplier = color.redFloat;
            colorTransform.greenMultiplier = color.greenFloat;
            colorTransform.blueMultiplier = color.blueFloat;
            colorTransform.redOffset = 0;
            colorTransform.greenOffset = 0;
            colorTransform.blueOffset = 0;
			
			shader = null;
        } else {
            colorTransform.redMultiplier = 0;
            colorTransform.greenMultiplier = 0;
            colorTransform.blueMultiplier = 0;
            colorTransform.redOffset = color.red;
            colorTransform.greenOffset = color.green;
            colorTransform.blueOffset = color.blue;

			shader = new funkin.shaders.OutlineShader();

			var frame_rect:flixel.math.FlxRect = frame.frame;
			cast(shader, funkin.shaders.OutlineShader).setClip(frame_rect.x / pixels.width, frame_rect.y / pixels.height, frame_rect.width / pixels.width,
				frame_rect.height / pixels.height);
			
			if (numbers.contains(character)) offset.add(0.0, 10.0);
        }
		
		super.draw();

		if (uses_outline && numbers.contains(character)) offset.subtract(0.0, 10.0);
	}

	/**
	 * Converts a character to the name in `alphabet.xml`.
	 * @param raw_character Original text character to convert.
	 * @return Converted String.
	 */
	public static function convert(raw_character:String):String {
		switch (raw_character) {
			case '&': return 'and';
			case '<': return 'less than';
			case "'": return "-apostraphie-";
			case "\\": return "-back slash-";
			case "/": return "-forward slash-";
			case "“": return "-start quote-";
			case "”": return "-end quote-";
			case "?": return "-question mark-";
			case "!": return "-exclamation point-";
			case ".": return "-period-";
			case ",": return "-comma-";
			case "-": return "-dash-";
			case "←": return "-left arrow-";
			case "↓": return "-down arrow-";
			case "↑": return "-up arrow-";
			case "→": return "-right arrow-";
			default: return raw_character;
		}
	}

	/**
	 * Sets the offset of this character.
	 * @param raw_character Raw character string to use.
	 * @param bold (Optional) Bold alphabet toggle.
	 * @param row (Optional) Row of the character (NON BOLD ONLY).
	 */
	public function set_offsets(raw_character:String, bold:Bool = true, row:Int = 0):Void {
		if (!bold) {
			// TODO: add symbol / special character offsets
			y = (110.0 - height) + (row * 60.0);
			return;
		}

		switch (raw_character) {
			case '.' | ',' | '_': y += height * 2.0;
			case '-': y += height;
			default: return;
		}
	}
}
