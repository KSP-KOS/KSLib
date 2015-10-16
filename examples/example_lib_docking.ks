@LAZYGLOBAL OFF.
clearscreen.

declare local dockingTarget to 0.
run lib_docking.
sas off.

message("Start docking").

set dockingTarget to findParts().
dockToPort(dockingTarget).


//drawTargetTranslation(dockTarget).

message("End docking").

sas on.
