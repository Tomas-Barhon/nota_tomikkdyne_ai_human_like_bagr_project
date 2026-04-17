function getInfo()
	return {
		fields = { "formation", "groupDefinition" }
	}
end

local SpringGetTeamUnits = Spring.GetTeamUnits
local SpringGetUnitDefID = Spring.GetUnitDefID
local myTeamID = Spring.GetMyTeamID()

return function(
    unit_names,
    wind_vector,
    spacing
)
    local formation = {}
    local groupDefinition = {}

    local units = SpringGetTeamUnits(myTeamID)

    -- normalize wind
    local length = math.sqrt(wind_vector.x^2 + wind_vector.z^2)
    if length == 0 then length = 1 end

    local dirX = -wind_vector.x / length
    local dirZ = -wind_vector.z / length

    local index = 1

    local nameLookup = {}
    for _, name in ipairs(unit_names) do
        nameLookup[name] = true
    end

    local unitsByName = {}
    for _, unit_id in ipairs(units) do
        local defID = SpringGetUnitDefID(unit_id)

        if defID then
            local def = UnitDefs[defID]

            if def and nameLookup[def.humanName] and def.canMove then
                if not unitsByName[def.humanName] then
                    unitsByName[def.humanName] = {}
                end

                unitsByName[def.humanName][#unitsByName[def.humanName] + 1] = unit_id
            end
        end
    end

    local orderedUnits = {}
    for _, name in ipairs(unit_names) do
        local unitList = unitsByName[name]
        if unitList then
            for _, unit_id in ipairs(unitList) do
                orderedUnits[#orderedUnits + 1] = unit_id
            end
        end
    end

    for _, unit_id in ipairs(orderedUnits) do
        local offset = 0
        if index > 1 then
            local sideStep = math.ceil((index - 1) / 2)
            local sideSign = (index % 2 == 0) and 1 or -1
            offset = sideSign * sideStep * spacing
        end

        formation[index] = Vec3(
            dirX * offset,
            0,
            dirZ * offset
        )

        groupDefinition[unit_id] = index
        index = index + 1
    end

    return {
        formation = formation,
        groupDefinition = groupDefinition,
    }
end