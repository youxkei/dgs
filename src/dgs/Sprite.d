module dgs.Sprite;

import std.math;
import std.traits;
import std.typecons;
import derelict.opengl3.gl;
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
            assert(isFinite(x));
            assert(isFinite(y));
            assert(isFinite(centerX));
            assert(isFinite(centerY));
            assert(isFinite(scaleX));
            assert(isFinite(scaleY));
            assert(isFinite(rotate));
            assert(isFinite(alpha));
            assert(alpha <= 1);
            assert(alpha >= 0);
        }

        typeof(this) reset(){
            x = 0;
            y = 0;
            centerX = 0;
            centerY = 0;
            scaleX = 1;
            scaleY = 1;
            rotate = 1;
            alpha = 1;
            visible = true;
            subRect = IntRect.init;
            image = null;
            return this;
        }

        void draw(){
            if(!visible){
                return;
            }
            float width = subRect.width;
            float height = subRect.height;
            if(image && image.width && image.height){
                image.bind();
                glCheck!glPushMatrix();
                glCheck!glTranslatef(0.375f, 0.375f, 0);
                glCheck!glColor4f(1, 1, 1, alpha);
                glCheck!glTranslatef(x + centerX, y + centerY, 0);
                glCheck!glRotatef(rotate, 0, 0, 1);
                glCheck!glTranslatef(-centerX, -centerY, 0);
                glCheck!glScalef(scaleX, scaleY, 1);

                FloatRect rect = image.getTexCoords(subRect).flip(flipX, flipY);
                glBegin(GL_QUADS);
                    glTexCoord2f(rect.left, rect.top);        glVertex2f(0, 0);
                    glTexCoord2f(rect.left, rect.bottom);     glVertex2f(0, height);
                    glTexCoord2f(rect.right, rect.bottom);    glVertex2f(width, height);
                    glTexCoord2f(rect.right, rect.top);       glVertex2f(width, 0);
                glEnd();

                glCheck!glPopMatrix();
            }
        }

        template field(fields...){
            static assert(fields.length > 0);
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
            return _image;
        }

        void image(Image image)@property{
            if(!_image && image.width > 0 && image.height > 0){
                subRect = IntRect(0, 0, image.width, image.height);
            }
            _image = image;
        }
    }

    private{
        Image _image;

        template check(fields...){
            static assert(fields.length > 0);
            static if(fields.length == 1){
                enum check = hasMember!(typeof(this), fields[0]);
            }else{
                enum check = hasMember!(typeof(this), fields[0]) && check!(fields[1..$]);
            }
        }

        template getTuple(fields...){
            static assert(fields.length > 0);
            static if(fields.length == 1){
                alias Tuple!(typeof(mixin(fields[0]))) getTuple;
            }else{
                alias Tuple!(typeof(mixin(fields[0])), getTuple!(fields[1..$]).Types) getTuple;
            }
        }
    }
}));

alias CSprite Sprite;
