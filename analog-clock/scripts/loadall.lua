-- loadall.lua
-- by @wim66
-- v4.1 May 2, 2025

-- Set the path to the scripts folder
package.path = "./scripts/?.lua"

-- Import modules
local success, background = pcall(require, 'background')
if not success then print("Error loading background module: "..background) end

local success, clock = pcall(require, 'clock')
if not success then print("Error loading clock module: "..clock) end

-- Main function to draw Conky elements
function conky_main()
    if background then conky_draw_background() end
    if clock then conky_analog_clock() end
end
