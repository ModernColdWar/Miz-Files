-- Sets attributes on client aircraft inside a mission file to the desired ones
-- with thanks to Quaggles

-- run with <path_to_mission_lua> [--write]

require("os")
package.path = package.path .. ";" .. os.getenv("DCS_PATH") .. "\\Scripts\\?.lua"

local Serializer = require("Serializer");

local missionLua = arg[1]
local write = #arg >= 2 and arg[2] == "--write"

function iterClientUnits(heliCallback, airplaneCallback)
  for _, coalition in pairs(mission.coalition) do
    for _, country in ipairs(coalition.country) do
      if country.helicopter ~= nil then -- Skip if no helicopters
        for _, helicopterGroups in pairs(country.helicopter) do
          for _, helicopterGroup in ipairs(helicopterGroups) do
            for _, helicopterUnit in ipairs(helicopterGroup.units) do
              if helicopterUnit.skill == "Client" then
                heliCallback(helicopterUnit)
              end
            end
          end
        end
      end
      if country.plane ~= nil then -- Skip if no planes
        for _, airplaneGroups in pairs(country.plane) do
          for _, airplaneGroup in ipairs(airplaneGroups) do
            for _, airplaneUnit in ipairs(airplaneGroup.units) do
              if airplaneUnit.skill == "Client" then
                airplaneCallback(airplaneUnit)
              end
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

local desiredFuelAmounts = {
  Ka_50=580, -- 40% (total capacity: 1450)
  Mi_8MT=772, -- 40% (total capacity: 1930)
  SA342L=166.4, -- 40% (total capacity: 416)
  SA342M=166.4, -- 40% (total capacity: 416)
  SA342Mistral=166.4, -- 40% (total capacity: 416)
  UH_1H=189.6, -- 30% (total capacity: 632)
}

function setFuel(unit)
  key = string.gsub(unit.type, "-", "_")
  desiredFuel = desiredFuelAmounts[key]
  if desiredFuel == nil then error("No desiredFuelAmount found for " .. key) end
  if unit.payload.fuel ~= desiredFuel then
    print("Setting fuel for " .. unit.type .. " named " .. unit.name .. " from " .. unit.payload.fuel .. " to " .. desiredFuel)
    unit.payload.fuel = desiredFuel
  end
end

function noOp(unit)
end

iterClientUnits(setFuel, noOp)

if write then
  -- Write file to disk
  print("Updating mission at " .. missionLua)
  outfile = io.open(missionLua, "w+")

  -- Uses ED's serializer to make sure it's compatible
  serializer = Serializer.new(outfile)
  serializer.fout = outfile -- Why this is required is beyond me, Serializer.new() does this already
  serializer:serialize_simple2('mission', mission)

  outfile:close()
end

print("Done")
