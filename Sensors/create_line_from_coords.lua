function getInfo()
	return {
		fields = { "formation", "groupDefintion" }
	}
end

local SpringGetTeamUnits = Spring.GetTeamUnits
local myTeamID = Spring.GetMyTeamID()

return function(
    wind_vector,
    spacing
)
    local formation = {}
    local groupDefintion = {}

    local units = SpringGetTeamUnits(myTeamID)

    -- normalize wind and invert (against wind)
    local length = math.sqrt(wind_vector.x^2 + wind_vector.z^2)
    if length == 0 then length = 1 end

    local dirX = -wind_vector.x / length
    local dirZ = -wind_vector.z / length

    for i, unit_id in ipairs(units) do
        -- formation offset (relative to leader)
        local offset = (i - 1) * spacing

        formation[i] = Vec3(
            dirX * offset,
            0,
            dirZ * offset
        )

        groupDefintion[unit_id] = i
    end

    return {
        formation = formation,
        groupDefintion = groupDefintion,
    }
end
