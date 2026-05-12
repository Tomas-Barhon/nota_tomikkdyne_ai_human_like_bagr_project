local sensorInfo = {
    name = "detect_hills",
    desc = "Detect hills in the terrain",
    author = "tomikkdyne",
    date = "2026-05-12",
    license = "notAlicense"
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo() return {fields = {"hills_coords"}} end

local function buildScanPoints(offset)
    -- build a grid of points covering the map to scan for hills
    local squareSize = Game.squareSize
    local mapDimsX = math.floor(Game.mapSizeX / squareSize)
    local mapDimsZ = math.floor(Game.mapSizeZ / squareSize)

    local points = {}
    for x = 0, mapDimsX - 1, offset do
        for z = 0, mapDimsZ - 1, offset do
            points[#points + 1] = {x = x * squareSize, z = z * squareSize}
        end
    end
    return points
end

local function go_uphill(x, z, offset, tollerance)
    local height = Spring.GetGroundHeight(x, z)
    local neighbors = {
        {x = x - offset, z = z, height = Spring.GetGroundHeight(x - offset, z)},
        {x = x + offset, z = z, height = Spring.GetGroundHeight(x + offset, z)},
        {x = x, z = z - offset, height = Spring.GetGroundHeight(x, z - offset)},
        {x = x, z = z + offset, height = Spring.GetGroundHeight(x, z + offset)}
    }

    -- Check if current position is a hill top
    local isHillTop = true
    local higherNeighbor = nil

    -- Find higher neighbor if not return current position as hill top
    for _, neighbor in ipairs(neighbors) do
        if neighbor.height > height + tollerance then
            higherNeighbor = neighbor
            isHillTop = false
            break
        elseif math.abs(neighbor.height - height) > tollerance then
            isHillTop = false
        end
    end

    if isHillTop then
        return {x = x, z = z}
    elseif higherNeighbor then
        return go_uphill(higherNeighbor.x, higherNeighbor.z, offset, tollerance)
    end
end

-- greedy pruning of points that are close to each other, keeping the highest one
local function prune_close_points(points, min_distance)
    min_distance = tonumber(min_distance) or 0

    local candidates = {}
    for _, point in ipairs(points) do
        candidates[#candidates + 1] = {
            x = point.x,
            z = point.z,
            height = Spring.GetGroundHeight(point.x, point.z)
        }
    end

    table.sort(candidates,
               function(left, right) return left.height > right.height end)

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
            pruned[#pruned + 1] = {x = candidate.x, z = candidate.z}
        end
    end

    return pruned
end

return function(hill_threshold, smoke_grid_offset, hill_search_offset,
                prunning_distance, height_tollerance, debug)
    local debug = debug or false
    local hills = {}
    local scannedPoints = buildScanPoints(smoke_grid_offset)
    for _, coord in ipairs(scannedPoints) do
        local x, z = coord.x, coord.z
        local height = Spring.GetGroundHeight(x, z)
        if height > hill_threshold then
            hills[#hills + 1] = {x = x, z = z}
        end
    end
    local prunedHills = prune_close_points(hills, prunning_distance)

    local finalHills = {}
    for _, hill in ipairs(prunedHills) do
        local uphillPoint = go_uphill(hill.x, hill.z, hill_search_offset,
                                      height_tollerance)
        if uphillPoint then
            finalHills[#finalHills + 1] = uphillPoint
            if debug then
                Spring.MarkerAddPoint(uphillPoint.x, Spring.GetGroundHeight(
                                      uphillPoint.x, uphillPoint.z),
                                  uphillPoint.z, "FinalHillTop", true)
            end
        end
    end
    return {hills_coords = finalHills}
end
