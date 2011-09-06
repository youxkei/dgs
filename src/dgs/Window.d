module dgs.Window;

import dgs.all;
import dgs.Input;
import dgs.util;
import derelict.sdl.sdl;
import derelict.sdl.mixer;
import derelict.sdl.ttf;
import derelict.devil.il;
import derelict.opengl.gl;

import std.conv;
import std.exception;
import std.file;
import std.stdio;
import std.string;
import std.typecons;

void openWindow(int awidth, int aheight, bool avsync = true)in{
    assert(initialized);
}body{
	assert(!SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, true));
	assert(!SDL_GL_SetAttribute(SDL_GL_SWAP_CONTROL, avsync));

	assert(SDL_SetVideoMode(awidth, aheight, 32, SDL_OPENGL | SDL_RESIZABLE));

	int lvsyncCheck;
	SDL_GL_GetAttribute(SDL_GL_SWAP_CONTROL, &lvsyncCheck);
	writeln("vsync: ", lvsyncCheck == 1);

	glCheck!glOrtho(0.0, awidth, aheight, 0.0, -1.0, 1.0);
	glCheck!glClearColor( 0.0, 0.0, 0.0, 1.0 );
	glCheck!glEnable(GL_TEXTURE_2D);
	glCheck!glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glCheck!glEnable(GL_BLEND);
	glCheck!glDisable(GL_DEPTH_TEST);

	glCheck!glClear(GL_COLOR_BUFFER_BIT);
	SDL_GL_SwapBuffers();

    initInput();
	pwindowOpened = true;
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
            case SDL_ACTIVEEVENT:
                if(!levent.active.gain && levent.active.state & (SDL_APPINPUTFOCUS | SDL_APPACTIVE)){
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
	SDL_GL_SwapBuffers();
}

void setWindowTitle(string aname){
    SDL_WM_SetCaption(aname.toStringz, null);
}

package:

bool windowOpened;

private:
alias windowOpened pwindowOpened;
