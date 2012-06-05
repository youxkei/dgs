module dgs.Window;

import dgs.all;
import dgs.Input;
import dgs.util;
import derelict.sdl2.sdl;
//import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
import derelict.devil.il;
import org.opengl.gl;

import std.conv;
import std.exception;
import std.file;
import std.stdio;
import std.string;
import std.typecons;

void openWindow(int width, int height)in{
    assert(initialized);
}body{
	enforce(!SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, true));

    window = enforce(SDL_CreateWindow("Caption", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN));
    context = enforce(SDL_GL_CreateContext(window));

	glCheck!glOrtho(0.0, width, height, 0.0, -1.0, 1.0);
	glCheck!glClearColor( 0.0, 0.0, 0.0, 1.0 );
	glCheck!glEnable(GL_TEXTURE_2D);
	glCheck!glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glCheck!glEnable(GL_BLEND);
	glCheck!glDisable(GL_DEPTH_TEST);

	glCheck!glClear(GL_COLOR_BUFFER_BIT);
    SDL_GL_SwapWindow(window);

    initInput();
	windowOpened = true;
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

void clearWindow(){
	glCheck!glClear(GL_COLOR_BUFFER_BIT);
}

void updateWindow(){
    SDL_GL_SwapWindow(window);
}

void setWindowTitle(string aname){
    //SDL_WM_SetCaption(aname.toStringz, null);
}

package:

SDL_Window* window;
SDL_GLContext context;
bool windowOpened;
