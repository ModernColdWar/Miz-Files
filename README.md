# Red Storm Rising
This repository contains historic versions of the MIZ file used by the server. Inside the MIZ, there are triggers to load the seperate <a href="https://github.com/ModernColdWar/RSR-Syria">LUA files</a> which load on mission start.

## <a href="https://github.com/ModernColdWar/RSR-Syria">LUA files</a>
The RSR-Syria repository contains all the lua files required to run the mission. Once tested, submited and approved they are sent to the server and loaded. 
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/AWACS-Tankers.lua">AWACS-Tankers.lua</a>
The <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/AWACS-Tankers.lua">AWACS-Tankers.lua</a> Contains moose snippets that generate an F10 menu to allow aircraft to call in AWACS and Tankers into the mission. 
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/CSAR.lua">CSAR.lua</a>
The <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/CSAR.lua">CSAR.lua</a> script allows for downed pilots to be recovered, and thier life returned. We also use the CSAR script to manage pilots lifes on a per restart basis.
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/Capture_zones.lua">Capture_Zones.lua.lua</a>
The <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/Capture_zones.lua">Capture_Zones.lua.lua</a> is a moose function and is used to manage the base capture mechanics. It defines a 3km radius around the zone placed in the mission editor. It then monitors this zone for updates, if a unit is in the zone, and generates a defended/attacked/capture/ status. It is seperate from the built in DCS capture mechanic and not tied to the logistics. We have tied in Cribobs simple slot blocker into the capture_zone lua, the flags for client spawns is wrapped into the `OnEnterGuarded` FSM.
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/EWRS.lua">EWRS.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/JTAC-Designate.lua">JTAC-Designate.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/Moose.lua">Moose.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/SGS_RSR.lua">SGS_RSR.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/UAV-Recon.lua">UAV-Recon.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/WeaponManager.lua">WeaponManager.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/mist_4_4_90.lua">mist_4_4_90.lua</a>
### <a href="https://github.com/ModernColdWar/RSR-Syria/blob/main/warehouseResupply.lua">warehouseResupply.lua</a>

The _utils_ directory contains helpful scripts for bulk editing missions.

A persistent PvP mission for DCS world.

## (A) Required changes to the DCS game files:

Note: Every DCS patch this has to be reaccomplished

 1. Edit your files for mission editing. The below changes make your DCS able to load and save lua files. To enable this you will need to access the DCS root, so from your install folder (not saved games), open `Scripts/MissionScripting.lua`
 	A. Comment out all the lines in the do block below the sanitization function with `-\-`.  This allows the LUA engine access to 		the file system. It should look similar to:
```lua
  --sanitizeModule('os')
  --sanitizeModule('io')
  --sanitizeModule('lfs')
  --require = nil
  --loadlib = nil
``` 
 2. This make planes capable from starting from any spot on the ground rather than a fixed parking spot. This doesn't work for FC3 planes. From your install folder again, open `C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\modules\me_route.lua` starting on Line 139
	
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
    

3. This lets neutral coalitions be added to the mission. From your install folder, open 'C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\MissionEditor.lua' <b>uncomment</b> Line 6 (comments in lua are --)
	
```
--test_addNeutralCoalition = true
```

# Below is only applicaple to the Cuacasus Server.
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
	- NO LONGER POSSIBLE IN DCS 2.5.6!
		- Selecting FARP helipads will automatically revert the country to USA and thus coalition to blue!
			- Settings dialog will also be garbled due to incompatibility of mission editor with neutral coaltion as experimental feature
			- Name of FARP helipad, which is cruicial for most of RSR baseOwnership, may also revert to "Ammo #001"
		- New FARP helipads should be:
		a) Placed under unused red/blue country e.g. Yugoslavia
		b) Unpack mission outside of DCS
		c) Copy details of FARP helipad in 'mission' file from unsed red/blue country to neutral coalition country e.g. Yugoslavia to Greece

8. All airbases set to neutral coalition

9. Crate 'PickUp' Trigger Zones for all airbases and FARPs to allow loading of troops
	- e.g. 'FJ03 PickUp'
	- place over centre of runway for airbases and centre of FARP helipad object for FARPs
	- radius of 180m ideal for FARP helipads
	- loading of troops only allowed within radius of Trigger Zone
	- do NOT assign a color to this trigger, as this will create smoke in these zones

## (C) Required changes to the MIZ file after edits have been made:

1. options file (no extension for this file) inside MIZ e.g. `RSR_Dynamic_PvP_Spring_AM_Clear_v4.2.3\options`
	- These prevents players viewing opposing team units when changing slots.
	- "ground_aim_helper" prevent aim assist when operating some vehicles in Combined Arms
```
options = 
{
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
	["CA"] =
	{
		["ground_aim_helper"] = false,
	}
```

2. Change any red/blue country assigned FARP helipads to a neutral country as described above in (B7)	
