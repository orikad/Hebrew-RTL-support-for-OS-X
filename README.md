##Hebrew support for Messages app (OS X)

Simple little hook that checks in the OS X Messages app if your input contains a Hebrew character then it right aligns the text.


###Compiling:
This depends on the logos preprocessor (that comes bundled with theos), and assumes it is installed in /opt/theos, otherwise change the Makefile (theos: http://iphonedevwiki.net/index.php/Theos).
This also assumes that there is a directory 'logos' in the current directory that links to /opt/theos/include/logos (since logos preprocessor includes that empty header file).
Those assumptions satisfied, just type:
make

###Using:
You need to insert the compiled library into Messages, I use DYLD_INSERT_LIBRARIES for that, you can google for more info.
However Apple's signed apps by default ignore DYLD_INSERT_LIBRARIES so you might need to strip its signature. I've used Hopper Disassembler to do that.
Assuming your messages app is signature stripped, just type:
DYLD_INSERT_LIBRARIES=./hebrewmsgs.dylib /Applications/Messages.app/Contents/MacOS/Messages

(you can replace the Messages executable with a bash script that does that so it is transparent to you)

