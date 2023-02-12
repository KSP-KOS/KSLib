// lib_navigation.ks provides a plethora of useful functions to aid in writing navigational scripts, whether it's space navigation or surface navigation.
// Copyright © 2019,2020,2023 KSLib team 
// Lic. MIT
@LAZYGLOBAL OFF.
@CLOBBERBUILTINS OFF.

// Same as orbital prograde vector for ves
function orbitTangent {
    parameter ves is ship.

    return ves:velocity:orbit:normalized.
}

// In the direction of orbital angular momentum of ves
// Typically same as Normal
function orbitBinormal {
    parameter ves is ship.

    return vcrs((ves:position - ves:body:position):normalized, orbitTangent(ves)):normalized.
}

// Perpendicular to both tangent and binormal
// Typically same as Radial In
function orbitNormal {
    parameter ves is ship.

    return vcrs(orbitBinormal(ves), orbitTangent(ves)):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function orbitLAN {
    parameter ves is ship.

    return angleAxis(ves:orbit:LAN, ves:body:angularVel:normalized) * solarPrimeVector.
}

// Same as surface prograde vector for ves
function surfaceTangent {
    parameter ves is ship.

    return ves:velocity:surface:normalized.
}

// In the direction of surface angular momentum of ves
// Typically same as Normal
function surfaceBinormal {
    parameter ves is ship.

    return vcrs((ves:position - ves:body:position):normalized, surfaceTangent(ves)):normalized.
}

// Perpendicular to  both tangent and binormal
// Typically same as Radial In
function surfaceNormal {
    parameter ves is ship.

    return vcrs(surfaceBinormal(ves), surfaceTangent(ves)):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function surfaceLAN {
    parameter ves is ship.

    return angleAxis(ves:orbit:LAN - 90, ves:body:angularVel:normalized) * solarPrimeVector.
}

// Vector directly away from the body at ves' position
function localVertical {
    parameter ves is ship.

    return ves:up:vector.
}

// Angle to ascending node with respect to ves' body's equator
function angleToBodyAscendingNode {
    parameter ves is ship.

    local joinVector is orbitLAN(ves).
    local angle is vang((ves:position - ves:body:position):normalized, joinVector).
    if ves:status = "LANDED" {
        set angle to angle - 90.
    }
    else {
        local signVector is vcrs(-body:position, joinVector).
        local sign is vdot(orbitBinormal(ves), signVector).
        if sign < 0 {
            set angle to angle * -1.
        }
    }
    return angle.
}

// Angle to descending node with respect to ves' body's equator
function angleToBodyDescendingNode {
    parameter ves is ship.

    local joinVector is -orbitLAN(ves).
    local angle is vang((ves:position - ves:body:position):normalized, joinVector).
    if ves:status = "LANDED" {
        set angle to angle - 90.
    }
    else {
        local signVector is vcrs(-body:position, joinVector).
        local sign is vdot(orbitBinormal(ves), signVector).
        if sign < 0 {
            set angle to angle * -1.
        }
    }
    return angle.
}

// Vector directed from the relative descending node to the ascending node
function relativeNodalVector {
    parameter orbitBinormal.
    parameter targetBinormal.

    return vcrs(orbitBinormal, targetBinormal):normalized.
}

// Angle to relative ascending node determined from args
function angleToRelativeAscendingNode {
    parameter orbitBinormal.
    parameter targetBinormal.

    local joinVector is relativeNodalVector(orbitBinormal, targetBinormal).
    local angle is vang(-body:position:normalized, joinVector).
    local signVector is vcrs(-body:position, joinVector).
    local sign is vdot(orbitBinormal, signVector).
    if sign < 0 {
        set angle to angle * -1.
    }
    return angle.
}

// Angle to relative descending node determined from args
function angleToRelativeDescendingNode {
    parameter orbitBinormal.
    parameter targetBinormal.

    local joinVector is -relativeNodalVector(orbitBinormal, targetBinormal).
    local angle is vang(-body:position:normalized, joinVector).
    local signVector is vcrs(-body:position, joinVector).
    local sign is vdot(orbitBinormal, signVector).
    if sign < 0 {
        set angle to angle * -1.
    }
    return angle.
}

// Orbital phase angle with assumed target
// Positive when you are behind the target, negative when ahead
function phaseAngle {
    local common_ancestor is 0.
    local my_ancestors is list().
    local your_ancestors is list().

    my_ancestors:add(ship:body).
    until not(my_ancestors[my_ancestors:length-1]:hasBody) {
        my_ancestors:add(my_ancestors[my_ancestors:length-1]:body).
    }
    your_ancestors:add(target:body).
    until not(your_ancestors[your_ancestors:length-1]:hasBody) {
        your_ancestors:add(your_ancestors[your_ancestors:length-1]:body).
    }

    for my_ancestor in my_ancestors {
        local found is false.
        for your_ancestor in your_ancestors {
            if my_ancestor = your_ancestor {
                set common_ancestor to my_ancestor.
                set found to true.
                break.
            }
        }
        if found {
            break.
        }
    }

    local vel is ship:velocity:orbit.
    local my_ancestor is my_ancestors[0].
    until my_ancestor = common_ancestor {
        set vel to vel + my_ancestor:orbit:velocity:orbit.
        set my_ancestor to my_ancestor:body.
    }
    local binormal is vcrs(-common_ancestor:position:normalized, vel:normalized):normalized.

    local phase is vang(
        -common_ancestor:position:normalized,
        vxcl(binormal, target:position - common_ancestor:position):normalized
    ).
    local signVector is vcrs(
        -common_ancestor:position:normalized,
        (target:position - common_ancestor:position):normalized
    ).
    local sign is vdot(binormal, signVector).
    if sign < 0 {
        return -phase.
    }
    else {
        return phase.
    }
}

// Average Isp calculation
function _avg_isp {
    local burnEngines is list().
    list engines in burnEngines.
    local massBurnRate is 0.
    for e in burnEngines {
        if e:ignition {
            set massBurnRate to massBurnRate + e:availableThrust/(e:ISP * constant:g0).
        }
    }
    local isp is -1.
    if massBurnRate <> 0 {
        set isp to ship:availablethrust / massBurnRate.
    }
    return isp.
}

// Burn time from rocket equation
function getBurnTime {
    parameter deltaV.
    parameter isp is 0.
    
    if deltaV:typename() = "Vector" {
        set deltaV to deltaV:mag.
    }
    if isp = 0 {
        set isp to _avg_isp().
    }
    
    local burnTime is -1.
    if ship:availablethrust <> 0 {
        set burnTime to ship:mass * (1 - CONSTANT:E ^ (-deltaV / isp)) / (ship:availablethrust / isp).
    }
    return burnTime.
}

// Instantaneous azimuth
function azimuth {
    parameter inclination.
    parameter orbit_alt.
    parameter auto_switch is false.

    local shipLat is ship:latitude.
    if abs(inclination) < abs(shipLat) {
        set inclination to shipLat.
    }

    local head is arcsin(cos(inclination) / cos(shipLat)).
    if auto_switch {
        if angleToBodyDescendingNode(ship) < angleToBodyAscendingNode(ship) {
            set head to 180 - head.
        }
    }
    else if inclination < 0 {
        set head to 180 - head.
    }
    local vOrbit is sqrt(body:mu / (orbit_alt + body:radius)).
    local vRotX is vOrbit * sin(head) - vdot(ship:velocity:orbit, heading(90, 0):vector).
    local vRotY is vOrbit * cos(head) - vdot(ship:velocity:orbit, heading(0, 0):vector).
    set head to 90 - arctan2(vRotY, vRotX).
    return mod(head + 360, 360).
}
