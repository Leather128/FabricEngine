package funkin.scenes;

// hallo i like potatoes

class Test extends FunkinScene {
    var freddy_bear_faz:Sprite = new Sprite().load("freddy");

    public function new() {
        super();
        add(freddy_bear_faz);
    }

    override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (Input.is("left", PRESSED)) freddy_bear_faz.x -= elapsed * 50.0;
        if (Input.is("right", PRESSED)) freddy_bear_faz.x += elapsed * 50.0;

        if (Input.is("up", PRESSED)) freddy_bear_faz.y -= elapsed * 50.0;
        if (Input.is("down", PRESSED)) freddy_bear_faz.y += elapsed * 50.0;
    }
}