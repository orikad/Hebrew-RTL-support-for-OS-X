CC=clang++
TARGET=hebrewmsgs.dylib
CFLAGS=-I. -framework AppKit -o ${TARGET} -ObjC -dynamiclib
SRC=lo_hebmsgs.mm
PRE_SRC=hebmsgs.xm
THEOS=/opt/theos/

all : ${PRE_SRC} 
	${THEOS}bin/logos.pl ${PRE_SRC} > ${SRC}
	${CC} ${CFLAGS} ${SRC}

clean : ${TARGET}
	rm -f ${TARGET}
