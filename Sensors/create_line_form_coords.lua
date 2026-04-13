function getInfo()
	return {
		fields = { "positions", "unit_ids" }
	}
end

local SpringGetTeamUnitsCounts= Spring.GetTeamUnitsCounts
local myTeamID = Spring.GetMyTeamID()

return function(
    leader_pos,
    wind_vector,
    spacing
)
	local unitsCounts = SpringGetTeamUnitsCounts(myTeamID)
    local positions = {}
    local unit_ids = {}
    local units = Spring.GetTeamUnits(myTeamID)
    for i = ipairs(units) do
        local offset = (i - 1) * spacing
        local pos = {
            leader_pos.x + offset * wind_vector.x,
            leader_pos.z + offset * wind_vector.z,
        }
        table.insert(positions, pos)
        table.insert(unit_ids,  units[i])
    end

    return {
        positions = positions,
        unit_ids = unit_ids,
}
end
