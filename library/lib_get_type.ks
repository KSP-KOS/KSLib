// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

local complexTypes is list("LEXICON","QUEUE","STACK","LIST","SHIP","VECTOR","DIRECTION","GEOCOORDINATES","ORBIT","ORBITABLE","ORBITALVELOCITY","BODY","ATMOSPHERE","CONTROL","MANEUVERNODE","ENGINE","AGGREGATERESOURCE","DOCKINGPORT","STAGE","PART","PARTMODULE","SENSOR","VESSELSENSORS","LOADDISTANCE","CONFIG","FILEINFO","HIGHLIGHT","ITERATOR","KUNIVERSE","TERMINAL","CORE","PIDLOOP","STEERINGMANAGER").

function get_type {
  parameter input.

  // Putting the input in a lexicon lets us get a description of its type,
  // unless it's a string or number.
  local l is lexicon().
  set l[0] to input.
  local complexType is l:dump:split(" ")[6]:split("(")[0]. ")".

  if complexTypes:contains(complexType) return complexType.

  // Determine string or num: 5+0+""="5"; "5"+0+"" = "50"
  if (input+""):LENGTH = (input+0+""):LENGTH return "NUMBER".
  return "STRING".
}
