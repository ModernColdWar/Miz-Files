# Overview

This repository contains historic versions of the MIZ file used by the server.

The _utils_ directory contains helpful scripts for bulk editing missions.

These missions require a copy of the [RedStormRising repo](https://github.com/ModernColdWar/RedStormRising) to be installed as described [here](https://github.com/ModernColdWar/RedStormRising/blob/master/README.md).

NOTE: When editing the mission file be sure to configure the me_route.lua file C:\Program Files\Eagle Dynamics\DCS World OpenBeta\MissionEditor\modules\me_route.lua. 

Starting on Line 139

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
