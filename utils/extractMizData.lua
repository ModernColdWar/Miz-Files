-- run with <path_to_mission_lua>
-- used to set variables and data in normalizeMiz

require("os")
package.path = package.path .. ";" .. os.getenv("DCS_PATH") .. "\\Scripts\\?.lua"

local Serializer = require("Serializer")
local common = require("common")

local missionLua = arg[1]

function iterClientUnits(unitCallback)
  for _, coalition in pairs(mission.coalition) do
    for _, country in ipairs(coalition.country) do
      if country.helicopter ~= nil then -- Skip if no helicopters
        for _, helicopterGroups in pairs(country.helicopter) do
          for _, helicopterGroup in ipairs(helicopterGroups) do
            for _, helicopterUnit in ipairs(helicopterGroup.units) do
              unitCallback(helicopterUnit)
            end
          end
        end
      end
      if country.plane ~= nil then -- Skip if no planes
        for _, airplaneGroups in pairs(country.plane) do
          for _, airplaneGroup in ipairs(airplaneGroups) do
            for _, airplaneUnit in ipairs(airplaneGroup.units) do
              unitCallback(airplaneUnit)
            end
          end
        end
      end
    end
  end
end

print("Loading mission from " .. missionLua)
dofile(missionLua);
print("Mission loaded")

local totalFuel = {}


function recordTotalFuel(unit)
  key = common.typeToKey(unit.type)
  totalFuel[key] = tonumber(unit.payload.fuel)
end

iterClientUnits(recordTotalFuel)

local inspect = require("inspect")
print("local fuelCapacities = " .. inspect(totalFuel))

print("Done")
