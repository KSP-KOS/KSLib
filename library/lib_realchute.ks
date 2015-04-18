// This file is distributed under the terms of the MIT license, (c) the KSLib team

// adds support for RealChute 
@LAZYGLOBAL OFF.
declare function R_chutes {
 for RealChute in ship:modulesNamed("RealChuteModule") {
  RealChute:doevent("Deploy chute").
 }.
}.
