MXMLC = ../utils/fcsh-wrap

FLIXEL = ../flixel/stable
JSON   = ../json

SRC = $(wildcard *.as)  $(wildcard *.txt)

MAIN =  EZPlatformer.as

SWF = Game.swf

$(SWF) : $(SRC)
	$(MXMLC) -debug=true  -static-link-runtime-shared-libraries -sp $(FLIXEL) -sp ${JSON} -o $(SWF) -- $(MAIN)

.PHONY:
clean:
	rm -rf ${SWF} .FW*

run: ${SWF}
	iceweasel -new-window ${SWF}
rrun: ${SWF}
	flashplayer ${SWF}
gdb: ${SWF}
	fdb ${SWF}
