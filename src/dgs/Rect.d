module dgs.Rect;

struct Rect(T)
{
    public
    {
        T left;
        T top;
        T right;
        T bottom;

        Rect flip(bool x, bool y) const pure @safe nothrow
        {
            return Rect(
                x ? right : left,
                y ? bottom : top,
                x ? left : right,
                y ? top : bottom
            );
        }

        
        T width() const pure @safe nothrow @property
        {
            return right - left;
        }

        
        T height() const pure @safe nothrow @property
        {
            return bottom - top;
        }
    }
}

alias Rect!int IntRect;
alias Rect!float FloatRect;
