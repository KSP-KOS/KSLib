// lib_realchute.ks - adds support for RealChute 
// Copyright © 2015 KSLib team 
// Lic. MIT

@LAZYGLOBAL OFF.
declare function R_chutes {
 parameter event.
 for RealChute in ship:modulesNamed("RealChuteModule") {
  RealChute:doevent(event).
 }.
}.
