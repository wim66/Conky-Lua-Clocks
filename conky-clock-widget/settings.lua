
-- Set the path to the scripts foder
package.path = "./scripts/?.lua"

Clock_Face_Color = "green" --options are pink/green/black


-- ##########################################################################



require 'clockface'
require 'text'
require 'clock'

function conky_main()
     conky_main_box()
     conky_draw_text()
     conky_draw_clock()


end

--[[
#########################
# conky-clock-widget    #
# by +WillemO @wim66    #
# v2.0 24-dec-17        #
#                       #
#########################
]]


