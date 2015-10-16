@LAZYGLOBAL OFF.

// requirements:
// a) 2 vessels within physics range, and with relative velocity under a reasonable amount
//    (anything under 10m/s should be fine)
// b) a light ship that can turn 180 degrees reasonably fast
// c) no RCS will be used, only thrusters


// instructions
// 1-focus on target, right click the docking port you want and rename it "dockme"
// 2-still on target, turn sas on or any other stabilizing way of avoiding rotations (avoid using MJ TGT+, it has caused me some wobble)
// 3-focus on the ship that will perform the maneuvers, right click on the docking port and rename it to "dockme"
// 4-open the kOS terminal and run the example while focused on the maneuvering vessel

//////////////////////////////////
// algorithm main parameters: depending on your craft you may need to struggle with these
declare local distanceOffset to 10. // distance in front of docking port to be parked before last maneuver
declare local distanceThreshold to 5. // distance from parking point allowed to start last maneuver

declare local haltTimeBeforeGoal to 5. // default 5s. will stop 5s before reaching goal. increase this if TWR is low, decrease if torque is low
declare local speedToDistanceFactor to 50. // default 50s. will set a speed such that it reaches the goal in 50 seconds
//////////////////////////////////

declare global offsetX to 10.
declare local targetPort to 0. // the other docking port
declare local shipPort to 0. // my own docking port

declare local AIMING_VECTOR to initVectorDraw("aim",blue).
declare local TRANSLATION_VECTOR  to initVectorDraw("Parking",green).
declare local OFFSET_VECTOR to initVectorDraw("Final burn",red).

declare local translationOffset to v(0,0,0). // to be used as a "global" in this library namespace
declare local translationToPort to v(0,0,0). // same here
declare local orbitalVel to v(0,0,0).

declare function initVectorDraw {
  parameter label.
  parameter color.

  declare local vectorDraw to vecdraw().
  set vectorDraw:label to label.
  set vectorDraw:color to color.
  set vectorDraw:show to TRUE.
  set vectorDraw:scale to 1.

  return vectorDraw.

}

declare function init {
  parameter dockingTarget.

  declare local prevTime to time-1.

  lock translationToPort to  dockingTarget:position -ship:position.
  lock translationOffset to  translationToPort + dockingTarget:facing:vector * distanceOffset.
  lock orbitalVel to -SHIP:velocity:orbit + dockingTarget:ship:velocity:orbit.
  lock aim to shipPort:facing:vector * translationToPort:mag.

}.

declare function message {
  parameter msg.
  HUDTEXT(msg, 20, 1, 12, rgb(1,0.8,0.8), true).
}.

declare function findPart {
  parameter vessel.
  parameter tag.

  declare local taggedList to VESSEL:PARTSTAGGED(tag).
  declare local taggedPart to 0.

  if taggedList:EMPTY {
    message("Cannot find tag " + tag + " on vessel " + VESSEL:NAME).
    set taggedPart to vessel.
  }

  if taggedList:LENGTH > 1 {
    message("There are  " + taggedList:LENGTH + " parts with tag " + tag).
  }

  FOR p IN taggedList {
    set taggedPart to p.
    break.
  }

  return taggedPart.

}.

declare function findParts {

  message("Dock (" + SHIP:NAME + ") to (" + TARGET:NAME + ")").

  set shipPort to findPart(SHIP,"dockme").

  set targetPort to findPart(TARGET,"dockme").

  declare local color to rgb(0,0.5,1).

  HIGHLIGHT(shipPort,color).
  HIGHLIGHT(targetPort,color).

  return targetPort.
}.

declare function burnIt {
  parameter speed.
  parameter dir.

  pointIt(dir).

  declare local done to false.

  print "Burn pointing to dir until reaches speed " + speed at (offsetX,18).

  lock throttle to 1.
  when orbitalVel:mag > speed then {
      lock throttle to 0.
      set done to true.
  }

  until done {
    wait 0.1.
  }.
}.

declare function haltIt {
  parameter speed.

  declare local doneHalt to false.

  lock speedDiff to orbitalVel:mag - speed.

  pointIt(orbitalVel).
  pointIt(orbitalVel). // 2x for better pointing

  print "Burn pointing to dir until speed is less than " + speed at (offsetX,19).

  lock T to 0.

  lock throttle to T.
  when speedDiff < 0 then {
      lock throttle to 0.
      set doneHalt to true.
      print "Speed is " + round(orbitalVel:mag,2)  at (1,20).
  }

  declare local prevSpeed to 1000.
  declare local throttleMagicNumber to 5.
  until doneHalt {
    if orbitalVel:mag > throttleMagicNumber  {
      lock T to 1.
    } else {
      lock T to orbitalVel:mag / throttleMagicNumber.
    }

    set prevSpeed to orbitalVel:mag.
    wait 0.1.
    if ( orbitalVel:mag > prevSpeed) {
      lock throttle to 0.
      set doneHalt to true.
      print "Speed increase detected at " + prevSpeed at (1,25).
    }
  }

  message("Halt done goal " + round(speed,2) + "m/s, reached " + round(orbitalVel:mag,2)+ "m/s").


}.

