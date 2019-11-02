-- Sets attributes on client aircraft inside a mission file to the desired ones
-- with thanks to Quaggles

-- run with <path_to_mission_lua> [--write]

require("os")
package.path = package.path .. ";" .. os.getenv("DCS_PATH") .. "\\Scripts\\?.lua"

local Serializer = require("Serializer")
local common = require("common")

local missionLua = arg[1]
local write = #arg >= 2 and arg[2] == "--write"

local fuelCapacities = {
  AJS37 = 4476,
  AV8BNA = 3519.423,
  A_10A = 5029,
  A_10C = 5029,
  C_101CC = 1580.46,
  FA_18C_hornet = 4900,
  F_14B = 7348,
  F_15C = 6103,
  F_16C_50 = 3249,
  F_5E_3 = 2046,
  J_11A = 9400,
  Ka_50 = 1450,
  L_39ZA = 823.2,
  M_2000C = 3165,
  MiG_19P = 1800,
  MiG_21Bis = 2280,
  MiG_29S = 3493,
  Mi_8MT = 1929,
  SA342L = 416.33,
  SA342M = 416.33,
  SA342Mistral = 416.33,
  Su_25T = 3790,
  Su_27 = 5590.18,
  Su_33 = 9500,
  UH_1H = 631
}

local desiredFuelFractions = {
  AJS37 = 1.0,
  AV8BNA = 1.0,
  A_10A = 0.4,
  A_10C = 0.4,
  C_101CC = 0.8,
  FA_18C_hornet = 0.5,
  F_14B = 0.5,
  F_15C = 0.2,
  F_16C_50 = 0.5,
  F_5E_3 = 1.0,
  J_11A = 0.5,
  Ka_50 = 0.5,
  L_39ZA = 0.82,
  M_2000C = 0.5,
  MiG_19P = 1.0,
  MiG_21Bis = 1.0,
  MiG_29S = 0.5,
  Mi_8MT = 0.4,
  SA342L = 0.4,
  SA342M = 0.4,
  SA342Mistral = 0.4,
  Su_25T = 0.7,
  Su_27 = 0.5,
  Su_33 = 0.5,
  UH_1H = 0.3,
}

common.loadMission(missionLua)

function setFuel(unit, route)
  if unit.skill ~= "Client" then
    return
  end
  key = string.gsub(unit.type, "-", "_")

  fuelCapacity = fuelCapacities[key]
  if fuelCapacity == nil then error("No fuelCapacity found for " .. key) end

  desiredFuelFraction = desiredFuelFractions[key]
  if desiredFuelFraction == nil then error("No desiredFuelFraction found for " .. key) end

  desiredFuel = fuelCapacity * desiredFuelFraction

  if unit.payload.fuel ~= desiredFuel then
    print("Setting fuel for " .. unit.type .. " named " .. unit.name .. " from " .. unit.payload.fuel .. " to " .. desiredFuel)
    unit.payload.fuel = desiredFuel
  end
end

common.iterUnits(setFuel, setFuel)


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
