package funkin.scenes;

import funkin.utils.Song;

/**
 * The actual main gameplay of the game.
 * @author Leather128
 */
class Gameplay extends FunkinScene {
    /**
     * Current song that the game is using.
     */
    public static var song:Song;

    override function create():Void {
        if (song == null) song = SongHelper.load_song('tutorial/normal');
        // if the shit failed to load
        if (song == null) { super.create(); return; }

        

        super.create();
    }
}
