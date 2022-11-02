function create() {
    character.load('characters/' + character.character + '/sprites', AssetType.SPARROW, [ 'images_folder' => false ]);

    character.add_animation('idle', 'BF idle dance');

    character.add_animation('singLEFT', 'BF NOTE LEFT0');
    character.add_animation('singDOWN', 'BF NOTE DOWN0');
    character.add_animation('singUP', 'BF NOTE UP0');
    character.add_animation('singRIGHT', 'BF NOTE RIGHT0');

    character.flipX = !character.flipX;

    character.dance();
}