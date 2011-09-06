module dgs.Rect;

struct Rect(T){
    public{
        T left;
        T top;
        T right;
        T bottom;

        const typeof(this) flip(bool ax, bool ay){
            return Rect(
                ax ? pright : pleft,
                ay ? pbottom : ptop,
                ax ? pleft : pright,
                ay ? ptop : pbottom
            );
        }

        const @property T width(){
            return pright - pleft;
        }

        const @property T height(){
            return pbottom - ptop;
        }
    }

    private{
        alias left pleft;
        alias top ptop;
        alias right pright;
        alias bottom pbottom;
    }
}

alias Rect!int IntRect;
alias Rect!float FloatRect;