declare function getAngularMomentum {

  declare local delay to 0.1.
  declare local angle to 100. //whatever
  declare local vAngle to 100.//whatever

  declare local prefFacing to ship:facing:vector.
  wait delay.

  set angle to vang(prefFacing,ship:facing:vector).
  set vAngle to angle/delay.

  return vAngle.

}.

declare function pointIt {
  parameter dir.

  declare local toleranceAngle to .5.
  declare local angularMomentumThreshold to 1.2.
  declare local angularSpeed to 100. 
  declare local pointItDone to false.

  // do the actual pointing
  sas off.
  LOCK STEERING to  lookdirup(dir,ship:facing:topvector).
  when true then{
    UNLOCK STEERING.
    sas on.
  }

  // wait until it really points there
  lock offAngle to vang(ship:facing:vector,dir) - toleranceAngle.

  when offAngle < 0 then {
    if ( angularSpeed < angularMomentumThreshold ) {
      set pointItDone to true.
    } else {
      preserve.
    }
  }.

  until pointItDone {
    updateVisualVectors().
    wait 0.2.
    set angularSpeed to getAngularMomentum().
    print "Direction is off by  " + round(offAngle,1) + " degrees"  at (offsetX,18).
    print "Angular speed is by  " + round(angularSpeed,2) + " degrees/s"  at (offsetX,19).
  }


  print "Craft is aimed and stabilized".
}.

declare function waitOnTime {
  parameter timeBeforeHit.

  declare local doneWaiting to false.

  message("Time before hit " + timeBeforeHit + "s").

  lock estimateTime to (translationOffset:mag)/(orbitalVel:mag) - timeBeforeHit.

  pointIt(orbitalVel).
  pointIt(orbitalVel). // 2x for better pointing

  when estimateTime < 0  then {
    set doneWaiting to true.
  }

  declare local prevEstimateTime to translationOffset.

  until doneWaiting {

    updateVisualVectors().
    print "Waiting approach, distance " + round(translationOffset:mag,0) + "    "  at (offsetX,15).
    print "Waiting approach, velocity " + round(orbitalVel:mag,1) + "    "   at (offsetX,16).
    print "Waiting approach, ETA      " + round(estimateTime,0)   + "    "   at (offsetX,17).

    //print "debug " + translationOffset:mag + " < " +  translationOffset:mag at (offsetX,26).
    set prevEstimateTime to translationOffset.
    //print "debug " + translationOffset:mag + " < " +  translationOffset:mag at (offsetX,27).
    wait 0.1.
    if ( translationOffset:mag > prevEstimateTime:mag) {
      set doneWaiting to true.
    }
  }


}.

declare function finalApproach {

  declare local voff to translationToPort.

  message("point 1x").
  pointIt(translationToPort).
  set voff to translationToPort.

  // TODO need to improve this logic, I never end up aiming at bull's eye
  wait 1.
  set voff to vang(voff,translationToPort).
  message("point 2x corrected by " + round(voff,2) + " degrees" ).
  pointIt(translationToPort).
  message("point ok").

  lock throttle to 0.1.
  wait until orbitalVel:mag > 1.1. // too fast and you bounce, too slow and the target has moved
  lock throttle to 0.

}

declare function unlockSas {

  declare local sasThreshold to 2.1. // distance from docking port when we turn off sas


  until (translationToPort:mag < sasThreshold) {
    wait 0.1.
    updateVisualVectors().
  }.
  message("sas unlocked").

  // need more work, not doing as intended
  pointIt(translationToPort).
  sas off.
  wait 5. // let's hope this is enough time, becase when this finishes chances are that sas will be on
}

declare function dockToPort {

  parameter dockingTarget.

  init(dockingTarget).

  updateVisualVectors().
  haltIt(0.05).

  until translationOffset:mag < distanceThreshold {
    message("burn").
    set TRANSLATION_VECTOR:vec to translationOffset.
    burnIt(translationOffset:mag/speedToDistanceFactor,translationOffset).
    message("wait").
    waitOnTime(haltTimeBeforeGoal).
    message("halt").
    haltIt(0.05).
  }

  if (translationOffset:mag < distanceThreshold*1.2) {
    haltIt(0.01). // need great precision for the final burn
    message("approach").
    finalApproach().
    message("sas off").
    unlockSas().
  }

}.

// visual and text feedback
declare function updateVisualVectors {

  print "Parking distance is " + round(translationOffset:mag,0) + "m   " at (offsetX,18).
  print "Dockint port is at  " + round(translationToPort:mag,0) + "m   " at (offsetX,19).

  set TRANSLATION_VECTOR:vec to translationOffset.

  set OFFSET_VECTOR:start to translationOffset.
  set OFFSET_VECTOR:vec to translationToPort-translationOffset.

  set AIMING_VECTOR:vec to aim.
}
