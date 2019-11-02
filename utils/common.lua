local M = {}

function loadMission(missionLuaPath)
  print("Loading mission from " .. missionLuaPath)
  dofile(missionLuaPath);
  print("Mission loaded")
end

M.loadMission = loadMission


function typeToKey(type)
  return string.gsub(type, "-", "_")
end

M.typeToKey = typeToKey


function iterUnits(helicopterUnitCallback, airplaneUnitCallback)
  for _, coalition in pairs(mission.coalition) do
    for _, country in ipairs(coalition.country) do
      if country.helicopter ~= nil then -- Skip if no helicopters
        for _, helicopterGroups in pairs(country.helicopter) do
          for _, helicopterGroup in ipairs(helicopterGroups) do
            for _, helicopterUnit in ipairs(helicopterGroup.units) do
              helicopterUnitCallback(helicopterUnit)
            end
          end
        end
      end
      if country.plane ~= nil then -- Skip if no planes
        for _, airplaneGroups in pairs(country.plane) do
          for _, airplaneGroup in ipairs(airplaneGroups) do
            for _, airplaneUnit in ipairs(airplaneGroup.units) do
              airplaneUnitCallback(airplaneUnit)
            end
          end
        end
      end
    end
  end
end

M.iterUnits = iterUnits

return M