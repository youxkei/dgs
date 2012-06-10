module main;

import std.stdio;
import dgs.all;
debug import std.stdio;

void main(){
    initDgs();
    scope(exit) destroyDgs();
	mouseAliases[BUTTON_LEFT] = KEY_z;
	openWindow(640, 480);
	setWindowTitle("dgs test");
	auto sp = (new Sprite).field!("image", "centerX", "centerY").set(new Image("youkei.png"), 128, 128);
	auto sp2 = (new Sprite).field!"image".set(new Image("テキスト描写成功!!", 64));
	while(true){
		processEvents();
		clearWindow();
		sp.rotate += 2;
		if(isKeyRepeated(KEY_DOWN)){
			writeln("passed");
		}else if(isKeyTriggered(KEY_z)){
			writeln("z");
		}
		sp.draw();
		sp2.draw();
		updateWindow();
	}
}

