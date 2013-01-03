module dgs.util;

import std.conv;
import std.traits;
import derelict.devil.il;
import derelict.opengl3.gl;

struct NamedValue(string n, T)
{
    enum name = n;
    T value;
}

NamedValue!(name, T) n(string name, T)(T arg) @property
{
    return NamedValue!(name, T)(arg);
}

package:

mixin template ctor(members...)
{
    mixin(make(members));
}

string defBoth(int line = __LINE__)(string name, string src)
{
    return "struct S" ~ name ~ "{" ~ src ~ "}\n #line " ~ to!string(line) ~ "\n final class C" ~ name ~ "{" ~ src ~ "}";
}

unittest
{
    mixin(defBoth("Vector", q{
        int x;
        int y;
        void f(){
            throw new Exception("");
        }
    }));

    CVector cv = new CVector();
    try
    {
        cv.f();
    }
    catch(Exception e)
    {
        assert(e.file == __FILE__);
        assert(e.line == __LINE__ - 12);
    }

    SVector sv;
    try
    {
        sv.f();
    }
    catch(Exception e)
    {
        assert(e.file == __FILE__);
        assert(e.line == __LINE__ - 23);
    }
}

debug
{
    void glCheck(alias Func)(ParameterTypeTuple!Func args)
    {
        Func(args);
        GLenum code = glGetError();
        if(code != GL_NO_ERROR)
        {
            string error;
            string desc;
            switch (code)
            {
                case GL_INVALID_ENUM:
                    error = "GL_INVALID_ENUM";
                    desc  = "an unacceptable value has been specified for an enumerated argument";
                    break;

                case GL_INVALID_VALUE:
                    error = "GL_INVALID_VALUE";
                    desc  = "a numeric argument is out of range";
                    break;

                case GL_INVALID_OPERATION:
                    error = "GL_INVALID_OPERATION";
                    desc  = "the specified operation is not allowed in the current state";
                    break;

                case GL_STACK_OVERFLOW:
                    error = "GL_STACK_OVERFLOW";
                    desc  = "this command would cause a stack overflow";
                    break;

                case GL_STACK_UNDERFLOW:
                    error = "GL_STACK_UNDERFLOW";
                    desc  = "this command would cause a stack underflow";
                    break;

                case GL_OUT_OF_MEMORY:
                    error = "GL_OUT_OF_MEMORY";
                    desc  = "there is not enough memory left to execute the command";
                    break;

                default:
                    error = "unknown error";
                    desc = "no description";
            }
            throw new Exception(error ~ ", " ~ desc);
        }
    }

    ReturnType!Func ilCheck(alias Func)(ParameterTypeTuple!Func args)
    {
        enum isVoidFunc = is(typeof(return) == void);

        static if(isVoidFunc)
        {
            Func(args);
        }
        else
        {
            auto res = Func(args);
        }

        ILenum code = ilGetError();
        if(code != IL_NO_ERROR)
        {
            string error;
            string desc;
            switch(code){
                case IL_INVALID_ENUM:
                    error = "IL_INVALID_ENUM";
                    desc = "an unacceptable enumerated value was passed to a function";
                    break;

                case IL_OUT_OF_MEMORY:
                    error = "IL_OUT_OF_MEMORY";
                    desc = "could not allocate enough memory in an operation";
                    break;

                case IL_FORMAT_NOT_SUPPORTED:
                    error = "IL_FORMAT_NOT_SUPPORTED";
                    desc = "the format a function tried to use was not able to be used by that function";
                    break;

                case IL_INTERNAL_ERROR:
                    error = "IL_INTERNAL_ERROR";
                    desc = "a serious error has occurred";
                    break;

                case IL_INVALID_VALUE:
                    error = "IL_INVALID_VALUE";
                    desc = "an invalid value was passed to a function or was in a file";
                    break;

                case IL_ILLEGAL_FILE_VALUE:
                    error = "IL_ILLEGAL_FILE_VALUE";
                    desc = "an illegal value was found in a file trying to be loaded";
                    break;

                case IL_INVALID_FILE_HEADER:
                    error = "IL_INVALID_FILE_HEADER";
                    desc = "a file's header was incorrect";
                    break;

                case IL_INVALID_PARAM:
                    error = "IL_INVALID_PARAM";
                    desc = "an invalid parameter was passed to a function, such as a NULL pointer";
                    break;

                case IL_COULD_NOT_OPEN_FILE:
                    error = "IL_COULD_NOT_OPEN_FILE";
                    desc = "could not open the file specified. the file may already be open by another app or may not exist";
                    break;

                case IL_INVALID_EXTENSION:
                    error = "IL_INVALID_EXTENSION";
                    desc = "the extension of the specified filename was not correct for the type of image-loading function";
                    break;

                case IL_FILE_ALREADY_EXISTS:
                    error = "IL_FILE_ALREADY_EXISTS";
                    desc = "the filename specified already belongs to another file";
                    break;

                case IL_OUT_FORMAT_SAME:
                    error = "IL_OUT_FORMAT_SAME";
                    desc = "tried to convert an image from its format to the same format";
                    break;

                case IL_STACK_OVERFLOW:
                    error = "IL_STACK_OVERFLOW";
                    desc = "one of the internal stacks was already filled, and the user tried to add on to the full stack";
                    break;

                case IL_STACK_UNDERFLOW:
                    error = "IL_STACK_UNDERFLOW";
                    desc = "one of the internal stacks was empty, and the user tried to empty the already empty stack";
                    break;

                case IL_INVALID_CONVERSION:
                    error = "IL_INVALID_CONVERSION";
                    desc = "an invalid conversion attempt was tried";
                    break;

                case IL_LIB_JPEG_ERROR:
                    error = "IL_LIB_JPEG_ERROR";
                    desc = "an error occurred in the libjpeg library";
                    break;

                case IL_LIB_PNG_ERROR:
                    error = "IL_LIB_PNG_ERROR";
                    desc = "an error occurred in the libpng library";
                    break;

                case IL_UNKNOWN_ERROR:
                    error = "IL_UNKNOWN_ERROR";
                    desc = "no function sets this yet, but it is possible (not probable) it may be used in the future";
                    break;

                default:
                    error = "unknown error";
                    desc = "no description";
                    break;
            }
            throw new Exception(error ~ ", " ~ desc);
        }
        static if(!isVoidFunc)
        {
            return res;
        }
    }
}
else
{
    template glCheck(alias Func)
    {
        alias Func glCheck;
    }

    template ilCheck(alias Func)
    {
        alias Func ilCheck;
    }
}

private:

string make(T...)(T members)
{
    string dec;
    string def;
    foreach(i, member; members)
    {
        if(i)
        {
            dec ~= ",";
        }
        dec ~= "typeof("~member~") a"~member;
        def ~= member~"=a"~member~";";
    }
    return "this("~dec~"){"~def~"}";
}

unittest
{
    enum dg =
    {
        assert(make("a", "b") == q{this(typeof(a) aa,typeof(b) ab){a=aa;b=ab;}});
        return true;
    };
    static assert(dg());
    dg();
}
