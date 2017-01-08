Code analysis
=============

There are a number of methods of finding what source code is involved in a
build.

Static analysis:
 - cscope
   - Find all global definitions
   - Find all function calls
     http://stackoverflow.com/questions/23766566/how-can-i-display-all-function-name-from-cscope-database

Static analysis allows introspection of preprocessor features which aren't
observable in built binaries.

https://www.gnu.org/software/make/manual/html_node/Options-Summary.html

An alternative would be to dump preprocessor C compiler input file-by-file when
building.

Build time introspection:
  - make logs
    - Find all objects built into the final binary
      https://www.gnu.org/software/make/manual/html_node/Options-Summary.html
  - gcc logs
    - Further introspection on build process
    - Dumping preprocessor compiler input per translation unit

Binary introspection:
  - objdump (with debug symbols)
    - Find all source files used to build an object
      http://stackoverflow.com/questions/12186656/how-to-find-out-c-and-h-files-that-were-used-to-build-a-binary
    - Find all function references


C translation units
===================

A C translation unit is a C source file, preprocessed to insert #include files
inline. It is enough to build a binary. Any function calls referred to in the
included headers must be linked in the final binary to avoid linking
errors.

 - http://stackoverflow.com/a/1106167
 - https://gcc.gnu.org/onlinedocs/gcc-3.0.2/cpp_2.html

Kernel linking order
====================


Goals
=====

 - Make sure nothing from the wrong PDK is built for each build
 - Make sure nothing global is redefined in a PDK vs. core
 - Summary of built files for each build
 - Summary of symbols and associated source files in final kenel binary
 - Check for duplicate objects and linking order issues
 - Find common function calls/definitions which might cross over

Get all the data you can, and see what you can do with it.
