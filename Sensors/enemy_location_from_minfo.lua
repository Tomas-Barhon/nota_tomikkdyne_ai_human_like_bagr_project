local sensorInfo = {
    name = "enemy_location_from_minfo",
    desc = "Locate enemies from mission information",
    author = "tomikkdyne",
    date = "2026-05-12",
    license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo() return {fields = {"enemy_coords"}} end

return function(mission_info, debug)
    local debug = debug or false
    local enemy_coords = {}
    for _, enemy in ipairs(mission_info.enemyPositions) do
        enemy_coords[#enemy_coords + 1] = Vec3(enemy.x, enemy.y, enemy.z)
    end
    if debug then
        for _, coord in ipairs(enemy_coords) do
            Spring.MarkerAddPoint(coord.x, coord.y, coord.z, "Enemy Location")
        end
    end
    return enemy_coords
end