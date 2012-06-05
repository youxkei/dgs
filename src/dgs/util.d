module dgs.util;

import std.conv;
import std.traits;
import derelict.devil.il;
import org.opengl.gl;

package:

mixin template ctor(members...){
    mixin(make(members));
}

string defBoth(int line = __LINE__)(string name, string src){
    return "struct S" ~ name ~ "{" ~ src ~ "}\n #line " ~ to!string(line) ~ "\n final class C" ~ name ~ "{" ~ src ~ "}";
}

unittest{
    mixin(defBoth("Vector", q{
        int x;
        int y;
        void f(){
            throw new Exception("");
        }
    }));

    CVector cv = new CVector();
    try{
        cv.f();
    }catch(Exception e){
        assert(e.file == __FILE__);
        assert(e.line == __LINE__ - 9);
    }

    SVector sv;
    try{
        sv.f();
    }catch(Exception e){
        assert(e.file == __FILE__);
        assert(e.line == __LINE__ - 17);
    }
}

debug{
    void glCheck(alias Func)(ParameterTypeTuple!Func aargs){
        Func(aargs);
        GLenum lerrorCode = glGetError();
        if(lerrorCode != GL_NO_ERROR){
            string lerror;
            string ldesc;
            switch (lerrorCode){
                case GL_INVALID_ENUM:{
                    lerror = "GL_INVALID_ENUM";
                    ldesc  = "an unacceptable value has been specified for an enumerated argument";
                    break;
                }

                case GL_INVALID_VALUE:{
                    lerror = "GL_INVALID_VALUE";
                    ldesc  = "a numeric argument is out of range";
                    break;
                }

                case GL_INVALID_OPERATION:{
                    lerror = "GL_INVALID_OPERATION";
                    ldesc  = "the specified operation is not allowed in the current state";
                    break;
                }

                case GL_STACK_OVERFLOW:{
                    lerror = "GL_STACK_OVERFLOW";
                    ldesc  = "this command would cause a stack overflow";
                    break;
                }

                case GL_STACK_UNDERFLOW:{
                    lerror = "GL_STACK_UNDERFLOW";
                    ldesc  = "this command would cause a stack underflow";
                    break;
                }

                case GL_OUT_OF_MEMORY:{
                    lerror = "GL_OUT_OF_MEMORY";
                    ldesc  = "there is not enough memory left to execute the command";
                    break;
                }

                default:{
                    lerror = "unknown error";
                    ldesc = "no description";
                }
            }
            throw new Exception(lerror ~ ", " ~ ldesc);
        }
    }

    ReturnType!Func ilCheck(alias Func)(ParameterTypeTuple!Func aargs){
        enum isVoidFunc = is(typeof(return) == void);
        static if(isVoidFunc){
            Func(aargs);
        }else{
            auto res = Func(aargs);
        }
        ILenum lerrorCode = ilGetError();
        if(lerrorCode != IL_NO_ERROR){
            string lerror;
            string ldesc;
            switch(lerrorCode){
                case IL_INVALID_ENUM:{
                    lerror = "IL_INVALID_ENUM";
                    ldesc = "an unacceptable enumerated value was passed to a function";
                    break;
                }

                case IL_OUT_OF_MEMORY:{
                    lerror = "IL_OUT_OF_MEMORY";
                    ldesc = "could not allocate enough memory in an operation";
                    break;
                }

                case IL_FORMAT_NOT_SUPPORTED:{
                    lerror = "IL_FORMAT_NOT_SUPPORTED";
                    ldesc = "the format a function tried to use was not able to be used by that function";
                    break;
                }

                case IL_INTERNAL_ERROR:{
                    lerror = "IL_INTERNAL_ERROR";
                    ldesc = "a serious error has occurred";
                    break;
                }

                case IL_INVALID_VALUE:{
                    lerror = "IL_INVALID_VALUE";
                    ldesc = "an invalid value was passed to a function or was in a file";
                    break;
                }

                case IL_ILLEGAL_FILE_VALUE:{
                    lerror = "IL_ILLEGAL_FILE_VALUE";
                    ldesc = "an illegal value was found in a file trying to be loaded";
                    break;
                }

                case IL_INVALID_FILE_HEADER:{
                    lerror = "IL_INVALID_FILE_HEADER";
                    ldesc = "a file's header was incorrect";
                    break;
                }

                case IL_INVALID_PARAM:{
                    lerror = "IL_INVALID_PARAM";
                    ldesc = "an invalid parameter was passed to a function, such as a NULL pointer";
                    break;
                }

                case IL_COULD_NOT_OPEN_FILE:{
                    lerror = "IL_COULD_NOT_OPEN_FILE";
                    ldesc = "could not open the file specified. the file may already be open by another app or may not exist";
                    break;
                }

                case IL_INVALID_EXTENSION:{
                    lerror = "IL_INVALID_EXTENSION";
                    ldesc = "the extension of the specified filename was not correct for the type of image-loading function";
                    break;
                }

                case IL_FILE_ALREADY_EXISTS:{
                    lerror = "IL_FILE_ALREADY_EXISTS";
                    ldesc = "the filename specified already belongs to another file";
                    break;
                }

                case IL_OUT_FORMAT_SAME:{
                    lerror = "IL_OUT_FORMAT_SAME";
                    ldesc = "tried to convert an image from its format to the same format";
                    break;
                }

                case IL_STACK_OVERFLOW:{
                    lerror = "IL_STACK_OVERFLOW";
                    ldesc = "one of the internal stacks was already filled, and the user tried to add on to the full stack";
                    break;
                }

                case IL_STACK_UNDERFLOW:{
                    lerror = "IL_STACK_UNDERFLOW";
                    ldesc = "one of the internal stacks was empty, and the user tried to empty the already empty stack";
                    break;
                }

                case IL_INVALID_CONVERSION:{
                    lerror = "IL_INVALID_CONVERSION";
                    ldesc = "an invalid conversion attempt was tried";
                    break;
                }

                case IL_LIB_JPEG_ERROR:{
                    lerror = "IL_LIB_JPEG_ERROR";
                    ldesc = "an error occurred in the libjpeg library";
                    break;
                }

                case IL_LIB_PNG_ERROR:{
                    lerror = "IL_LIB_PNG_ERROR";
                    ldesc = "an error occurred in the libpng library";
                    break;
                }

                case IL_UNKNOWN_ERROR:{
                    lerror = "IL_UNKNOWN_ERROR";
                    ldesc = "no function sets this yet, but it is possible (not probable) it may be used in the future";
                    break;
                }

                default:{
                    lerror = "unknown error";
                    ldesc = "no description";
                    break;
                }
            }
            throw new Exception(lerror ~ ", " ~ ldesc);
        }
        static if(!isVoidFunc){
            return res;
        }
    }
}else{
    template glCheck(alias Func){
        alias Func glCheck;
    }

    template ilCheck(alias Func){
        alias Func ilCheck;
    }
}

private:

string make(T...)(T members){
    string dec;
    string def;
    foreach(i, member; members){
        if(i){
            dec ~= ",";
        }
        dec ~= "typeof("~member~") a"~member;
        def ~= member~"=a"~member~";";
    }
    return "this("~dec~"){"~def~"}";
}

unittest{
    enum dg = {
        assert(make("a", "b") == q{this(typeof(a) aa,typeof(b) ab){a=aa;b=ab;}});
        return true;
    };
    static assert(dg());
    dg();
}
