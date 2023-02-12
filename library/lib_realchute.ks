// lib_realchute.ks - adds support for RealChute 
// Copyright © 2015,2023 KSLib team 
// Lic. MIT

@LAZYGLOBAL OFF.
@CLOBBERBUILTINS OFF.

declare function R_chutes {
 parameter event.
 for RealChute in ship:modulesNamed("RealChuteModule") {
  RealChute:doevent(event).
 }.
}.
