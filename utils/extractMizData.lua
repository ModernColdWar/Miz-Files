-- run with <path_to_mission_lua>
-- used to set variables and data in normalizeMiz

require("os")
package.path = package.path .. ";" .. os.getenv("DCS_PATH") .. "\\Scripts\\?.lua"

local Serializer = require("Serializer")
local common = require("common")

local missionLua = arg[1]

common.loadMission(missionLua)

local totalFuel = {}

function recordTotalFuel(unit, route)
  key = common.typeToKey(unit.type)
  totalFuel[key] = tonumber(unit.payload.fuel)
end

common.iterUnits(recordTotalFuel, recordTotalFuel)

local inspect = require("inspect")
print("local fuelCapacities = " .. inspect(totalFuel))

print("Done")
