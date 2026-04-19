local sensorInfo = {
	name = "create_line_from_coords",
	desc = "Create perpendicular formation data from wind vector and spacing",
	author = "tomikkdyne",
	date = "2026-04-19",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo()
	return {
		fields = { "formation", "groupDefinition" }
	}
end

local SpringGetUnitDefID = Spring.GetUnitDefID

return function(
    wind_vector,
    spacing,
    leader_unit_name
)
    spacing = spacing or 30
    local formation = {}
    local groupDefinition = {}

    -- perpendicular direction
    local dirX = -wind_vector.z
    local dirZ = wind_vector.x

    local next_index = 2 -- reserve index 1 for leader

    for _, unit_id in ipairs(units) do
        local unit_name = UnitDefs[SpringGetUnitDefID(unit_id)].humanName
        if unit_name == leader_unit_name then
            formation[1] = Vec3(0, 0, 0)
            groupDefinition[unit_id] = 1
        else
            -- non leader units are offset
            local index = next_index
            local sideStep = math.ceil((index - 1) / 2)
            local sideSign = (index % 2 == 0) and 1 or -1
            local offset = sideSign * sideStep * spacing

            formation[index] = Vec3(
                dirX * offset,
                0,
                dirZ * offset
            )
            groupDefinition[unit_id] = index
            next_index = next_index + 1
        end
    end
    return {
        formation = formation,
        groupDefinition = groupDefinition,
    }
end