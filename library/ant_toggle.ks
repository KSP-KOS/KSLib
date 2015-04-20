SET antennae TO SHIP:MODULESNAMED("ModuleRTAntenna").

FOR currentAnt IN antennae {
	currentAnt:VALUE:DOACTION("toggle",TRUE).
}.

wait 5.

currentAnt:RESET.
UNTIL NOT (currentAnt:NEXT) {
	currentAnt:VALUE:DOACTION("toggle",TRUE).
}.