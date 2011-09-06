module dgs.all;

import derelict.opengl.gl;
import derelict.devil.il;
import derelict.sdl.sdl;
import derelict.sdl.mixer;
import derelict.sdl.ttf;

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
	DerelictSDL.load();
	DerelictSDLMixer.load();
	DerelictSDLttf.load();
	DerelictIL.load();
	DerelictGL.load();
	chdir("..");

	assert(!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_JOYSTICK | SDL_INIT_AUDIO));
    assert(!Mix_OpenAudio(44100, AUDIO_S16, 2, 4096) );
    assert(!TTF_Init());
    ilInit();

    pinitialized = true;
}

void destroyDgs(){
    ilShutDown();
    TTF_Quit();
    Mix_CloseAudio();
    SDL_Quit();
    pinitialized = false;
}

package:

bool initialized;

private:

alias initialized pinitialized;
