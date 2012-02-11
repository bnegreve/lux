MXMLC = ../utils/fcsh-wrap
FLIXEL = ../flixel/stable

SRC = PlayState.as 
MAIN = HelloWorld.as
SWF = Game.swf

$(SWF) : $(SRC)
	$(MXMLC)  -static-link-runtime-shared-libraries -sp $(FLIXEL) -o $(SWF) -- $(MAIN)

.PHONY:
clean:
	rm -rf ${SWF} .FW*

run:
	iceweasel ${SWF}
