module dgs.all;

import derelict.devil.il;
import derelict.sdl2.sdl;
//import derelict.sdl.mixer;
import derelict.sdl2.ttf;
import derelict.opengl3.gl;

import std.conv;
import std.exception;
import std.file;
import std.traits;
import dgs.util;
public import dgs.Image;
public import dgs.Input;
public import dgs.Rect;
public import dgs.Sprite;
public import dgs.Window;

void initDgs(int width, int height, bool vsync){
    DerelictGL.load();
    //DerelictGL.reload();
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

	enforce(!SDL_Init(SDL_INIT_VIDEO));
    enforce(!SDL_InitSubSystem(SDL_INIT_JOYSTICK));
    enforce(!SDL_InitSubSystem(SDL_INIT_AUDIO));
    enforce(!TTF_Init());
    ilInit();

	enforce(!SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, true));
    window = enforce(SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN));
    context = enforce(SDL_GL_CreateContext(window));

	glCheck!glOrtho(0.0, width, height, 0.0, -1.0, 1.0);
	glCheck!glClearColor( 0.0, 0.0, 0.0, 1.0 );
	glCheck!glEnable(GL_TEXTURE_2D);
	glCheck!glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glCheck!glEnable(GL_BLEND);
	glCheck!glDisable(GL_DEPTH_TEST);

	glCheck!glClear(GL_COLOR_BUFFER_BIT);
    SDL_GL_SetSwapInterval(vsync ? 1 : 0);
    SDL_GL_SwapWindow(window);

    initInput();

    initialized = true;
}

void destroyDgs(){
    ilShutDown();
    TTF_Quit();
    //Mix_CloseAudio();
    SDL_Quit();

    initialized = false;
}

void processEvents(){
	updateKeyRepeat();
	SDL_Event levent;
	while(SDL_PollEvent(&levent)){
		switch(levent.type){
			case SDL_KEYDOWN:
			case SDL_KEYUP:
			case SDL_JOYBUTTONDOWN:
			case SDL_JOYBUTTONUP:
			case SDL_JOYAXISMOTION:
			case SDL_JOYHATMOTION:
			case SDL_MOUSEBUTTONDOWN:
			case SDL_MOUSEBUTTONUP:
			case SDL_MOUSEMOTION:
                processInputEvent(levent);
                break;
            case SDL_WINDOWEVENT:
                if(levent.window.event == SDL_WINDOWEVENT_FOCUS_LOST){
                    clearKeyStates();
                }
                break;
            case SDL_QUIT:
                throw new Exception("quit");
            default:
		}
	}
}


package:

bool initialized;
SDL_Window* window;
SDL_GLContext context;
