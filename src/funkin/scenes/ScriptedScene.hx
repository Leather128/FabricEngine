package funkin.scenes;

import funkin.scripting.Script;

/**
 * `FunkinScene` that uses a script to run.
 * @author Leather128
 */
class ScriptedScene extends FunkinScene {
    /**
     * Script currently running.
     */
    public var script:Script;

    public function new(scene_path:String) {
        // loads da script
        script = Script.load('scenes/${scene_path}');
        // no nulls
        if (script == null) { trace('script property of ScriptedScene is ${script}! Fallbacking to TitleScreen.hx', ERROR); FlxG.switchState(new TitleScreen()); return; }

        super();

        script.set_script_object(this);
        // manually cuz hscript hates functions
        script.set('add', this.add);
        script.set('insert', this.insert);
        script.set('remove', this.remove);
        script.set('members', this.members);
        script.set('state', this);

        script.call('new');
    }

    // the rest of this shit is literally just bullshit functions lmao (yes i typed this manually :skull:)

    override public function create():Void {
        script.call('create');
        super.create();
        script.call('create_post'); script.call('createPost');
    }

    override function update(elapsed:Float):Void {
        script.call('update', [elapsed]);
        super.update(elapsed);
        script.call('update_post', [elapsed]); script.call('updatePost', [elapsed]);
    }

    override public function on_beat():Void {
        script.call('on_beat');
        super.on_beat();
    }

    override public function on_step():Void {
        script.call('on_step');
        super.on_step();
    }

    override public function onFocus():Void {
        script.call('on_focus'); script.call('onFocus');
        super.onFocus();
    }

    override public function onFocusLost():Void {
        script.call('on_focus_lost'); script.call('onFocusLost');
        super.onFocusLost();
    }

    override public function closeSubState():Void {
        script.call('close_sub_state'); script.call('closeSubState');
        super.closeSubState();
    }

    override public function openSubState(sub_state:flixel.FlxSubState):Void {
        script.call('open_sub_state', [sub_state]); script.call('openSubState', [sub_state]);
        super.openSubState(sub_state);
    }

    override public function resetSubState():Void {
        script.call('reset_sub_state'); script.call('resetSubState');
        super.resetSubState();
    }

    override public function switchTo(next_state:flixel.FlxState):Bool {
        script.call('switch_to', [next_state]); script.call('switchTo', [next_state]);
        return super.switchTo(next_state);
    }

    override public function onResize(width:Int, height:Int):Void {
        script.call('on_resize', [width, height]); script.call('onResize', [width, height]);
        super.onResize(width, height);
    }

    override public function destroy():Void {
        script.call('destroy');
        super.destroy();
    }

    override public function draw():Void {
        script.call('draw');
        super.draw();
        script.call('draw_post'); script.call('drawPost');
    }
}