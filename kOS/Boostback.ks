//Setup until first engine flames out.
Print "Setting up.".
set launchLongitude to geoposition:lng.
//To do: accept booster engine tag name as argument, for multi-stage boostbacks.
Set boosterEngine to ship:partstagged("booster")[0].
Print "Waiting to stage...".
Wait until boosterEngine:flameout.
Print "Staging.".
Stage.
Set reserveTank to ship:partstagged("reservefuel")[0].
Print "Zeroing throttle.".
Lock throttle to 0.
Print "Disabling SAS.".
SAS off.
Print "Waiting five seconds for separation.".
Wait 5.
Print "Unlocking reserve fuel.".
For var in reserveTank:resources {
  Set var:enabled to true.
}.
Print "Enabling RCS.".
RCS on.
Print "Steering west.".
Lock steering to heading(270,0) + R(0,0,270).
Print "Waiting for steering...".
Set dueWest to North + R(0,90,0).
Until abs(dueWest:yaw - facing:yaw) < 2.5 { //Not sure if this is correct, but it seems to work.
  //Print "Difference from west (pitch): " + round(abs(dueWest:pitch - facing:pitch),2).
  Print "Difference from west (yaw): " + round(abs(dueWest:yaw - facing:yaw),2).
  //Print "Difference from west (roll): " + round(abs(dueWest:roll - facing:roll),2).
  Wait 1.
}.
//Boost back until we will impact near the launch site...
//or until we risk running out of landing fuel.
Print "Boosting back!".
Lock throttle to 1.
Set boostingBack to true.
Set emergencyAbort to false.
When LandingDV(boosterEngine, reserveTank:resources) < 350 and (boostingBack or overshooting) then {
  Print "Landing capacity < 350 dv!".
  Lock throttle to 0.
  Set boostingBack to false.
  Set overshooting to false.
  Set emergencyAbort to true.
}.
Until not boostingBack {
  Set currentImpactDistance to impactDistance().
  If currentImpactDistance < 1 {
    Print "Est. impact distance from launch < 1km!".
    Lock throttle to 0.
    Set boostingBack to false.
    Break.
  }.
  If currentImpactDistance < 100 and not emergencyAbort {
    Lock throttle to max(currentImpactDistance / 50, 0.05).
    Print "Est. impact distance from launch: " + round(currentImpactDistance,3) + "km".
  }.
}.
If not emergencyAbort {
  Print "Intentionally overshooting.". //Better to be on land than water.
  Set overshooting to true.
  Lock throttle to 0.05.
  Until not overshooting {
    Set currentImpactDistance to impactDistance().
    If currentImpactDistance > 2 { //Determined experimentally.
      Print "Overshoot complete.".
      Lock throttle to 0.
      Set overshooting to false.
      Break.
    }.
    Print "Est. impact distance from launch: " + round(currentImpactDistance,3) + "km".
  }.
}.
Print "Est. impact distance from launch: " + round(impactDistance(),3) + "km".
Print "Est. dv available for landing: " + round(LandingDV(boosterEngine, reserveTank:resources),2).
//Wrap up and monitor the situation until we land.
Print "Wrapping up.".
Lock throttle to 0.
RCS off.
Unlock steering.
Print "Releasing control.".
Unlock throttle.
When altitude < 15000 then {
  Print "Deploying brakes.".
  Brakes on.
}.
When altitude < 10000 then {
  Print "Deploying landing gear.".
  Gear on.
}.
When altitude < 5000 then {
  Print "Enabling RCS.".
  RCS on.
}.
Until ship:status = "LANDED" or ship:status = "SPLASHED" {
  Print "Est. impact distance from launch: " + round(impactDistance(),3) + "km".
  Wait 5.
}.
Print "Surface reached. Program ending.".

Function impactLongitude {
  Set someTime to time.
  set somePosition to positionat(ship, someTime).
  Set someVector to somePosition - body:position.
  Set someAltitude to ship:altitude.
  Until someAltitude < 75 {
    Set someTime to someTime + 1.
    Set somePosition to positionat(ship, someTime).
    Set someVector to somePosition - body:position.
    Set someAltitude to someVector:mag - body:radius.
  }.
  //Adjust for planetary rotation.
  return body:geopositionof(somePosition):lng - ((someTime:seconds - time:seconds)/60).
  //Alternate method: calculate from true anomaly at time of impact.
  //Better method? just get the Trajectories mod.
}.

Function impactDistance {
  return abs(impactLongitude() - launchLongitude) * (2 * constant:pi * body:radius / 360 / 1000).
}.

Function LandingDV {
  Parameter landingEngine, availablePropellants.
  Set propellantMass to 0.
  For var in availablePropellants {
    Set propellantMass to propellantMass + (var:amount * var:density).
  }.
  return ln(mass / (mass - propellantMass)) * landingEngine:sealevelisp * 9.81.
}.
