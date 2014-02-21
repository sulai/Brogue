SRC=..\..\src
BIN=..\..\bin\windows
RES=..\..\res
LIBTCODDIR=$(SRC)\libtcod-1.5.2
SDLDIR=$(SRC)\SDL-1.2.14
CFLAGS=$(FLAGS) -I$(LIBTCODDIR)/include -I$(SDLDIR)/include -I$(SRC)/brogue -I$(SRC)/platform -DBROGUE_TCOD -Wall

%.o : %.c
	mingw32-gcc $(CFLAGS) -O2 -s -o $@ -c $< 

OBJS=$(SRC)/brogue/Architect.o \
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
	$(SRC)/platform/tcod-platform.o 

all : brogue resources dll

dll :
	copy "$(SDLDIR)\bin\SDL.dll" "$(BIN)\"
#	copy "$(LIBTCODDIR)\libtcod-mingw.dll" "$(BIN)\"

resources :
	xcopy "$(RES)\*" "$(BIN)\" /E /Y

brogue-icon.o : brogue-icon.ico icon.rc
	windres icon.rc brogue-icon.o

brogue : ${OBJS} brogue-icon.o 
	g++ -o $(BIN)/brogue.exe ${OBJS} brogue-icon.o -L. -ltcod-mingw -lSDL -L$(LIBTCODDIR)/ -static-libgcc -static-libstdc++ -mwindows
