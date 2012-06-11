module dgs.Image;

import core.bitop;
import derelict.devil.il;
import org.opengl.gl;
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
        }

        this(in string file)in{
            assert(initialized);
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

        this(in string astring, in int asize, in ubyte ared = 255, in ubyte agreen = 255, in ubyte ablue = 255)in{
            assert(initialized);
            assert(astring);
            assert(asize >= 1);
            assert(asize <= 127);
        }body{
            if(!pfonts[asize]){
                pfonts[asize] = TTF_OpenFont("font/umeplus-gothic.ttf", asize);
                assert(pfonts[asize]);
            }
            auto afont = pfonts[asize];
            auto asurface = TTF_RenderUTF8_Blended(afont, astring.toStringz(), SDL_Color(ared, agreen, ablue));
            assert(asurface);
            scope(exit) SDL_FreeSurface(asurface);

            _width = asurface.w;
            _height = asurface.h;
            _textureWidth = powerOfTwo(_width);
            _textureHeight = powerOfTwo(_height);

            createTexture(asurface.pixels);
        }

        void bind()const in{
            assert(initialized);
        }body{
            glBindTexture(GL_TEXTURE_2D, _texture);
        }

        FloatRect getTexCoords(const ref IntRect arect)const in{
            assert(_textureWidth > 0);
            assert(_textureHeight > 0);
        }body{
            float lwidth = _textureWidth;
            float lheight = _textureHeight;
            return FloatRect(arect.left / lwidth, arect.top / lheight, arect.right / lwidth, arect.bottom / lheight);
        }

        const @property
        int width(){
            return _width;
        }

        const @property
        int height(){
            return _height;
        }

        const @property
        int textureWidth(){
            return _textureWidth;
        }

        const @property
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

        void createTexture(in void* apixels)in{
            assert(initialized);
        }body{
            glGenTextures(1, &_texture);
            bind();
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _textureWidth, _textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, _width, _height, GL_RGBA, GL_UNSIGNED_BYTE, apixels);
        }
    }

    private static{
        TTF_Font*[128] pfonts;

        int powerOfTwo(in int anum)pure in{
            assert(anum > 0);
        }out(ares){
            assert(ares > 0);
        }body{
            auto lleft = bsf(anum);
            auto lright = bsr(anum);
            if(lleft == lright){
                return anum;
            }else{
                return 1 << (lright + 1);
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
