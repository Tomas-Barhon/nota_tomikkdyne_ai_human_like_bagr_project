local sensorInfo = {
	name = "detect_hills",
	desc = "Detect hills in the terrain",
	author = "tomikkdyne",
	date = "2026-05-12",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0

function getInfo()
	return {
        fields = { "hills_coords" }
	}
end

local function buildScanPoints(
    offset
)
    -- build a grid of points covering the map to scan for hills
    local squareSize = Game.squareSize
    local mapDimsX = math.floor(Game.mapSizeX / squareSize)
    local mapDimsZ = math.floor(Game.mapSizeZ / squareSize)

    local points = {}
    for x = 0, mapDimsX - 1 do
        for z = 0, mapDimsZ - 1 do
            points[#points + 1] = {
                x = (x + offset) * squareSize,
                z = (z + offset) * squareSize,
            }
        end
    end
    return points
end

local function go_uphill(x, z, offset)
    local height = Spring.GetGroundHeight(x, z)
    local neighbors = {
        { x = x - offset, z = z, height = Spring.GetGroundHeight(x - offset, z) },
        { x = x + offset, z = z, height = Spring.GetGroundHeight(x + offset, z) },
        { x = x, z = z - offset, height = Spring.GetGroundHeight(x, z - offset) },
        { x = x, z = z + offset, height = Spring.GetGroundHeight(x, z + offset) },
    }
    
    -- Check if current position is a hill top
    local isHillTop = true
    for _, neighbor in ipairs(neighbors) do
        if neighbor.height ~= height then
            isHillTop = false
            break
        end
    end
    
    if isHillTop then
        return { x = x, z = z }
    end
    
    -- Find higher neighbor and recurse
    for _, neighbor in ipairs(neighbors) do
        if neighbor.height > height then
            return go_uphill(neighbor.x, neighbor.z, offset)
        end
    end
end

return function(smoke_grid_offset)
    local hills = {}

    for _, coord in ipairs(buildScanPoints(smoke_grid_offset)) do
        local x, z = coord.x, coord.z
        local height = Spring.GetGroundHeight(x, z)
        if height > 0 then
            local hillTop = go_uphill(x, z, smoke_grid_offset)
            if hillTop then
                hills[#hills + 1] = hillTop
            end
        end
    end
return {
        hills_coords = hills,
    }
end