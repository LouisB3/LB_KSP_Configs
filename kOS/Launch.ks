Print "Launching in 5 seconds.".
Wait 1.
SAS on.
Wait 4.
Print "Launch!".
Stage.
Wait 5.
//Pitch to 45 degrees by 10km.
Print "Beginning trajectory...".
Set desired_pitch to 90.
Until altitude > 10000 {
  Set desired_pitch to 90 - altitude * 0.0045.
  Print "Pitching to " + round(desired_pitch,2) + " deg. at " + round(altitude/1000,3) + "km".
  Lock steering to heading(90,desired_pitch) + R(0,0,270).
  Wait 1.
}.
//Pitch to horizontal by 30km.
Print "Beginning shallow trajectory..."
Until altitude > 30000 {
  Set desired_pitch to 45 - (altitude - 10000) * 0.00225.
  Print "Pitching to " + round(desired_pitch,2) + " deg. at " + round(altitude/1000,3) + "km".
  Lock steering to heading(90,desired_pitch) + R(0,0,270).
  Wait 1.
}.
Print "Raising apoapsis to 75km...".
Lock steering to heading(90,0) + R(0,0,270).
Wait until apoapsis > 75000.
Print "Suborbit reached.".
Lock throttle to 0.
Print "Switching to prograde.".
Unlock steering.
Set SASmode to "prograde".
Print "Coasting to circularization...".
Wait until altitude > 70000.
//Add circularization logic here.
Print "Returning control.".
Set ship:control:pilotmainthrottle to 0.
