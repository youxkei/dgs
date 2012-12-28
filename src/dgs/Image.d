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

final class Image
{
    invariant()
    {
        assert(initialized);
    }

    public
    {
        this(in string file)
        in
        {
            assert(file);
        }
        body
        {
            uint image = 0;
            ilCheck!ilGenImages(1, &image);
            scope(exit) ilCheck!ilDeleteImages(1, &image);
            ilCheck!ilBindImage(image);
            ilCheck!ilLoadImage(file.toStringz());
            ilCheck!ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE);

            width_ = ilCheck!ilGetInteger(IL_IMAGE_WIDTH);
            height_ = ilCheck!ilGetInteger(IL_IMAGE_HEIGHT);
            textureWidth_ = powerOfTwo(width_);
            textureHeight_ = powerOfTwo(height_);

            createTexture(ilCheck!ilGetData());
        }

        this(in string str, in int size, in ubyte red = 255, in ubyte green = 255, in ubyte blue = 255)
        in
        {
            assert(str);
            assert(size >= 1);
            assert(size <= 127);
        }
        body
        {
            if(!fonts[size]){
                fonts[size] = TTF_OpenFont("font/umeplus-gothic.ttf", size);
                assert(fonts[size]);
            }
            auto font = fonts[size];
            auto surface = TTF_RenderUTF8_Blended(font, str.toStringz(), SDL_Color(red, green, blue));
            assert(surface);
            scope(exit) SDL_FreeSurface(surface);

            width_ = surface.w;
            height_ = surface.h;
            textureWidth_ = powerOfTwo(width_);
            textureHeight_ = powerOfTwo(height_);

            createTexture(surface.pixels);
        }

        void bind() const nothrow
        {
            glBindTexture(GL_TEXTURE_2D, texture_);
        }

        FloatRect getTexCoords(in IntRect arect) const @safe nothrow
        in
        {
            assert(textureWidth_ > 0);
            assert(textureHeight_ > 0);
        }
        body
        {
            float lwidth = textureWidth_;
            float lheight = textureHeight_;
            return FloatRect(arect.left / lwidth, arect.top / lheight, arect.right / lwidth, arect.bottom / lheight);
        }

        
        int width() const pure @safe nothrow @property
        {
            return width_;
        }

        
        int height() const pure @safe nothrow @property
        {
            return height_;
        }

        
        int textureWidth() const pure @safe nothrow @property
        {
            return textureWidth_;
        }

        
        int textureHeight() const pure @safe nothrow @property
        {
            return textureHeight_;
        }
    }

    private
    {
        uint width_;
        uint height_;
        uint textureWidth_;
        uint textureHeight_;
        uint texture_;

        void createTexture(in void* pixels)
        {
            glGenTextures(1, &texture_);
            bind();
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, textureWidth_, textureHeight_, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width_, height_, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
        }
    }

    private static
    {
        TTF_Font*[128] fonts;

        
        int powerOfTwo(in int num) pure @trusted nothrow
        in{
            assert(num > 0);
        }
        out(res)
        {
            assert(res > 0);
        }
        body
        {
            auto left = bsf(num);
            auto right = bsr(num);
            if(left == right)
            {
                return num;
            }
            else
            {
                return 1 << (right + 1);
            }
        }

        unittest
        {
            assert(powerOfTwo(5) == 8);
            assert(powerOfTwo(19) == 32);
            assert(powerOfTwo(64) == 64);
            assert(powerOfTwo(980) == 1024);
        }
    }
}
