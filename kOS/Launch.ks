Print "Launching in 5 seconds.".
Wait 1.
SAS on.
Wait 4.
Print "Launch!".
Stage.
Wait 1.
//Pitch to 45 degrees by 10km.
Print "Beginning trajectory...".
Set desiredPitch to 90.
Until altitude > 10000 {
  Set desiredPitch to 90 - altitude * 0.0045.
  Print "Pitching to " + round(desiredPitch,2) + " deg. at " + round(altitude/1000,3) + "km".
  Lock steering to heading(90,desiredPitch) + R(0,0,270).
  Wait 1.
}.
//Pitch to horizontal by 30km.
Print "Beginning shallow trajectory...".
Until altitude > 30000 {
  Set desiredPitch to 45 - (altitude - 10000) * 0.00225.
  Print "Pitching to " + round(desiredPitch,2) + " deg. at " + round(altitude/1000,3) + "km".
  Lock steering to heading(90,desiredPitch) + R(0,0,270).
  Wait 1.
}.
Print "Raising apoapsis to 75km...". //Strange steering behavior here.
Lock steering to heading(90,0) + R(0,0,270).
Wait until apoapsis > 75000.
Print "Suborbit reached.".
Lock throttle to 0.
Print "Switching to prograde.".
Unlock steering.
Set SASmode to "prograde".
Print "Coasting to circularization...".
Wait until altitude > 70000.
Print "Calculating circularization burn.".
Set targetSpeed to sqrt(body:mu / (body:radius + apoapsis)).
Print "Target speed: " + round(targetSpeed,2).
Set suborbitalApoapsisSpeed to velocityat(ship, time:seconds + eta:apoapsis):orbit:mag.
Print "Current speed at apoapsis: " + round(suborbitalApoapsisSpeed,2).
Set circularizationDV to targetspeed - suborbitalApoapsisSpeed.
Print "Circularization dv: " + round(circularizationDV,2).
Set maxAcceleration to maxthrust/mass.
Print "Max acceleration: " + round(maxAcceleration,2).
Set burnLength to circularizationDV/maxAcceleration.
Print "Burn duration (est.): " + round(burnLength,2).
Set circularizationNode to node(time:seconds + eta:apoapsis,0,0,circularizationDV).
Add circularizationNode.
Print "Node added.".
Set SASmode to "prograde".
Print "Waiting to circularize...".
Wait until eta:apoapsis < burnLength * 2.
Print "Zeroing warp.".
Set warp to 0.
Wait until eta:apoapsis <= (burnLength / 2).
Print "Circularizing.".
Lock throttle to 1.
Wait until velocity:orbit:mag >= targetSpeed.
Lock throttle to 0.
Print "Circularization complete.".
Print "Launch complete. Ending program.".
Set ship:control:pilotmainthrottle to 0.
