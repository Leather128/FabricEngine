package funkin.scenes;

class TitleScreen extends FunkinScene {
	var data:haxe.xml.Access = new haxe.xml.Access(Xml.parse(Assets.text('data/intro-text.xml')));

	var title:Sprite = new Sprite(-150, -100).load('title-screen/logo', SPARROW);

	public function new() {
		super();

		title.add_animation('bump', 'logo bumpin');
        title.play_animation('bump');
		add(title);
	}
}
