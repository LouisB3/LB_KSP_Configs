Wait 1.5.
SAS on.
Wait 1.5.
Lock steering to up.
Wait 1.5.
Print "Launch!".
Stage.
Wait 5.
//Pitch to 45 degrees by 10km.
Print "Beginning trajectory...".
Set desired_pitch to 90.
Until altitude > 10000 {
  Set desired_pitch to 90 - altitude * 0.0045.
  Print "Pitching to " + round(desired_pitch,2) + " deg.".
  Lock steering to heading(90,desired_pitch).
  Wait 1.
}.
//Pitch to horizontal by 30km.
Until altitude > 30000 {
  Set desired_pitch to 45 - (altitude - 10000) * 0.00225.
  Print "Pitching to " + round(desired_pitch,2) + " deg.".
  Lock steering to heading(90,desired_pitch).
  Wait 1.
}.
Print "30km reached; ending program."
