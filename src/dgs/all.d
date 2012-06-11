module dgs.all;

import derelict.devil.il;
import derelict.sdl2.sdl;
//import derelict.sdl.mixer;
import derelict.sdl2.ttf;
import org.opengl.gl;

import std.conv;
import std.exception;
import std.file;
import std.traits;
public import dgs.Image;
public import dgs.Input;
public import dgs.Rect;
public import dgs.Sprite;
public import dgs.Window;

void initDgs(){
    chdir("lib");
    version(Posix){
        DerelictSDL2.load("./libSDL2.so");
        DerelictSDL2ttf.load("./libSDL2_ttf.so");
    }else{
        DerelictSDL2.load();
        DerelictSDL2ttf.load();
    }
	DerelictIL.load();
	chdir("..");

	assert(!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_JOYSTICK | SDL_INIT_AUDIO));
    assert(!TTF_Init());
    ilInit();

    initialized = true;
}

void destroyDgs(){
    ilShutDown();
    TTF_Quit();
    //Mix_CloseAudio();
    SDL_Quit();
    initialized = false;
}

package:

bool initialized;

