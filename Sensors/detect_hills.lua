local sensorInfo = {
    name = "detect_hills",
    desc = "Detect hills in the terrain",
    author = "tomikkdyne",
    date = "2026-05-12",
    license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = math.huge

function getInfo() return {fields = {"hills_coords"}} end

local function buildScanPoints(offset)
    -- build a grid of points covering the map to scan for hills
    local squareSize = Game.squareSize
    local mapDimsX = math.floor(Game.mapSizeX / squareSize)
    local mapDimsZ = math.floor(Game.mapSizeZ / squareSize)

    local points = {}
    for x = 0, mapDimsX - 1, offset do
        for z = 0, mapDimsZ - 1, offset do
            points[#points + 1] = Vec3(x * squareSize, 0, z * squareSize)
        end
    end
    return points
end

-- greedy pruning of points that are close to each other, keeping the highest one
local function prune_close_points(points, min_distance)
    min_distance = tonumber(min_distance) or 0

    local candidates = {}
    --add height to each point for sorting
    for _, point in ipairs(points) do
        candidates[#candidates + 1] = {
            x = point.x,
            z = point.z,
            y = Spring.GetGroundHeight(point.x, point.z)
        }
    end

    table.sort(candidates,
               function(left, right) return left.y > right.y end)

    local pruned = {}
    for _, candidate in ipairs(candidates) do
        local keep = true
        for _, keptPoint in ipairs(pruned) do
            local dx = candidate.x - keptPoint.x
            local dz = candidate.z - keptPoint.z
            local distance = math.sqrt(dx * dx + dz * dz)
            if distance < min_distance then
                keep = false
                break
            end
        end

        if keep then
            pruned[#pruned + 1] = Vec3(candidate.x, candidate.y, candidate.z)
        end
    end

    return pruned
end

return function(hill_threshold, smoke_grid_offset, prunning_dist, debug)
    local debug = debug or false
    local hills = {}
    local scannedPoints = buildScanPoints(smoke_grid_offset)
    for _, coord in ipairs(scannedPoints) do
        local x, z = coord.x, coord.z
        local height = Spring.GetGroundHeight(x, z)
        if height >= hill_threshold then
            hills[#hills + 1] = Vec3(x, height, z)
        end
    end
    hills = prune_close_points(hills, prunning_dist)
    for _, hill in ipairs(hills) do
        if debug then
            Spring.MarkerAddPoint(hill.x, hill.y, hill.z, "Hill")
        end
    end
    return hills
end
