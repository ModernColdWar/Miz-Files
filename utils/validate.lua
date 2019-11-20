local inspect = require("inspect")
local missionUtils = require("missionUtils")

local missionDir = arg[1]
if missionDir == nil then
    missionDir = "Cau-PVP-Dynamic-Objectives-Sling-CaptureAirfield-V6.4"
    --print("No mission dir specified")
    --os.exit(1)
end

missionUtils.loadMission(missionDir)

local function validateClientGroup(group)
    local errors = {}
    local groupName = missionUtils.getDictionaryValue(group.name)
    if #group.units ~= 1 then
        table.insert(errors, string.format("'%s' should only have 1 unit, but has %d", groupName, #group.units))
    end
    local unit = group.units[1]
    local unitName = missionUtils.getDictionaryValue(unit.name)
    if missionUtils.isTransportType(unit.type) and unitName ~= groupName then
        table.insert(errors, string.format("Group '%s' must contain unit with same name, but was '%s'", groupName, unitName))
    end
    for _, error in ipairs(errors) do
        print("ERROR: "  .. error)
    end
end

missionUtils.iterGroups(function(group)
    if missionUtils.isClientGroup(group) then
        validateClientGroup(group)
    end
end)

local pickupZones = {}
local logisticsZones = {}
for _, zone in ipairs(mission.triggers.zones) do
    local zoneName = zone.name
    if string.match(zoneName:lower(), " pickup$") then
        table.insert(pickupZones, zoneName)

    elseif string.match(zoneName:lower(), " logistics$") then
        table.insert(logisticsZones, zoneName)
    end
end

print("Pickup zones: " .. inspect(pickupZones))
print("Logistics zones: " .. inspect(logisticsZones))