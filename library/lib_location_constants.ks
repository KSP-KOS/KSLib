@LAZYGLOBAL off.

global LocationConstants is lex(
  // vertical landing locations
  "launchpad", Kerbin:GeoPositionLatLng(-0.0972, -74.5577),
  "woomerang_launchpad", Kerbin:GeoPositionLatLng(45.2896, 136.1100),
  "desert_launchpad", Kerbin:GeoPositionLatLng(-6.5604, -143.9500),
  "VAB", Kerbin:GeoPositionLatLng(-0.097, -74.619),

  // horizontal landing locations
  "runway_09_start", Kerbin:GeoPositionLatLng(-0.0487, -74.7247),
  "runway_09_end", Kerbin:GeoPositionLatLng(-0.0501, -74.4880),  // runway "lip"
  "runway_27_start", Kerbin:GeoPositionLatLng(-0.0501, -74.4925),
  "runway_27_end", Kerbin:GeoPositionLatLng(-0.0487, -74.7292),  // runway "lip"
  "l1_runway_09_start", Kerbin:GeoPositionLatLng(-.0489, -74.7101),
  "l1_runway_27_start", Kerbin:GeoPositionLatLng(-.0503, -74.5076),
  "l2_runway_09_start", Kerbin:GeoPositionLatLng(-.0486, -74.7134),
  "l2_runway_27_start", Kerbin:GeoPositionLatLng(-.0501, -74.5046),
  "island_runway_09_start", Kerbin:GeoPositionLatLng(-1.5177, -71.9663),
  "island_runway_27_start", Kerbin:GeoPositionLatLng(-1.5158, -71.8524),
  "desert_runway_36_start", Kerbin:GeoPositionLatLng(-6.5998, -144.0407),
  "desert_runway_18_start", Kerbin:GeoPositionLatLng(-6.4480, -144.0383)
).

// aliases
set LocationConstants["runway_start"] to LocationConstants["runway_09_start"].
set LocationConstants["reverse_runway_start"] to LocationConstants["runway_27_start"].

for key in LocationConstants:keys {
  if key:contains("desert") {
    local alias to key:replace("desert", "dessert").
    set LocationConstants[alias] to LocationConstants[key].
  }.
}.
