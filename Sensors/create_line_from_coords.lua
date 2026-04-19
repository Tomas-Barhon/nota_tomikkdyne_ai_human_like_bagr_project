
function getInfo()
	return {
		fields = { "formation", "groupDefinition" }
	}
end


return function(
    wind_vector,
    spacing
)

    local formation = {}
    local groupDefinition = {}

    -- perpendicular direction
    local dirX = -wind_vector.z
    local dirZ = wind_vector.x

    local index = 1

    for _, unit_id in ipairs(units) do
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