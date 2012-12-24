module main;

import std.stdio;
import dgs.all;
debug import std.stdio;

void main(){
    initDgs(640, 480, true);
    scope(exit) destroyDgs();
    setWindowTitle("dgs test");
    mouseAliases[SDL_BUTTON_LEFT] = SDL_SCANCODE_Z;
    auto sp = (new Sprite).field!("image", "centerX", "centerY").set(new Image("youkei.png"), 128, 128);
    auto sp2 = (new Sprite).field!"image".set(new Image("テキスト描写成功!!", 64));
    openWindow();
    while(true){
        processEvents();
        clearWindow();
        sp.rotate += 2;
        if(isKeyRepeated(SDL_SCANCODE_DOWN)){
            writeln("passed");
        }else if(isKeyTriggered(SDL_SCANCODE_Z)){
            writeln("z");
        }
        sp.draw();
        sp2.draw();
        updateWindow();
    }
}

