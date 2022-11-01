unit MathLibrary;

{$mode ObjFPC}{$H+}


interface

const
  External_library = 'MathLibrary';

  {$ifdef windows}
    libext = '.dll';
  {$endif}
  {$ifdef unix}
    libext = '.so';
  {$endif}
  {$ifdef macos}
    libext = '.dylib';
  {$endif}

{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}


{ original declaration from MathLibrary.h:
  extern "C" MATHLIBRARY_API void fibonacci_init(const unsigned long long a, const unsigned long long b);
  }
procedure fibonacci_init(a:QWord; b:QWord); cdecl; external External_library + libext;

{ original declaration from MathLibrary.h:
  extern "C" MATHLIBRARY_API bool fibonacci_next();
  }
function fibonacci_next(): Boolean; cdecl; external External_library + libext;

{ original declaration from MathLibrary.h:
  extern "C" MATHLIBRARY_API unsigned long long fibonacci_current();
  }
function fibonacci_current(): QWord; cdecl; external External_library + libext;

{ original declaration from MathLibrary.h:
  extern "C" MATHLIBRARY_API unsigned fibonacci_index();
  }
function fibonacci_index(): Integer; cdecl; external External_library + libext;


implementation

end.

