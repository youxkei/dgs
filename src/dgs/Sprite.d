module dgs.Sprite;

import std.math;
import std.traits;
import std.typecons;
import derelict.opengl3.gl;
import dgs.Image;
import dgs.Rect;
import dgs.util;

class Sprite
{
    invariant()
    {
        assert(isFinite(x));
        assert(isFinite(y));
        assert(isFinite(center.x));
        assert(isFinite(center.y));
        assert(isFinite(scale.x));
        assert(isFinite(scale.y));
        assert(isFinite(rotate));
        assert(isFinite(alpha));
        assert(alpha <= 1);
        assert(alpha >= 0);
    }

    public
    {
        float x = 0;
        float y = 0;
        Center center;
        Scale scale;
        Flip flip;
        float rotate = 0;
        float alpha = 1;
        bool visible = true;
        IntRect subRect;

        mixin ctor;

        void reset() @safe nothrow
        {
            x = 0;
            y = 0;
            center.x = 0;
            center.y = 0;
            scale.x = 1;
            scale.y = 1;
            flip.x = false;
            flip.y = false;
            rotate = 1;
            alpha = 1;
            visible = true;
            subRect = IntRect.init;
            image = null;
        }

        void draw()
        {
            if(!visible)
            {
                return;
            }
            float width = subRect.width;
            float height = subRect.height;
            if(image && image.width && image.height)
            {
                image.bind();
                glCheck!glPushMatrix();
                glCheck!glColor4f(1, 1, 1, alpha);
                glCheck!glTranslatef(x, y, 0);
                glCheck!glRotatef(rotate, 0, 0, 1);
                glCheck!glScalef(scale.x, scale.y, 1);
                glCheck!glTranslatef(-center.x, -center.y, 0);

                FloatRect rect = image.getTexCoords(subRect).flip(flip.x, flip.y);
                glBegin(GL_QUADS);
                    glTexCoord2f(rect.left, rect.top);        glVertex2f(0, 0);
                    glTexCoord2f(rect.left, rect.bottom);     glVertex2f(0, height);
                    glTexCoord2f(rect.right, rect.bottom);    glVertex2f(width, height);
                    glTexCoord2f(rect.right, rect.top);       glVertex2f(width, 0);
                glEnd();

                glCheck!glPopMatrix();
            }
        }

        Image image() pure @safe nothrow @property
        {
            return image_;
        }

        void image(Image image) @safe nothrow @property
        {
            if(!image_ && image && image.width > 0 && image.height > 0)
            {
                subRect = IntRect(0, 0, image.width, image.height);
            }
            image_ = image;
        }
    }

    private
    {
        Image image_;
    }
}

private:

struct Center
{
    float x = 0, y = 0;
}

struct Scale
{
    float x = 1, y = 1;
}

struct Flip
{
    bool x, y;
}
