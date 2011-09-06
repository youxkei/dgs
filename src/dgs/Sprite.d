module dgs.Sprite;

import std.math;
import std.traits;
import std.typecons;
import derelict.opengl.gl;
import dgs.Image;
import dgs.Rect;
import dgs.util;

mixin(defBoth!(__LINE__)("Sprite", q{
    public{
        float x = 0;
        float y = 0;
        float centerX = 0;
        float centerY = 0;
        float scaleX = 1;
        float scaleY = 1;
        bool flipX;
        bool flipY;
        float rotate = 0;
        float alpha = 1;
        bool visible = true;
        IntRect subRect;

        invariant(){
            assert(isFinite(px));
            assert(isFinite(py));
            assert(isFinite(pcenterX));
            assert(isFinite(pcenterY));
            assert(isFinite(pscaleX));
            assert(isFinite(pscaleY));
            assert(isFinite(protate));
            assert(isFinite(palpha));
            assert(palpha <= 1);
            assert(palpha >= 0);
        }

        typeof(this) reset(){
            px = 0;
            py = 0;
            pcenterX = 0;
            pcenterY = 0;
            pscaleX = 1;
            pscaleY = 1;
            protate = 1;
            palpha = 1;
            pvisible = true;
            psubRect = IntRect.init;
            pimage = null;
            return this;
        }

        void draw(){
            if(!pvisible){
                return;
            }
            float lwidth = psubRect.width;
            float lheight = psubRect.height;
            if(pimage && pimage.width && pimage.height){
                import std.stdio;
                pimage.bind();
                glCheck!glPushMatrix();
                glCheck!glTranslatef(0.375f, 0.375f, 0);
                glCheck!glColor4f(1, 1, 1, alpha);
                glCheck!glTranslatef(px + pcenterX, py + pcenterY, 0);
                glCheck!glRotatef(protate, 0, 0, 1);
                glCheck!glTranslatef(-pcenterX, -pcenterY, 0);
                glCheck!glScalef(pscaleX, pscaleY, 1);

                FloatRect lrect = pimage.getTexCoords(psubRect).flip(pflipX, pflipY);
                glBegin(GL_QUADS);
                    glTexCoord2f(lrect.left, lrect.top);        glVertex2f(0, 0);
                    glTexCoord2f(lrect.left, lrect.bottom);     glVertex2f(0, lheight);
                    glTexCoord2f(lrect.right, lrect.bottom);    glVertex2f(lwidth, lheight);
                    glTexCoord2f(lrect.right, lrect.top);       glVertex2f(lwidth, 0);
                glEnd();

                glCheck!glPopMatrix();
            }
        }

        template field(fields...){
            static assert(staticLength!fields > 0);
            static assert(check!fields);

            typeof(this) set(getTuple!fields.Types args){
                foreach(i, field; fields){
                    __traits(getMember, typeof(this), field) = args[i];
                }
                return this;
            }

            getTuple!fields get(){
                typeof(return) res;
                foreach(i, field; fields){
                    res[i] = __traits(getMember, typeof(this), field);
                }
                return res;
            }
        }

        Image image()@property{
            return pimage;
        }

        void image(Image aimage)@property{
            if(!pimage && aimage.width > 0 && aimage.height > 0){
                subRect = IntRect(0, 0, aimage.width, aimage.height);
            }
            pimage = aimage;
        }
    }

    private{
        alias x px;
        alias y py;
        alias centerX pcenterX;
        alias centerY pcenterY;
        alias scaleX pscaleX;
        alias scaleY pscaleY;
        alias flipX pflipX;
        alias flipY pflipY;
        alias rotate protate;
        alias alpha palpha;
        alias visible pvisible;
        alias subRect psubRect;
        Image pimage;

        template check(fields...){
            static assert(staticLength!fields > 0);
            static if(staticLength!fields == 1){
                enum check = hasMember!(typeof(this), fields[0]);
            }else{
                enum check = hasMember!(typeof(this), fields[0]) && check!(fields[1..$]);
            }
        }

        template getTuple(fields...){
            static assert(staticLength!fields > 0);
            static if(staticLength!fields == 1){
                alias Tuple!(typeof(mixin(fields[0]))) getTuple;
            }else{
                alias Tuple!(typeof(mixin(fields[0])), getTuple!(fields[1..$]).Types) getTuple;
            }
        }
    }
}));

alias CSprite Sprite;
