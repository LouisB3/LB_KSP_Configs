//Setup until first engine flames out.
Print "Setting up.".
set launch_longitude to geoposition:lng.
Set boosterengine TO ship:partstagged("booster")[0].
Set reservetank TO ship:partstagged("reservefuel")[0].
For var in reservetank:resources {
  Set var:enabled to false.
}.
Set initial_reserve_mass to 0.
For var in reservetank:resources {
  Set initial_reserve_mass to initial_reserve_mass + (var:amount * var:density).
}.
Set current_reserve_mass to initial_reserve_mass.
Print "Waiting to stage...".
Wait until boosterengine:flameout = true.
Print "Staging.".
Stage.
//Prep for boostback.
Print "Zeroing throttle.".
Lock throttle to 0.
Print "Disabling SAS.".
SAS off.
Print "Waiting five seconds for separation.".
Wait 5.
Print "Unlocking reserve fuel.".
For var in reservetank:resources {
  Set var:enabled to true.
}.
Print "Enabling RCS.".
RCS on.
Print "Steering west.".
Lock steering to heading(270,0) + R(0,0,270).
Print "Waiting 25 seconds for steering.".
Wait 25.
//Boost back until we will impact near the launch site...
//or until we risk running out of landing fuel.
Print "Boosting back!".
Lock throttle to 0.5.
Until false {
  Set current_reserve_mass to 0.
  For var in reservetank:resources {
    Set current_reserve_mass to current_reserve_mass + (var:amount * var:density).
  }.
  If current_reserve_mass < initial_reserve_mass / 4 {
    Print "Reserve fuel < 25% maximum!".
    Break.
  }.
  If abs(impact_longitude() - launch_longitude) < 0.25 {
    Print "Est. impact distance from launch < 0.25 deg!".
    Wait 0.25. //overshoot slightly due to drag
    Break.
  }.
}.
Print "Est. impact distance from launch: " + round(impact_distance_km(),3) + "km".
//Wrap up and monitor the situation until we land.
Print "Ending boostback. Waiting 15 seconds.".
Lock throttle to 0.
RCS off.
Unlock steering.
Wait 15.
Print "Releasing control.".
Unlock throttle.
When altitude < 10000 then {
  Print "Deploying landing gear.".
  Brakes on.
  Gear on.
}.
Until false {
  if ship:status = "LANDED" or ship:status = "SPLASHED" {
    Print "Surface reached. Program ending.".
    Break.
  }.
  Wait 5.
  Print "Est. impact distance from launch: " + round(impact_distance_km(),3) + "km".
}.

Function impact_longitude {
  Set some_time to time.
  set some_position to positionat(ship, some_time).
  Set some_vector to some_position - body:position.
  Set some_altitude to ship:altitude.
  Until some_altitude < 75 {
    Set some_time to some_time + 1.
    Set some_position to positionat(ship, some_time).
    Set some_vector to some_position - body:position.
    Set some_altitude to some_vector:mag - body:radius.
  }.
  //Adjust for planetary rotation.
  return body:geopositionof(some_position):lng - (some_time:minute - time:minute).
  //Alternate method: calculate from true anomaly at time of impact.
}.

Function impact_distance {
  return abs(impact_longitude() - launch_longitude).
}.

Function impact_distance_km {
  //Convert equatorial degrees to km for a 600km radius sphere.
  return impact_distance() * 10.47197.
}.
