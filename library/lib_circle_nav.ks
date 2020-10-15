// lib_circle_nav.ks provides a set of functions that use Great Circle equations.
// Copyright © 2015,2019 KSLib team 
// Lic. MIT
@LAZYGLOBAL OFF.

//use to find the initial bearing for the shortest path around a sphere from...
function circle_bearing {
 parameter
  p1, //...this point...
  p2. //...to this point.

 return mod(360+arctan2(sin(p2:lng-p1:lng)*cos(p2:lat),cos(p1:lat)*sin(p2:lat)-sin(p1:lat)*cos(p2:lat)*cos(p2:lng-p1:lng)),360).
}.

//use to find where you will end up if you travel from...
function circle_destination {
 parameter
  p1,     //...this point...
  b,      // ...with this as your initial bearing...
  d,      // ...for this distance...
  radius. // ...around a sphere of this radius.

 local lat is arcsin(sin(p1:lat)*cos((d*180)/(radius*constant():pi))+cos(p1:lat)*sin((d*180)/(radius*constant():pi))*cos(b)).
 local lng is 0.
 if abs(Lat) <> 90 {
  set lng to p1:lng+arctan2(sin(b)*sin((d*180)/(radius*constant():pi))*cos(p1:lat),cos((d*180)/(radius*constant():pi))-sin(p1:lat)*sin(lat)).
 }.
 
 return latlng(lat,lng).
}.

//use to find the distance from...
function circle_distance {
 parameter
  p1,     //...this point...
  p2,     //...to this point...
  radius. //...around a body of this radius. (note: if you are flying you may want to use ship:body:radius + altitude).
 local A is sin((p1:lat-p2:lat)/2)^2 + cos(p1:lat)*cos(p2:lat)*sin((p1:lng-p2:lng)/2)^2.
 
 return radius*constant():PI*arctan2(sqrt(A),sqrt(1-A))/90.
}.

//use to find the mid point on the outside of a sphere between...
function circle_midpoint {
 parameter
  p1, //...this point...
  p2. //...and this point.
 local A is cos(p2:lat)*cos(p2:lng-p1:lng).
 local B is cos(p2:lat)*sin(p2:lng-P1:lng).
 
 return latlng(arctan2(sin(p1:lat)+sin(p2:lat),sqrt((cos(p1:lat)+resultA)^2+resultB^2)),p1:lng+arctan2(resultB,cos(p1:lat)+resultA)).
}.
