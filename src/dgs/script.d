module dgs.script;

import std.conv;
import std.exception;
import std.file;
import std.typecons;
import std.variant;
/+import youkei.dpegparser;

struct Method{
    public{
        Variable call(Method[string] amethods, Variant[string] avariables, ref Stack astack, Varint[] aargs){
            enforce(aargs.length == pargs.length);
            foreach(i; 0..aargs.length){
                enforce(to!string(aargs[i].type) == pargs[i].ptype);
            }
            Variant lres;
            foreach(lstmt; pstmts){
                lstmt.run(amethods, avariables, astack, )
            }
        }
    }

    private{
        string ptype;
        string pname;
        Arg[] pargs;
        Stmt[] pstmts;
    }
}

struct Arg{
    string type;
    string name;
}

struct Stmt{
}

struct Stack{
}

mixin template makeEngine(bool isLoad, string[] files, types...){
    static if(isLoad){
        Variant function(Variant[])[string] methods;
    }else{
        Method[string] methods;
        Variant[string] variables;
        void load(){

        }

        Variant call(Args...)(in string afuncName, Args aargs){
            Stack stack;
            return methods[afuncName](methods, variables, stack, variantArray(aargs));
        }

        Variant opDispatch(string op, Args...)(Args aargs){
            return call(op, aargs);
        }
    }
}

unittest{
    struct engine{
        mixin makeEngine!Sprite(false, ["test.dgss", "test2.dgss"], Sprite);
    }
    engine.load();
    int i = engine.call("test", 7, 8);
}
+/
