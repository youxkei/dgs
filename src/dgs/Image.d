module dgs.Image;

import core.bitop;
import derelict.devil.il;
import derelict.opengl.gl;
import derelict.sdl.sdl;
import derelict.sdl.ttf;
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

        this(in string afile)in{
            assert(initialized);
            assert(afile);
        }body{
            uint aimage = 0;
            ilCheck!ilGenImages(1, &aimage);
            scope(exit) ilCheck!ilDeleteImages(1, &aimage);
            ilCheck!ilBindImage(aimage);
            ilCheck!ilLoadImage(afile.toStringz());
            ilCheck!ilConvertImage(IL_RGBA, IL_UNSIGNED_BYTE);

            pwidth = ilCheck!ilGetInteger(IL_IMAGE_WIDTH);
            pheight = ilCheck!ilGetInteger(IL_IMAGE_HEIGHT);
            ptextureWidth = powerOfTwo(pwidth);
            ptextureHeight = powerOfTwo(pheight);

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

            pwidth = asurface.w;
            pheight = asurface.h;
            ptextureWidth = powerOfTwo(pwidth);
            ptextureHeight = powerOfTwo(pheight);

            createTexture(asurface.pixels);
        }

        void bind()const in{
            assert(windowOpened);
        }body{
            glBindTexture(GL_TEXTURE_2D, ptexture);
        }

        FloatRect getTexCoords(const ref IntRect arect)const in{
            assert(ptextureWidth > 0);
            assert(ptextureHeight > 0);
        }body{
            float lwidth = ptextureWidth;
            float lheight = ptextureHeight;
            return FloatRect(arect.left / lwidth, arect.top / lheight, arect.right / lwidth, arect.bottom / lheight);
        }

        int width()const @property{
            return pwidth;
        }

        int height()const @property{
            return pheight;
        }

        int textureWidth()const @property{
            return ptextureWidth;
        }

        int textureHeight()const @property{
            return ptextureHeight;
        }
    }

    private{
        uint pwidth;
        uint pheight;
        uint ptextureWidth;
        uint ptextureHeight;
        uint ptexture;

        void createTexture(in void* apixels)in{
            assert(windowOpened);
        }body{
            glGenTextures(1, &ptexture);
            bind();
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ptextureWidth, ptextureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, null);
            glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, pwidth, pheight, GL_RGBA, GL_UNSIGNED_BYTE, apixels);
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
