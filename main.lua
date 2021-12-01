local cellSize  = 20 -- Width and height of cells.
local gridLines = {}
local grid      = {}
local borderSize = 2
local padding = 1
local dtotal = 0
local generation = 0
local speed = 2 -- Number of times in a second to update the grid.
local running = false
local windowWidth, windowHeight = 720, 600
local start = love.timer.getTime()

local success = love.window.setMode( windowWidth, windowHeight, {})

if not success then
  print("Failed to set window mode.")
  return
end

-- Vertical lines.
for x = 0, windowWidth, cellSize do
  local line = {x, 0, x, windowHeight}
  table.insert(gridLines, line)
end
-- Horizontal lines.
for y = 0, windowHeight, cellSize do
  local line = {0, y, windowWidth, y}
  table.insert(gridLines, line)
end

for y = 0, windowHeight/cellSize do
  grid[y] = {}
  for x = 0, windowWidth/cellSize do
    local n = love.math.random()
    if n < 0.5 then
      grid[y][x] = 1
    else
      grid[y][x] = 0
    end
  end
end

function love.draw()
  love.graphics.setBackgroundColor(1, 1, 1)
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.setLineWidth(borderSize)

  for _, line in ipairs(gridLines) do
    love.graphics.line(line)
  end
  for y = 0, #grid do
    for x = 0, #grid[y] do
      if grid[y][x] == 1 then
        love.graphics.setColor(0, 0, 0)
      else
        love.graphics.setColor(1, 1, 1)
      end
      love.graphics.rectangle("fill", x*cellSize + padding, y*cellSize + padding, cellSize - padding*2, cellSize - padding*2)
    end
  end
  local result = love.timer.getTime() - start
  if result < 5 then
    love.graphics.setColor(3/255, 113/255, 218/255)
    love.graphics.print("Generation: " .. generation, 10, 3)
    love.graphics.print("space - Pause/Play. escape - Exit", 10, 23)
    love.graphics.print("r - Randomize. c - Clear grid", 10, 43)
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "space" then
    running = not running
  end
  if key == "c" then
    generation = 0
    for y = 0, #grid do
      for x = 0, #grid[y] do
        grid[y][x] = 0
      end
    end
  end
  if key == "r" then
    for y = 0, #grid do
      for x = 0, #grid[y] do
        local n = love.math.random()
        if n < 0.5 then
          grid[y][x] = 1
        else
          grid[y][x] = 0
        end
      end
    end
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    x = math.floor(x/cellSize)
    y = math.floor(y/cellSize)
    if not running then
      if grid[y][x] == 1 then
        grid[y][x] = 0
      else
        grid[y][x] = 1
      end
    end
  end
end

function love.mousemoved(_)
  start = love.timer.getTime()
end

local function countNeighbors(x, y)
  local count = 0
  for i = -1, 1 do
    for j = -1, 1 do
      if not (i == 0 and j == 0) then
        local nx = x + i
        local ny = y + j
        if nx < 0 then
          nx = #grid[y] + nx
        elseif nx > #grid[y] then
          nx = nx - #grid[y]
        end
        if ny < 0 then
          ny = #grid + ny
        elseif ny > #grid then
          ny = ny - #grid
        end
        if grid[ny][nx] == 1 then
          count = count + 1
        end
      end
    end
  end
  return count
end

function love.update(dt)
   dtotal = dtotal + dt
   if dtotal >= 1/speed then
      dtotal = dtotal - 1/speed
      if running then
        local newGrid = {}
        for y = 0, #grid do
          newGrid[y] = {}
          for x = 0, #grid[y] do
            local neighbors = countNeighbors(x, y)
            if grid[y][x] == 1 then
              if neighbors < 2 or neighbors > 3 then
                newGrid[y][x] = 0
              else
                newGrid[y][x] = 1
              end
            else
              if neighbors == 3 then
                newGrid[y][x] = 1
              else
                newGrid[y][x] = 0
              end
            end
          end
        end
        grid = newGrid
        generation = generation + 1
      end
   end
 end

