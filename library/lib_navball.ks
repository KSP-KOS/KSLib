// A library of functions to calculate navball-based directions:

// This file is distributed under the terms of the MIT license, (c) the KSLib team

@lazyglobal off.

function east_for {
  parameter ves.

  return vcrs(ves:up:vector, ves:north:vector).
}

function compass_for {
  parameter ves,thing is "default".

  local pointing is ves:facing:forevector.
  if not thing:istype("string") {
    set pointing to type_to_vector(thing,ves).
  }

  local east is east_for(ves).

  local trig_x is vdot(ves:north:vector, pointing).
  local trig_y is vdot(east, pointing).

  local result is arctan2(trig_y, trig_x).

  if result < 0 {
    return 360 + result.
  } else {
    return result.
  }
}

function pitch_for {
  parameter ves,thing is "default".

  local pointing is ves:facing:forevector.
  if not thing:istype("string") {
    set pointing to type_to_vector(thing,ves).
  }

  return 90 - vang(ves:up:vector, pointing).
}

function roll_for {
  parameter ves,thing is "default".

  local pointing is ves:facing.
  if not thing:istype("string") {
    if thing:istype("vessel") or pointing:istype("part") {
      set pointing to thing:facing.
    } else {
      set pointing to thing.
    }
  }

  if vang(pointing:vector,ves:up:vector) < 0.2 { //this is the dead zone for roll when the vessel is vertical
    return 0.
  } else {
    local raw is vang(vxcl(pointing:vector,ves:up:vector), pointing:starvector).
    if vang(ves:up:vector, pointing:topvector) > 90 {
      if raw > 90 {
        return 270 - raw.
      } else {
        return -90 - raw.
      }
    } else {
      return raw - 90.
    }
  }
}

function type_to_vector {
  parameter thing,ves.
  if thing:istype("vector") {
    return thing:normalized.
  } else if thing:istype("direction") {
    return pointing:forevector.
  } else if thing:istype("vessel") or pointing:istype("part") {
    return pointing:facing:forevector.
  } else if pointing:istype("geoposition") {
    return thing:position - ves:position.
  } else {
    return thing.
  }
}
