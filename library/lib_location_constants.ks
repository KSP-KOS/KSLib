// lib_location_constants.ks provides geolocations for places that would be relatively easy to locate for players flying manually (i.e., without the use of scripting mods such as kOS).
// Copyright © 2020 KSLib team 
// Lic. MIT
@LAZYGLOBAL off.

if not (defined location_constants) {
global location_constants is lex().
//runways should be added in this pattern "name_runway_##_start" where name is the name of the runway and ## is the runway number
//  If not added with this pattern then the automatic alias creation that add an end position based on the start of the same name but opposite number will fail

if bodyexists("Sun") and body("Sun"):radius = 261_600_000 and bodyexists("Kerbin") {//check for if the craft is in the stock solar system
  local kerbinLocations is lex().
  // vertical landing locations
  kerbinLocations:add("launchpad", Kerbin:GeoPositionLatLng(-0.0972, -74.5577)).
  kerbinLocations:add("woomerang_launchpad", Kerbin:GeoPositionLatLng(45.2896, 136.1100)).
  kerbinLocations:add("desert_launchpad", Kerbin:GeoPositionLatLng(-6.5604, -143.9500)).
  kerbinLocations:add("VAB", Kerbin:GeoPositionLatLng(-0.0968, -74.6187)).
  location_constants:add("launchpad",kerbinLocations["launchpad"]).

  // horizontal landing locations
  kerbinLocations:add("runway_09_start", Kerbin:GeoPositionLatLng(-0.0486, -74.7247)).
  kerbinLocations:add("runway_09_overrun", Kerbin:GeoPositionLatLng(-0.0502, -74.4880)).  // runway "lip"
  kerbinLocations:add("runway_27_start", Kerbin:GeoPositionLatLng(-0.0502, -74.4925)).
  kerbinLocations:add("runway_27_overrun", Kerbin:GeoPositionLatLng(-0.0486, -74.7292)).  // runway "lip"
  kerbinLocations:add("l1_runway_09_start", Kerbin:GeoPositionLatLng(-.0489, -74.7101)).
  kerbinLocations:add("l1_runway_27_start", Kerbin:GeoPositionLatLng(-.0501, -74.5076)).
  kerbinLocations:add("l2_runway_09_start", Kerbin:GeoPositionLatLng(-.0486, -74.7134)).
  kerbinLocations:add("l2_runway_27_start", Kerbin:GeoPositionLatLng(-.0501, -74.5046)).
  kerbinLocations:add("island_runway_09_start", Kerbin:GeoPositionLatLng(-1.5177, -71.9663)).
  kerbinLocations:add("island_runway_27_start", Kerbin:GeoPositionLatLng(-1.5158, -71.8524)).
  kerbinLocations:add("desert_runway_36_start", Kerbin:GeoPositionLatLng(-6.5998, -144.0409)).
  kerbinLocations:add("desert_runway_18_start", Kerbin:GeoPositionLatLng(-6.4480, -144.0383)).

  location_constants:add("runway_start",kerbinLocations["runway_09_start"]).
  location_constants:add("reverse_runway_start",kerbinLocations["runway_27_start"]).

  location_constants:add("kerbin",kerbinLocations).
}

// JNSQ locations
if bodyexists("Sun") and body("Sun"):radius = 175_750_000 and bodyexists("Kerbin") {
  local kerbinLocations is lex().
  // vertical landing locations
  kerbinLocations:add("launchpad", Kerbin:GeoPositionLatLng(-1.75133971218638E-08,-91.7839867917987)).
  kerbinLocations:add("woomerang_launchpad", Kerbin:GeoPositionLatLng(45.2898572995131,136.109991969089)).
  kerbinLocations:add("desert_launchpad", Kerbin:GeoPositionLatLng(-6.56014471162071,-143.949999962632)).
  kerbinLocations:add("VAB", Kerbin:GeoPositionLatLng(-3.59779685817755E-05,-91.8082182694506)).
  location_constants:add("launchpad",kerbinLocations["launchpad"]).

  // horizontal landing locations
  kerbinLocations:add("runway_09_start", Kerbin:GeoPositionLatLng(0.0177914364838286,-91.8485588846624)).
  kerbinLocations:add("runway_09_overrun", Kerbin:GeoPositionLatLng(0.017771315430981,-91.7560165023844)).  // runway "lip"
  kerbinLocations:add("runway_27_start", Kerbin:GeoPositionLatLng(0.0177872750049561,-91.758043638339)).
  kerbinLocations:add("runway_27_overrun", Kerbin:GeoPositionLatLng(0.0177981075373338,-91.8503058587583)).  // runway "lip"
  kerbinLocations:add("l1_runway_09_start", Kerbin:GeoPositionLatLng(0.0177201817416171,-91.8418633582038)).
  kerbinLocations:add("l1_runway_27_start", Kerbin:GeoPositionLatLng(0.0177610480469539,-91.7644480917721)).
  kerbinLocations:add("l2_runway_09_start", Kerbin:GeoPositionLatLng(0.0178308568526199,-91.8434577819091)).
  kerbinLocations:add("l2_runway_27_start", Kerbin:GeoPositionLatLng(0.0178110871731228,-91.7632143441808)).
  kerbinLocations:add("island_runway_09_start", Kerbin:GeoPositionLatLng(-1.5323269901046,-71.9321971014811)).
  kerbinLocations:add("island_runway_27_start", Kerbin:GeoPositionLatLng(-1.53151635515729,-71.8874890013379)).
  kerbinLocations:add("desert_runway_36_start", Kerbin:GeoPositionLatLng(-6.55057590520998,-144.040382288094)).
  kerbinLocations:add("desert_runway_18_start", Kerbin:GeoPositionLatLng(-6.49233191848109,-144.039374890239)).

  location_constants:add("runway_start",kerbinLocations["runway_09_start"]).
  location_constants:add("reverse_runway_start",kerbinLocations["runway_27_start"]).

  location_constants:add("kerbin",kerbinLocations).
}

// RealSolarSystem locations
if bodyexists("Sun") and body("Sun"):radius = 696_342_000 and bodyexists("Earth") {
  // local earthLocations is lex().
  // TODO: populate at least the most commonly used of the RealSolarSystem locations.
}

// aliases
until not aliasing(location_constants) {}.

local function aliasing {
  parameter locationConstants.
  local didChange is false.
  for key in locationConstants:keys {
    local bodyLex is locationConstants[key].
    if bodyLex:istype("lexicon") {
      local bodyKeys is bodyLex:keys:copy.
      for currentKey in bodyKeys {
        if currentKey:contains("desert") {//desert to dessert aliasing
          local alias to currentKey:replace("desert", "dessert").
          if not bodyLex:haskey(alias) {
            bodyLex:add(alias,bodyLex[currentKey]).
            set didChange to true.
          }
        }

        if currentKey:matchespattern("runway_\d{1,2}_start$") {//runway_##_end aliasing
          local alias is currentKey:replace("start", "end").
          // now find the key that `alias` is an alias of
          if not bodyLex:haskey(alias) {
            local splitKey is currentKey:split("_").
            local currentNum is splitKey[splitKey:length - 2].
            local reverseNum is MOD(currentNum:toscalar(0) + 18,36):tostring.
            if reverseNum = "0" { set reverseNum to "36". }
            local reverseStr is currentKey:replace(currentNum,reverseNum).
            if not bodyLex:haskey(reverseStr) {
              set reverseStr to currentKey:replace(currentNum,"0" + reverseNum).
            }
            if bodyLex:haskey(reverseStr) {
              bodyLex:add(alias,bodyLex[reverseStr]).
              set didChange to true.
            }
          }
        }
      }
    }
  }
  return didChange.
}
}
