module dgs.Rect;

struct Rect(T){
    public{
        T left;
        T top;
        T right;
        T bottom;

        const pure @safe nothrow 
        Rect flip(bool x, bool y){
            return Rect(
                x ? right : left,
                y ? bottom : top,
                x ? left : right,
                y ? top : bottom
            );
        }

        const pure @safe nothrow @property
        T width(){
            return right - left;
        }

        const pure @safe nothrow @property
        T height(){
            return bottom - top;
        }
    }
}

alias Rect!int IntRect;
alias Rect!float FloatRect;
