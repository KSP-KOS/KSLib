@LAZYGLOBAL off.

Global LocationConstants is lex(
  // vertical landing locations
  "launchpad", Kerbin:GeoPositionLatLng(-0.0972, -74.5577),
  "woomerang_launchpad", Kerbin:GeoPositionLatLng(45.2896, 136.1100),
  "desert_launchpad", Kerbin:GeoPositionLatLng(-6.5604, -143.9500),
  "VAB", Kerbin:GeoPositionLatLng(-0.097, -74.619),

  // horizontal landing locations
  "runway_start", Kerbin:GeoPositionLatLng(-0.0487, -74.7247),
  "runway_end", Kerbin:GeoPositionLatLng(-0.0501, -74.4880),  // runway "lip"
  "runway_start_heading_west", Kerbin:GeoPositionLatLng(-0.0501, -74.4925),
  "runway_end_heading_west", Kerbin:GeoPositionLatLng(-0.0487, -74.7292),  // runway "lip"
  "runway_l1_start", Kerbin:GeoPositionLatLng(-.0489, -74.7101),
  "runway_l1_start_heading_west", Kerbin:GeoPositionLatLng(-.0503, -74.5076),
  "runway_l2_start", Kerbin:GeoPositionLatLng(-.0486, -74.7134),
  "runway_l2_start_heading_west", Kerbin:GeoPositionLatLng(-.0501, -74.5046),
  "island_runway_start_heading_east", Kerbin:GeoPositionLatLng(-1.5177, -71.9663),
  "island_runway_start_heading_west", Kerbin:GeoPositionLatLng(-1.5158, -71.8524),
  "desert_runway_start", Kerbin:GeoPositionLatLng(-6.5998, -144.0407),
  "desert_runway_start_heading_south", Kerbin:GeoPositionLatLng(-6.4480, -144.0383)
).

// aliases
Set LocationConstants["runway_start_heading_east"] to LocationConstants["runway_start"].
Set LocationConstants["runway_end_heading_east"] to LocationConstants["runway_end"].
Set LocationConstants["runway_l1_start_heading_east"] to LocationConstants["runway_l1_start"].
Set LocationConstants["runway_l2_start_heading_east"] to LocationConstants["runway_l2_start"].

Set LocationConstants["dessert_runway_start"] to LocationConstants["desert_runway_start"].
Set LocationConstants["dessert_runway_start_heading_south"] to LocationConstants["desert_runway_start_heading_south"].
Set LocationConstants["desert_runway_start_heading_north"] to LocationConstants["desert_runway_start"].
Set LocationConstants["dessert_runway_start_heading_north"] to LocationConstants["dessert_runway_start"].
Set LocationConstants["dessert_launchpad"] to LocationConstants["desert_launchpad"].
