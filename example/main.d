module main;

import std.stdio;
import dgs.all;
debug import std.stdio;

void main(){
    initDgs("../lib", 640, 480, true);
    scope(exit) destroyDgs();
    setWindowTitle("dgs test");
    mouseAliases[SDL_BUTTON_LEFT] = SDL_SCANCODE_Z;
    auto sp = new Sprite((new Image("youkei.png")).n!"image", 64.n!"center.x", 64.n!"center.y");
    auto sp2 = new Sprite((new Image("テキスト描写成功!!", 64)).n!"image");
    openWindow();
    while(true){
        processEvents();
        clearWindow();
        sp.rotate += 2;
        if(isKeyPressed(SDL_SCANCODE_DOWN)){
            sp.center.x += 0.1;
        }else if(isKeyTriggered(SDL_SCANCODE_Z)){
            writeln("z");
        }
        sp.draw();
        sp2.draw();
        updateWindow();
    }
}

