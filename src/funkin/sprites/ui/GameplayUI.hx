package funkin.sprites.ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import funkin.scenes.Gameplay;

/**
 * Class to hold all UI elements related to the actual game.
 * @author Leather128
 */
class GameplayUI extends flixel.group.FlxSpriteGroup {
	/**
	 * Current health bar instance.
	 */
	public var health_bar:HealthBar;

	/**
	 * Group of all current strums (opponent, THEN player).
	 */
	public var strums:FlxTypedSpriteGroup<Strum> = new FlxTypedSpriteGroup<Strum>();
	
	/**
	 * Group of all current player strums.
	 */
	public var player_strums:FlxTypedSpriteGroup<Strum> = new FlxTypedSpriteGroup<Strum>();

	/**
	 * Group of all current opponent strums.
	 */
	public var opponent_strums:FlxTypedSpriteGroup<Strum> = new FlxTypedSpriteGroup<Strum>();

	/**
	 * Group of all current notes.
	 */
	public var notes:FlxTypedSpriteGroup<Note> = new FlxTypedSpriteGroup<Note>();

	/**
	 * Group of all current player notes.
	 */
	 public var player_notes:FlxTypedSpriteGroup<Note> = new FlxTypedSpriteGroup<Note>();

	/**
	 * Group of all current opponent notes.
	 */
	public var opponent_notes:FlxTypedSpriteGroup<Note> = new FlxTypedSpriteGroup<Note>();

	/**
	 * Array of notes that were preloaded that will be spawned into the song as they come in.
	 */
	public var preloaded_notes:Array<Note> = [];

	/**
	 * Timer used for the countdown on songs.
	 */
	public var countdown_timer:flixel.util.FlxTimer = new flixel.util.FlxTimer();

	public function new() {
		super();

		if (Gameplay.instance != null)
			health_bar = new HealthBar(FlxG.height * 0.9, Gameplay.instance.bf.icon, Gameplay.instance.dad.icon, Gameplay.instance.bf.health_color,
				Gameplay.instance.dad.health_color);
		else health_bar = new HealthBar(FlxG.height * 0.9);
		add(health_bar);

		add(strums);
		add(notes);

		strums.y = 50;
		// when adding downscroll vvvvv
		// strums.y = FlxG.height - 150.0;

		generate_strums(0);
		generate_strums(1);

		if (Gameplay.instance == null) return;

		for (section in Gameplay.song.notes) {
			for (note in section.sectionNotes) {
				var note_spr:Note = spawn_note(section.mustHitSection ? note[1] < 4 : note[1] > 3, note[0], Std.int(note[1] % 4), note[2], false);
				note_spr.raw_data = note;

				// funny preloading go brrrr
				preloaded_notes.push(note_spr);

				if (Gameplay.instance != null) {
					Gameplay.instance.call_scripts('on_note', [note_spr]);
					Gameplay.instance.call_scripts('note_spawn', [note_spr]); Gameplay.instance.call_scripts('noteSpawn', [note_spr]);
				}
			}
		}

		preloaded_notes.sort(function(a:Note, b:Note) return flixel.util.FlxSort.byValues(flixel.util.FlxSort.ASCENDING, a.strum_time, b.strum_time));
	}

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		for (note in notes.members) {
			var strum_group:FlxTypedSpriteGroup<Strum> = note.is_player ? player_strums : opponent_strums;
			var note_group:FlxTypedSpriteGroup<Note> = note.is_player ? player_notes : opponent_notes;
			var strum:Strum = strum_group.members[note.id];

			// note movement
			note.x = strum.x;
			note.y = strum.y - (0.45 * ((Conductor.song_position - note.strum_time) * Gameplay.song.speed));

			// opponent note hitting
			if (!note.is_player && note.strum_time <= Conductor.song_position) {
				notes.remove(note, true);
				note_group.remove(note, true);
				note.destroy();

				if (Gameplay.instance != null) {
					// funny script calls
					Gameplay.instance.call_scripts('on_sing', [note, Gameplay.instance.dad]);
					Gameplay.instance.call_scripts('note_hit', [note, Gameplay.instance.dad]);
					Gameplay.instance.call_scripts('noteHit', [note, Gameplay.instance.dad]);

					Gameplay.instance.dad.sing_timer = 0.0;
					Gameplay.instance.dad.play_animation('sing${Note.NOTE_DIRECTIONS[4][note.id].toUpperCase()}', true);
					opponent_strums.members[note.id].play_animation('confirm');

					Gameplay.instance.camera_bouncing = true;

					Gameplay.instance.call_scripts('on_sing_post', [note, Gameplay.instance.dad]);
					Gameplay.instance.call_scripts('note_hit_post', [note, Gameplay.instance.dad]);
					Gameplay.instance.call_scripts('noteHitPost', [note, Gameplay.instance.dad]);
				}
			}

			// note missing
			if (note.is_player && note.strum_time < Conductor.song_position - Conductor.safe_zone_offset) note_miss(note);
		}

