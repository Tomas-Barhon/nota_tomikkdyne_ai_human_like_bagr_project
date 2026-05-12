local sensorInfo = {
    name = "locate_enemy_from_mission",
    desc = "Locate enemies from mission objectives",
    author = "tomikkdyne",
    date = "2026-05-12",
    license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo() return {fields = {"enemy_coords"}} end

return function(mission_objectives)
    local enemy_coords = {}
    for _, objective in ipairs(mission_objectives) do
        if objective.type == "destroy" and objective.target then
            enemy_coords[#enemy_coords + 1] = {
                x = objective.target.x,
                z = objective.target.z
            }
        end
    end
    return {enemy_coords = enemy_coords}
end