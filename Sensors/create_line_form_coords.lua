function getInfo()
	return {
		fields = { "positions", "unit_ids" }
	}
end

local SpringGetTeamUnitsCounts= Spring.GetTeamUnitsCounts
local myTeamID = Spring.GetMyTeamID()
local SpringGetTeamUnits = Spring.GetTeamUnits

return function(
    leader_pos,
    wind_vector,
    spacing
)
    local positions = {}
    local unit_ids = {}
    local units = SpringGetTeamUnits(myTeamID)
    for i, unit_id in ipairs(units) do
        local offset = (i - 1) * spacing
        local pos = {
            leader_pos.x + offset * wind_vector.x,
            leader_pos.z + offset * wind_vector.z,
        }
        table.insert(positions, pos)
        table.insert(unit_ids,  unit_id)
    end

    return {
        positions = positions,
        unit_ids = unit_ids,
}
end
