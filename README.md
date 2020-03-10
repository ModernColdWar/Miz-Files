# Red Storm Rising
This repository contains historic versions of the MIZ file used by the server.

The _utils_ directory contains helpful scripts for bulk editing missions.

These missions require a copy of the [RedStormRising repo](https://github.com/ModernColdWar/RedStormRising) to be installed as described [here](https://github.com/ModernColdWar/RedStormRising/blob/master/README.md).

A persistent PvP mission for DCS world.

## (A) Required changes to the DCS game files:

Note: Every DCS patch this has to be reaccomplished

 1. Edit your files for mission editing, from your install folder (not saved games), open `Scripts/MissionScripting.lua`
 	A. Comment out all the lines in the do block below the sanitization function with `-\-`.  This allows the LUA engine access to 		the file system. It should look similar to:
```lua
  --sanitizeModule('os')
  --sanitizeModule('io')
  --sanitizeModule('lfs')
  --require = nil
  --loadlib = nil
``` 
 2. From your install folder again, open `C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\modules\me_route.lua` starting on Line 139
	
   ```   
	plane_one_point = {
		actions.turningPoint, 
		actions.flyOverPoint,
		actions.takeoffRunway, 
		actions.takeoffParking,
		--actions.takeoffParkingHot, 
		--actions.landing,
		actions.takeoffGround,	--added 
		actions.takeoffGroundHot, --added
	},
	plane_first_point = {
		actions.turningPoint,
		actions.flyOverPoint,
		actions.takeoffRunway, 
		actions.takeoffParking, 
		actions.takeoffParkingHot, 
		actions.takeoffGround,	--added 
		actions.takeoffGroundHot, --added
	},
 ```
    

3. From your install folder, open 'C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\MissionEditor.lua' uncomment Line 6 (comments in lua are --)
	
```
--test_addNeutralCoalition = true
```

## (B) Required changes to the MIZ via Mission Editor:

1. Group and pilot/unit names for all airbase and FARP slots must be prefixed with their originating base:
Required for slotBlocker.lua
e.g. "Gelendzhik Red AF #010", "RedStagingPoint Helos #001", "LM95 Blue Helos #007", etc.

2. Group and pilot/unit names for all carrier slots must be prefixed with "Carrier":
Required for slotBlocker.lua
e.g. "Carrier Stennis Blue AF #004", "Carrier Admiral Kuznetsov Red AF #005", "Carrier LHA-1 Tarawa Red AF #003", etc.

3. Group and pilot/unit names for all aircraft must contain their coalition name "Red" or "Blue"
Required for slotBlocker.lua

4. Group and unit names for all ground units must contain their coalition name "Red" or "Blue"
Required for CTLD.lua > ctld.JTACAutoLase
e.g. "Mozdok Blue Heavy Armor #002", "Mozdok Blue Air Defense #010", etc.

5. "RSRbaseCaptureZone" Trigger Zone now required for all airbases/FARPs with colour set to desired side association for campagin start:
	- color:
		- Mission Editor Values 0 to 255: [255,0,0] = red, [0,255,0] = green (netural), [0,0,255] = blue
		- MIZ file values 0 to 1: [1,0,0] = red, [0,1,0] = green (netural), [0,0,1] = blue
		- set transparency 'A' to 50 in mission editor to help with visualization
		- e.g. "MM75 RSRbaseCaptureZone FARP" red colored Trigger Zone = MM75 will start campaign as red
	- radius: 10km as long as follows below guidelines
		- minimum DCS baseCapture Eventhanlder distance = 2000
		- RSR_config.lua: rsrConfig.baseDefenceActivationRadiusAirbase = 5000 currently
		- RSR_config.lua: rsrConfig.baseDefenceActivationRadiusFARP = 2500 currently
	- location: place centre over 'FARP helipad' object for FARPs, or centre of Airbase

6. "RSRlogisticsZone" Trigger Zone now required for all airbases and FARPs
	- If numbered '01' to '04' (MAX 04), one of these zones will be picked at random for logistics centre spawn for mission start or upon player repair
	- e.g. "MM75 RSRlogisticsZone 01"
	- try to place these away from the central 'FARP helipad' object so that they are not an easy target i.e. require searching
	- (optional) set radius to 200 to match CTLD_config.lua: ctld.maximumDistanceLogistic = 200
	
7. All 'FARP helipad' objects should be assigned to neutral country e.g. "Greece"
	- 'ctld.neutralCountry' in CTLD_config.lua set to neutral country e.g. "Greece"

8. All airbases set to neutral coalition

## (C) Required changes to the MIZ file after edits have been made:

1. options file (no extension for this file) inside MIZ e.g. `RSR_Dynamic_PvP_Spring_AM_Clear_v4.2.3\options`
This prevents players viewing opposing team units when changing slots.

```
options = 
{
    ["playerName"] = "mad rabbit",
    ["miscellaneous"] = 
    {
        ["f5_nearest_ac"] = false,
        ["f11_free_camera"] = false,

    }, -- end of ["miscellaneous"]
    ["difficulty"] = 
    {
        ["spectatorExternalViews"] = false,
        ["externalViews"] = false,
    }, -- end of ["difficulty"]
```

	
