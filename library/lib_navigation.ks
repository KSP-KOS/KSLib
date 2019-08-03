// This file is distributed under the terms of the MIT license, (c) the KSLib team
@LAZYGLOBAL OFF.

// Same as orbital prograde vector for ves
function orbitTangent {
    parameter ves is ship.

    return ves:velocity:orbit:normalized.
}

// In the direction of orbital angular momentum of ves
function orbitBinormal {
    parameter ves is ship.

    return vcrs(ves:position - ves:body:position, orbitTangent(ves)):normalized.
}

// Perpendicular to both tangent and binormal, typically radially inward
function orbitNormal {
    parameter ves is ship.

    return vcrs(orbitBinormal(ves), orbitTangent(ves)):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function orbitLAN {
    parameter ves is ship.

    return angleAxis(ves:orbit:LAN, ves:body:angularVel) * solarPrimeVector.
}

// Same as surface prograde vector for ves
function surfaceTangent {
    parameter ves is ship.

    return ves:velocity:surface:normalized.
}

// In the direction of surface angular momentum of ves
function surfaceBinormal {
    parameter ves is ship.

    return vcrs(ves:position - ves:body:position, surfaceTangent(ves)):normalized.
}

// Perpedicular to  both tangent and binormal, typically radially inward
function surfaceNormal {
    parameter ves is ship.

    return vcrs(surfaceBinormal(ves), surfaceTangent(ves)):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function surfaceLAN {
    parameter ves is ship.

    return angleAxis(ves:orbit:LAN - 90, ves:body:angularVel) * solarPrimeVector.
}

// Vector directly away from the body at ves' position
function localVertical {
    parameter ves is ship.

    return ves:up:vector.
}

// Angle to ascending node with respect to current body's equator
function angleToBodyAscendingNode {
    parameter ves is ship.

    local angle is vang(ves:position - ves:body:position, orbitLAN(ves)).
    if ves:status = "LANDED" {
        return angle - 90.
    }
    else {
        return angle.
    }
}

// Angle to descending node with respect to current body's equator
function angleToBodyDescendingNode {
    parameter ves is ship.

    local angle is vang(ves:position - ves:body:position, -orbitLAN(ves)).
    if ves:status = "LANDED" {
        return angle - 90.
    }
    else {
        return angle.
    }
}

// Angle to relative ascending node with assumed target
function angleToRelativeAscendingNode {
    parameter orbitBinormal.
    parameter targetBinormal.

    local joinVector is vcrs(orbitBinormal, targetBinormal).
    return vang(-body:position, joinVector).
}

// Angle to relative descending node with assumed target
function angleToRelativeDescendingNode {
    parameter orbitBinormal.
    parameter targetBinormal.

    local joinVector is -vcrs(orbitBinormal, targetBinormal).
    return vang(-body:position, joinVector).
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
    your_ancestors:add(ship:body).
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
        set vel to vel + my_ancestor:velocity:orbit.
        set my_ancestor to my_ancestor:body.
    }
    local binormal is vcrs(-common_ancestor:position, vel):normalized.

    local phase is vang(-common_ancestor:position, target:position - common_ancestor:position).
    local signVector is vcrs(-common_ancestor:position, target:position - common_ancestor:position).
    local sign is vdot(binormal, signVector).
    if sign < 0 {
        return -phase.
    }
    else {
        return phase.
    }
}

// Instantaneous heading to go from current postion to a final position along the geodesic
function greatCircleHeading {
    parameter point.    // Should be GeoCoordinates, a waypoint or a vessel
    local spot is point.
    if point:typename() = "Waypoint" {
        set spot to point:geoPosition.
    }
    else if point:typename() = "Vessel" {
        set spot to point:body:geoPositionOf(point).
    }
    
    local headN is cos(spot:lat) * sin(spot:lng - ship:longitude).
    local headD is cos(ship:latitude) * sin(spot:lat) - sin(ship:latitude) * cos(spot:lat) * cos(spot:lng - ship:longitude).
    local head is mod(arctan2(headN, headD) + 360, 360).
    return head.
}

// Burn time from rocket equation
function burnTime {
    parameter deltaV.
    
    if deltaV:typename() = "Vector" {
        set deltaV to deltaV:mag.
    }
    local burnEngines is list().
    list engines in burnEngines.
    local massBurnRate is 0.
    local g0 is 9.80665.
    for e in burnEngines {
        if e:ignition {
            set massBurnRate to massBurnRate + e:availableThrust/(e:ISP * g0).
        }
    }
    local isp is ship:availablethrust / massBurnRate.
    
    local burnTime is ship:mass * (1 - CONSTANT:E ^ (-deltaV / isp)) / massBurnRate.
    return burnTime.
}
