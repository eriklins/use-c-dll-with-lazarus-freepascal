# Use C/C++ DLL with Lazarus / Free Pascal
This was a learning project for me to get familiar with using/calling functions within a C/C++ shared-library (DLL) in a Lazarus / Free Pascal project.

## Intro
There is some documentation available for creating bindings for C libraries with Lazarus / Free Pascal in the official Free Pascal wiki:
* [Creating bindings for C libraries](https://wiki.freepascal.org/Creating_bindings_for_C_libraries)
* [Common problems when converting C header files](https://wiki.freepascal.org/Common_problems_when_converting_C_header_files)

There also is a quite comprehensive guide [Creating Pascal Bindings For C](https://github.com/williamhunter/pascal-bindings-for-c/blob/master/docs/Creating%20Pascal%20bindings%20for%20C%20(v1.0%29.pdf) available.

However, I found some of the examples to either difficult to follow/use or even not working at all with recent tool(chain) versions. I tried to convert the DLL header file with h2pas tool (or h2paswizard package in Lazarus) automatically, but it did not work, no matter which settings I tried in h2pas wizard.

So, I started from scratch and that's what this repo is about. Nevertheless the above links provided quite useful background information during this.

## DLL Project
When looking for a simple DLL project to use for testing I came across this [Walkthrough from Microsoft with Visual Studio C/C++](https://learn.microsoft.com/en-us/cpp/build/walkthrough-creating-and-using-a-dynamic-link-library-cpp?view=msvc-170).

It guides through both creating and using a dynamic link library with Visual Studio C/C++. First part is creating a DLL project which implements some simple functions for creating a set of Fibonacci numbers. Second part is then a client command line application which uses the DLL. The latter is important to make sure the DLL is working properly, hence no need to worry about DLL implementation issues when actually adding this to a Lazarus / Free Pascal project.

Both Visual Studio projects (library and client) are included in this repo in the visualstudio folder. I used Visual Studio Community edition 2022 (64 bit), version 17.3.6 on Windows 10 / 64 bit.

## Lazarus Project
At the time of this writing I used Lazarus version 2.3.0 and Free Pascal version 3.3.1 (installed 'trunk' with fpdupdeluxe) on Windows 10 / 64 bit. The project in the "lazarus" folder is a simple console application. Starting it from the command line will print a set of Fibonacci numbers on the console.

### Creating a Pascal Unit from the DLL's C Header File
A Free Pascal usally comes with a tool h2pas for automagic converting a C header file into a Pascal unit. In Lazarus you can also install the package h2paswizard and get a GUI for h2pas. However, it didn't work with the above DLL project and constantly showed some syntax error for the lines with the original C function declarations. One issue is "extern "C" " before the declaration:

`extern "C" MATHLIBRARY_API void fibonacci_init(const unsigned long long a, const unsigned long long b);`

According to the above common problems link this is a known issue and should be possible to fix with enabling Pre H2Pas tool in the before h2pas tab. However, this was already the default setting and it didn't fix the issue here. Maybe also the MATHLIBRARY_API macro was interfering here, because as soon as I removed both the extern "C" and the MATHLIBRARY_API, h2pas was able to create a Pascal .pas unit from the header file. However, h2pas still did not create proper code and Lazarus failed to compile the unit. It was not replacing the C bool type by Pascal boolean and tried to create some Pascal function from these macros:

```
#ifdef MATHLIBRARY_EXPORTS
#define MATHLIBRARY_API __declspec(dllexport)
#else
#define MATHLIBRARY_API __declspec(dllimport)
#endif
```

That did not make much sense and finally lead to compilation error because declspec is unknown.

### Manual Conversion
Manually converting the C header file into a Pascal unit is not too complicated (after reading the above documentation links plus some googling). Let's look at the first function in the C header file:
`extern "C" MATHLIBRARY_API void fibonacci_init(const unsigned long long a, const unsigned long long b);`

As said, we don't need the extern "C" and also not the MATHLIBRARY_API, so we delete this.
`void fibonacci_init(const unsigned long long a, const unsigned long long b);`

The function does not return anything (void), hence in Pascal it's a procedure and not a function.
`procedure fibonacci_init(const unsigned long long a, const unsigned long long b);`

An unsigned long long type would correspond to a QWord in Pascal.
`procedure fibonacci_init(a:QWord; b:QWord);`

Then we add [cdecl;](https://www.freepascal.org/docs-html/ref/refsu73.html) to let the compiler know it's a function that uses C type calling convention.
`procedure fibonacci_init(a:QWord; b:QWord); cdecl;`

Finally we add the name of the library where the function lives.
`procedure fibonacci_init(a:QWord; b:QWord); cdecl; external 'MathLibrary.dll';`

That would be the minimum steps to be done. Let's look at the second function in the C header file.
`extern "C" MATHLIBRARY_API bool fibonacci_next();`

This function returns a boolean, hence it's a Pascal function and not procedure. We do the similar steps than above but need to add the Pascal return type Boolean.
`function fibonacci_next(): Boolean; cdecl; external 'MathLibrary.dll';`

If you look into MathLibrary.pas in the Lazarus project there are some further additions, but those are mainly cosmetic and for convenience. I put the name of the library into a const plus a target system specific library extension (like .dll on Windows, .so on Linux , etc.) and use these constants in the function declarations then.

## That's it
I hope the above is useful and could be a starting point for others when creating Pascal bindings for C libraries. Feel free to contact me in case of questions.

## License
Copyright (C) 2022 Erik Lins

This project is released under the MIT License.
