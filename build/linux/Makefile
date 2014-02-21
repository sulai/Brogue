
SDL_FLAGS = `sdl-config --cflags` `sdl-config --libs`
BIN=../../bin/linux
SRC=../../src
RES=../../res
LIBTCODDIR=$(SRC)/libtcod-1.5.2
CFLAGS=-I$(SRC)/brogue -I$(SRC)/platform -Wall -Wno-parentheses ${DEFINES}
RELEASENAME=brogue-1.7.3
LASTTARGET := $(shell ./brogue --target)
CC ?= gcc

ifeq (${LASTTARGET},both)
all : both
else ifeq (${LASTTARGET},curses)
all : curses
else ifeq (${LASTTARGET},tcod)
all : tcod
else
all : both
endif

%.o : %.c Makefile $(SRC)/brogue/Rogue.h $(SRC)/brogue/IncludeGlobals.h
	$(CC) $(CFLAGS) -g -o $@ -c $< 

BROGUEFILES=$(SRC)/brogue/Architect.o \
	$(SRC)/brogue/Combat.o \
	$(SRC)/brogue/Dijkstra.o \
	$(SRC)/brogue/Globals.o \
	$(SRC)/brogue/IO.o \
	$(SRC)/brogue/Items.o \
	$(SRC)/brogue/Light.o \
	$(SRC)/brogue/Monsters.o \
	$(SRC)/brogue/Buttons.o \
	$(SRC)/brogue/Movement.o \
	$(SRC)/brogue/Recordings.o \
	$(SRC)/brogue/RogueMain.o \
	$(SRC)/brogue/Random.o \
	$(SRC)/brogue/MainMenu.o \
	$(SRC)/brogue/Grid.o \
	$(SRC)/brogue/Time.o \
	$(SRC)/platform/main.o \
	$(SRC)/platform/platformdependent.o \
	$(SRC)/platform/curses-platform.o \
	$(SRC)/platform/tcod-platform.o \
	$(SRC)/platform/term.o

TCOD_DEF = -DBROGUE_TCOD -I$(LIBTCODDIR)/include
TCOD_DEP = ${LIBTCODDIR}
TCOD_LIB = -L. -L${LIBTCODDIR} ${SDL_FLAGS} -ltcod -Wl,-rpath,.

CURSES_DEF = -DBROGUE_CURSES
CURSES_LIB = -lncurses -lm


tcod : DEPENDENCIES += ${TCOD_DEP}
tcod : DEFINES += ${TCOD_DEF}
tcod : LIBRARIES += ${TCOD_LIB}
tcod : resources

curses : DEFINES = ${CURSES_DEF}
curses : LIBRARIES = ${CURSES_LIB}

both : DEPENDENCIES += ${TCOD_DEP}
both : DEFINES += ${TCOD_DEF} ${CURSES_DEF}
both : LIBRARIES += ${TCOD_LIB} ${CURSES_LIB}
both : resources

ifeq (${LASTTARGET},both)
both : $(BIN)/brogue
tcod : clean $(BIN)/brogue
curses : clean $(BIN)/brogue
else ifeq (${LASTTARGET},curses)
curses : $(BIN)/brogue
tcod : clean $(BIN)/brogue
both : clean $(BIN)/brogue
else ifeq (${LASTTARGET},tcod)
tcod : $(BIN)/brogue
curses : clean $(BIN)/brogue
both : clean $(BIN)/brogue
else
both : $(BIN)/brogue
curses : $(BIN)/brogue
tcod : $(BIN)/brogue
endif

.PHONY : clean both curses tcod tar

$(BIN)/brogue : ${DEPENDENCIES} ${BROGUEFILES}
	$(CC) -O2 -march=i586 -o $(BIN)/brogue ${BROGUEFILES} ${LIBRARIES} -Wl,-rpath,.

clean : 
	rm -f $(SRC)/brogue/*.o $(SRC)/platform/*.o $(BIN)/brogue
	rm -R $(BIN)/fonts

${LIBTCODDIR} :
	get-libtcod.sh

resources :
	cp -R $(RES)/* $(BIN)/

tar : both
	rm -f ../../${RELEASENAME}.tar.gz
	tar --transform 's,^bin/linux/,${RELEASENAME}/,' -czf ../../${RELEASENAME}.tar.gz \
	$(BIN)/* \
	--exclude='BrogueHighScores.txt' \
	--exclude='*.broguerec' \
	--exclude='*.broguesave'

