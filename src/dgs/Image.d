module dgs.Image;

import core.bitop;
import derelict.devil.il;
import derelict.opengl3.gl;
import derelict.sdl2.sdl;
import derelict.sdl2.ttf;
import dgs.all;
import dgs.Rect;
import dgs.Window;
import dgs.util;
import std.conv;
import std.exception;
import std.math;
import std.string;

final class Image{
    public{
        invariant(){
            assert(initialized);
        }

        this(in string file)in{
            assert(file);
        }body{
            uint image = 0;
            ilCheck!ilGenImages(1, &image);
            scope(exit) ilCheck!ilDeleteImages(1, &image);
            ilCheck!ilBindImage(image);
            ilCheck!ilLoadImage(file.toStringz());
            ilCheck!ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE);

            _width = ilCheck!ilGetInteger(IL_IMAGE_WIDTH);
            _height = ilCheck!ilGetInteger(IL_IMAGE_HEIGHT);
            _textureWidth = powerOfTwo(_width);
            _textureHeight = powerOfTwo(_height);

            createTexture(ilCheck!ilGetData());
        }

        this(in string str, in int size, in ubyte red = 255, in ubyte green = 255, in ubyte blue = 255)in{
            assert(str);
            assert(size >= 1);
            assert(size <= 127);
        }body{
            if(!fonts[size]){
                fonts[size] = TTF_OpenFont("font/umeplus-gothic.ttf", size);
                assert(fonts[size]);
            }
            auto font = fonts[size];
            auto surface = TTF_RenderUTF8_Blended(font, str.toStringz(), SDL_Color(red, green, blue));
            assert(surface);
            scope(exit) SDL_FreeSurface(surface);

            _width = surface.w;
            _height = surface.h;
            _textureWidth = powerOfTwo(_width);
            _textureHeight = powerOfTwo(_height);

            createTexture(surface.pixels);
        }

        const void bind(){
            glBindTexture(GL_TEXTURE_2D, _texture);
        }

        const FloatRect getTexCoords(const ref IntRect arect)in{
            assert(_textureWidth > 0);
            assert(_textureHeight > 0);
        }body{
            float lwidth = _textureWidth;
            float lheight = _textureHeight;
            return FloatRect(arect.left / lwidth, arect.top / lheight, arect.right / lwidth, arect.bottom / lheight);
        }

        const pure @safe nothrow @property
        int width(){
            return _width;
        }

        const pure @safe nothrow @property
        int height(){
            return _height;
        }

        const pure @safe nothrow @property
        int textureWidth(){
            return _textureWidth;
        }

        const pure @safe nothrow @property
        int textureHeight(){
            return _textureHeight;
        }
    }

    private{
        uint _width;
        uint _height;
        uint _textureWidth;
        uint _textureHeight;
        uint _texture;

        void createTexture(in void* pixels){
            glGenTextures(1, &_texture);
            bind();
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _textureWidth, _textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, _width, _height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
        }
    }

    private static{
        TTF_Font*[128] fonts;

        pure @trusted nothrow
        int powerOfTwo(in int num)in{
            assert(num > 0);
        }out(res){
            assert(res > 0);
        }body{
            auto left = bsf(num);
            auto right = bsr(num);
            if(left == right){
                return num;
            }else{
                return 1 << (right + 1);
            }
        }

        unittest{
            assert(powerOfTwo(5) == 8);
            assert(powerOfTwo(19) == 32);
            assert(powerOfTwo(64) == 64);
            assert(powerOfTwo(980) == 1024);
        }
    }
}
