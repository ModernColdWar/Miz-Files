# Red Storm Rising
This repository contains historic versions of the MIZ file used by the server.

The _utils_ directory contains helpful scripts for bulk editing missions.

These missions require a copy of the [RedStormRising repo](https://github.com/ModernColdWar/RedStormRising) to be installed as described [here](https://github.com/ModernColdWar/RedStormRising/blob/master/README.md).

A persistent PvP mission for DCS world.

## Prior to editing miz files or any files really complete the following:

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

## Required changes to the MIZ file after edits have been made:

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

	
