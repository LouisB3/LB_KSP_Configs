## Lunar XP Tweaks

Astronaut XP progression in stock KSP is unsatisfying: planting a flag on the Mun doesn't even get a kerbal to Level 2; it's impossible to get to Level 3 within the Kerbin system.

This changes several bodies' XP multipliers to place greater emphasis on flags-and-footprints missions to the Mun, Minmus, and Duna. A flag on either of Kerbin's moons are sufficient to reach Level 2; flags on both will grant Level 3; and a subsequent flag on Duna will provide Level 4.

As a side effect, lunar contracts will have somewhat greater rewards (and contracts in solar orbit will have lesser rewards.) This is because KSP uses the same variable ("recoveryValue") to tune both astronaut XP and contract values. Since stock career mode balance is a mess anyway, this behavior is deemed an acceptable trade-off.

- **Dependency**: Kopernicus

## Reasonable EVA Jetpack

The EVA jetpack in stock KSP is wildly overpowered. This tweaks jetpack capabilities so that it resembles NASA's Manned Maneuverability Unit. EVA propulsion remains suitable for local spacewalks, but orbital maneuvers are more limited, and unassisted descent or ascent on Minmus is out of the question.

- Thrust, specific impulse, and propellant load have all been nerfed.
  - Thrust is 15% of stock (39 N, down from 259 N).
  - Specific impulse is 30% of stock (63 s, down from 211 s).
  - Propellant capacity is reduced from 25 kg to 12 kg.
- Acceleration is now about 0.05g instead of around 0.33g.
- Delta-V is now 105 m/s, down from 674 m/s.
- EVA fuel cylinders have had their capacity and dry mass reduced.
- Lunar surface EVA flight is now effectively impossible, so lander ladders become critical; the basic ladder has been moved in the tech tree from Space Exploration to Survivability.

This will affect all kerbals everywhere, including those already in flight; this is because KSP stores most of the relevant parameters in the KerbalEVA module, so it's not possible to create multiple types of jetpack with different characteristics. Consider installing this only on a new save; or at a minimum, back up your savegame first.

- **Dependency**: KSP 1.11+

## Popular American Names

For if and when you tire of seeing astronaut names that consist of randomly-generated gibberish.

A configuration for Kerbal Renamer to use popular American names. 1000 each of male and female first and last names have been provided, so two million unique names are possible. Probabilities are not weighted, so expect to see a lot of variant spellings and unusual combinations.

Based on data from the Social Security Administration (1938-2014) and U.S. Census (2000).

- **Dependency**: Kerbal Renamer

## License

All work released here is licensed CC-BY-NC unless otherwise specified.
