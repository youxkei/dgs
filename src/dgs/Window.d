module dgs.Window;

import dgs.all;
import dgs.Input;
import dgs.util;
import derelict.sdl2.sdl;
//import derelict.sdl2.mixer;
import derelict.sdl2.ttf;
import derelict.devil.il;
import derelict.opengl3.gl;

import std.conv;
import std.exception;
import std.file;
import std.stdio;
import std.string;
import std.typecons;

void openWindow()
{
    enforce(initialized);
    SDL_ShowWindow(window);
	windowOpened = true;
}

void clearWindow()
{
	glCheck!glClear(GL_COLOR_BUFFER_BIT);
}

void updateWindow()
{
    SDL_GL_SwapWindow(window);
}

void setWindowTitle(string name)
{
    SDL_SetWindowTitle(window, name.toStringz());
}

package:

bool windowOpened;
