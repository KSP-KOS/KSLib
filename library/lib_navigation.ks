// This file is distributed under the terms of the MIT license, (c) the KSLib team
@LAZYGLOBAL OFF.

// Same as orbital prograde vector
function orbitTangent {
    return ship:velocity:orbit:normalized.
}

// In the direction of orbital angular momentum
function orbitBinormal {
    return vcrs(-body:position, orbitTangent()):normalized.
}

// Perpendicular to both tangent and binormal, typically radially inward
function orbitNormal {
    return vcrs(orbitBinormal(), orbitTangent()):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function orbitLAN {
    return angleAxis(orbit:LAN, body:angularVel) * solarPrimeVector.
}

// Same as surface prograde vector
function surfaceTangent {
    return ship:velocity:surface:normalized.
}

// In the direction of surface angular momentum
function surfaceBinormal {
    return vcrs(-body:position, surfaceTangent()):normalized.
}

// Perpedicular to  both tangent and binormal, typically radially inward
function surfaceNormal {
    return vcrs(surfaceBinormal(), surfaceTangent()):normalized.
}

// Vector pointing in the direction of longitude of ascending node
function surfaceLAN {
    return angleAxis(orbit:LAN - 90, body:angularVel) * solarPrimeVector.
}

// Vector directly away from the body at this point
function localVertical {
    return up:vector.
}

// Same as orbital prograde vector, assumes target is set
function targetTangent {
    return target:velocity:orbit:normalized.
}

// In the direction of orbital angular momentum, assumes target is set
function targetBinormal {
    return vcrs(target:position - target:body:position, targetTangent()):normalized.
}

// Perpendicular to both tangent and binormal, typically radially inward
// Assumes target is set
function targetNormal {
    return vcrs(targetBinormal(), targetTangent()):normalized.
}

// Vector pointing in the direction of longitude of ascending node
// Assumes target is set
function targetLAN {
    return angleAxis(target:orbit:LAN, target:body:angularVel) * solarPrimeVector.
}

// Angle to ascending node with respect to current body's equator
function angleToBodyAscendingNode {
    local angle is vang(-body:position, orbitLAN()).
    if ship:status = "LANDED" {
        return angle - 90.
    }
    else {
        return angle.
    }
}

// Angle to descending node with respect to current body's equator
function angleToBodyDescendingNode {
    local angle is vang(-body:position, -orbitLAN()).
    if ship:status = "LANDED" {
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
    local spot is 0.
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
