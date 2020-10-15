// lib_geodec.ks provides two functions to convert between geographic coordinates (latitude, longitude) and cartesian coordinates (x, y, z).
// Copyright © 2015,2019 KSLib team 
// Lic. MIT
@LAZYGLOBAL off.

function geo2dec {
	parameter
		_____vlat, //geoposition:lat
		_____vlng, //geoposition:lng
		_____valt. //altitude
	local _____talt is body:radius+_____valt.
	local _____tlat is _____vlat+90.
	local _____tsin is sin(_____tlat).
	local _____vdec is list(
		_____talt*_____tsin*cos(_____vlng),
		_____talt*_____tsin*sin(_____vlng),
		_____talt*cos(_____tlat)
	).
	return _____vdec.
}.

function dec2geo {
	parameter
		_____vx, //x from geo2dec array[0]
		_____vy, //y from geo2dec array[1]
		_____vz. //z from geo2dec array[2]
	local _____tsqrt is sqrt(_____vx*_____vx+_____vy*_____vy+_____vz*_____vz).
	local _____vgeo is list(
		arccos(_____vz/_____tsqrt)-90,
		arctan2(_____vy,_____vx),
		_____tsqrt-body:radius
	).
	return _____vgeo.
}.