		// gameplay specific stuff
		if (Gameplay.instance == null) return;

		while (preloaded_notes.length > 0 && preloaded_notes[0].strum_time - Conductor.song_position < 1500.0) {
			var note:Note = preloaded_notes[0];

			if (note.is_player) player_notes.add(note); else opponent_notes.add(note);
			notes.add(note);

			preloaded_notes.shift();
		}

		notes.members.sort(function(a:Note, b:Note) return sort_notes(flixel.util.FlxSort.DESCENDING, a, b) );

		note_input();
	}

	public function on_beat():Void {
		health_bar.on_beat();
	}

	/**
	 * Generates strums for the specified `player`.
	 * @param player Player to generate for (should be 0 for opponent or 1 for the player).
	 * @param x_multi (Optional) X position multiplier to use for position.
	 */
	public function generate_strums(player:Int, ?x_multi:Float):Void {
		var x_pos:Float = 95.0;

		for (i in 0...4) {
			var strum:Strum = new Strum(x_pos, 0.0, i);
			// funky maths
			strum.x += (FlxG.width / 2.0) * (x_multi != null ? x_multi : player);

			strums.add(strum);

			if (player == 0) {
				opponent_strums.add(strum);

				// funny confirm anim stuff
				strum.animation.finishCallback = function(name:String):Void 
					if (name == 'confirm') strum.play_animation('default');
			}
			else player_strums.add(strum);

			x_pos += Note.DEFAULT_WIDTH;

			strum.default_position.set(strum.x, strum.y);
		}
	}

	/**
	 * Spawns a `Note` using specified parameters.
	 * @param is_player Whether or not the note is hit by the player.
	 * @param strum_time Time of the note in the song in milliseconds.
	 * @param id ID of the note (usually from 0 to 3).
	 * @param sustain_length Time of the sustain for this note (0 for non-sustain notes).
	 * @return The note that was spawned.
	 */
	public function spawn_note(is_player:Bool, strum_time:Float, id:Int, ?sustain_length:Float = 0.0, ?add_to_notes:Bool = true):Note {
		var note:Note = new Note(is_player, strum_time, id, sustain_length);
		note.x = -10000; note.y = -10000;

		if (add_to_notes && is_player) player_notes.add(note); else opponent_notes.add(note);
		if (add_to_notes) notes.add(note);

		return note;
	}

	/**
	 * Checks your inputs and reacts appropriately.
	 */
	public function note_input():Void {
		var note_states:Array<flixel.input.FlxInput.FlxInputState> = [Input.get('keys-4-0'), Input.get('keys-4-1'), Input.get('keys-4-2'), Input.get('keys-4-3')];

		// TODO: add sustain note hitting

		if (note_states.contains(JUST_PRESSED)) {
			if (Gameplay.instance != null) Gameplay.instance.bf.sing_timer = 0.0;

			// possible notes we can hit lol
			var possible_notes:Array<Note> = [];
			var pressed_ids:Array<Bool> = [false, false, false, false];

			// get possible notes we can hit
			player_notes.forEachAlive(function(note:Note):Void {
				for (possible_note in possible_notes) {
					// get rid of any possible duplicate notes
					if (possible_note.id == note.id && Math.abs(possible_note.strum_time - note.strum_time) < 5) {
						notes.remove(note, true);
						player_notes.remove(note, true);
						note.destroy();
					}
				}

				if (note.exists && note.strum_time < Conductor.song_position + Conductor.safe_zone_offset) possible_notes.push(note);
			});

			possible_notes.sort(function(a:Note, b:Note):Int return Std.int(a.strum_time - b.strum_time) );

			if (possible_notes.length != 0) {
				for (note in possible_notes) {
					if (!pressed_ids[note.id] && note_states[note.id] == JUST_PRESSED) {
						pressed_ids[note.id] = true;
						hit_note(note);
					}
				}
			}

			return;
		}

		// animation shit
		player_strums.forEachAlive(function(strum:Strum):Void {
			if (note_states[strum.id] == PRESSED && strum.animation.curAnim.name != 'confirm' && strum.animation.curAnim.name != 'press') strum.play_animation('press');
			else if (note_states[strum.id] == RELEASED) strum.play_animation('default');
		});
		
		// if not null, do this shit
		if (Gameplay.instance == null) return;

		// code become less long.exe
		var bf:funkin.sprites.gameplay.Character = Gameplay.instance.bf;

		// basically do same shit that would normally happen in Character.hx anyways
		if (!note_states.contains(PRESSED) && bf.sing_timer >= Conductor.time_between_steps * bf.sing_duration * 0.001) bf.dance();
	}

	/**
	 * Hits specified `note`.
	 * @param note Note to hit.
	 */
	public function hit_note(note:Note):Void {
		player_strums.members[note.id].play_animation('confirm', true);

		notes.remove(note, true);
		player_notes.remove(note, true);
		note.destroy();

		if (Gameplay.instance == null) return;

		Gameplay.instance.call_scripts('on_sing', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('note_hit', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('noteHit', [note, Gameplay.instance.bf]);

		Gameplay.instance.combo++;

		// ms diff
		var difference:Float = Math.abs(Conductor.song_position - note.strum_time);
		var rating:String = 'sick';
		var score:Int = 350;

		// funny ratings
		if (difference > Conductor.safe_zone_offset * 0.9) rating = 'shit';
		else if (difference > Conductor.safe_zone_offset * 0.75) rating = 'bad';
		else if (difference > Conductor.safe_zone_offset * 0.2) rating = 'good';

		// rating info
		switch (rating) {
			case 'good': score = 200;
			case 'bad': score = 100;
			case 'shit': score = 50;
		}
		
		var rating_info:RatingInfo = new RatingInfo(0.0, 0.0, { rating: rating, combo: Gameplay.instance.combo });
		rating_info.screenCenter(); rating_info.x = FlxG.width * 0.55; rating_info.y -= 60;

		Gameplay.instance.add(rating_info);
		Gameplay.instance.score += score;

		Gameplay.instance.bf.play_animation('sing${Note.NOTE_DIRECTIONS[4][note.id].toUpperCase()}', true);
		// why are the fnf devs so damn specific
		health_bar.health_value += 0.023;

		Gameplay.instance.call_scripts('on_sing_post', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('note_hit_post', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('noteHitPost', [note, Gameplay.instance.bf]);
	}

	/**
	 * Misses specified `note`.
	 * @param note Note to miss.
	 */
	public function note_miss(note:Note):Void {
		var note_group:FlxTypedSpriteGroup<Note> = note.is_player ? player_notes : opponent_notes;

		if (note.exists) {
			notes.remove(note, true);
			note_group.remove(note, true);
			note.destroy();
		}

		if (Gameplay.instance == null) return;

		Gameplay.instance.call_scripts('on_miss', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('note_miss', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('noteMiss', [note, Gameplay.instance.bf]);

		Gameplay.instance.bf.sing_timer = 0.0;
		Gameplay.instance.bf.play_animation('sing${Note.NOTE_DIRECTIONS[4][note.id].toUpperCase()}miss', true);

		Gameplay.instance.score -= 10;

		Gameplay.instance.combo = 0;

		// bro why so specific lmao
		health_bar.health_value -= 0.0475;

		Gameplay.instance.call_scripts('on_miss_post', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('note_miss_post', [note, Gameplay.instance.bf]);
		Gameplay.instance.call_scripts('noteMissPost', [note, Gameplay.instance.bf]);
	}

	/**
	 * Starts the countdown.
	 */
	public function start_countdown():Void {
		var countdown_info:Array<CountdownInfo> = [
			{graphic: '', sound: '3'},
			{graphic: 'ready', sound: '2'},
			{graphic: 'set', sound: '1'},
			{graphic: 'go', sound: 'go'}
		];

		// precache images
		for (countdown in countdown_info) {
			if (countdown.graphic.trim() != '') Assets.image('images/gameplay/ui/countdown/${countdown.graphic}-default');
			if (countdown.sound.trim() != '') Assets.audio('sfx/gameplay/countdown/${countdown.sound}-default');
		}

		countdown_timer.start(Conductor.time_between_beats / 1000.0, function(timer:flixel.util.FlxTimer):Void {
			// basically makes accessing this stuff easier
			var countdown:CountdownInfo = countdown_info[timer.elapsedLoops - 1];
			if (countdown == null) return;

			if (countdown.graphic != '') {
				// spawns countdown sprite and tweens it
				var sprite:Sprite = cast(new Sprite().load('gameplay/ui/countdown/${countdown.graphic}-default').screenCenter(), Sprite);
				FlxTween.tween(sprite, {y: sprite.y + 100, alpha: 0}, Conductor.time_between_beats / 1000.0, {
					ease: FlxEase.cubeInOut,
					onComplete: function(_):Void { sprite.destroy(); }
				});
				add(sprite);
			}

			// plays countdown sound
			if (countdown.sound != '') FlxG.sound.play(Assets.audio('sfx/gameplay/countdown/${countdown.sound}-default'), 0.6);
		}, 4);
	}

	/**
	 * Sorts `note_a` by `note_b` using the `sort` sorting method.
	 * @param sort Method of sorting to use.
	 * @param note_a 1st Note.
	 * @param note_b 2nd Note.
	 * @return Int
	 */
	public static function sort_notes(sort:Int = flixel.util.FlxSort.ASCENDING, note_a:Note, note_b:Note):Int
		return note_a.strum_time < note_b.strum_time ? sort : note_a.strum_time > note_b.strum_time ? -sort : 0;
}

/**
 * Simple `typedef` for storing information about any given part of the countdown.
 * @author Leather128
 */
typedef CountdownInfo = {
	/**
	 * Base name of graphic.
	 * 
	 * (Actual file is appended with `-{ui skin}`)
	 */
	var graphic:String;

	/**
	 * Base name of sound.
	 * 
	 * (Actual file is appended with `-{ui skin}`)
	 */
	var sound:String;
}