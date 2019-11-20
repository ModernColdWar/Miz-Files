local M = {}

function M.loadMission(missionDir)
    print("Loading mission from " .. missionDir)
    dofile(missionDir .. "\\mission");
    dofile(missionDir .. "\\l10n\\DEFAULT\\dictionary")
    print("Mission loaded")
end

function M.typeToKey(type)
    return string.gsub(type, "-", "_")
end
M.typeToKey = typeToKey

function M.iterUnits(helicopterUnitCallback, airplaneUnitCallback)
    for _, coalition in pairs(mission.coalition) do
        for _, country in ipairs(coalition.country) do
            if country.helicopter ~= nil then
                -- Skip if no helicopters
                for _, helicopterGroups in pairs(country.helicopter) do
                    for _, helicopterGroup in ipairs(helicopterGroups) do
                        for _, helicopterUnit in ipairs(helicopterGroup.units) do
                            helicopterUnitCallback(helicopterUnit, helicopterGroup.route)
                        end
                    end
                end
            end
            if country.plane ~= nil then
                -- Skip if no planes
                for _, airplaneGroups in pairs(country.plane) do
                    for _, airplaneGroup in ipairs(airplaneGroups) do
                        for _, airplaneUnit in ipairs(airplaneGroup.units) do
                            airplaneUnitCallback(airplaneUnit, airplaneGroup.route)
                        end
                    end
                end
            end
        end
    end
end

function M.getName(unit)
    return dictionary[unit.name]
end

return M