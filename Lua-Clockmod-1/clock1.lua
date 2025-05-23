--[[
Clock Rings Mod by @wim66 2014
Updated April 26 2025

]]
local status, cairo_xlib = pcall(require, 'cairo_xlib')

if not status then
    cairo_xlib = setmetatable({}, {
        __index = function(_, k)
            return _G[k]
        end
    })
end
--========================================================================================================
settings_table = {

	{
		name='time',
		arg='%S',
		max=60,
		bg_colour=0x00FFFF,
		bg_alpha=1,
		fg_colour=0x264C4C,
		fg_alpha=1,
		x=220, y=220,
		radius=68,
		thickness=8,
		start_angle=0,
		end_angle=360
	},
{
		name='time',
		arg='%M.%S',
		max=60,
		bg_colour=0x264C4C,
		bg_alpha=1,
		fg_colour=0x00FFFF,
		fg_alpha=1,
		x=220, y=220,
		radius=52,
		thickness=8,
		start_angle=0,
		end_angle=360
	},
{
		name='time',
		arg='%I.%M',
		max=12,
		bg_colour=0x00FFFF,
		bg_alpha=1,
		fg_colour=0x264C4C,
		fg_alpha=1,
		x=220, y=220,
		radius=36,
		thickness=8,
		start_angle=0,
		end_angle=360
	},
	{
		name='exec',
		arg='./uptime.sh',
		max=24,
		bg_colour=0x00FFFF,
		bg_alpha=0.15,
		fg_colour=0x00FFFF,
		fg_alpha=1,
		x=220, y=220,
		radius=20,
		thickness=8,
		start_angle=0,
		end_angle=360
	},
}

--==========================================================================================================================

-- Use these settings to define the origin and extent of your clock.

clock_r=190

-- "clock_x" and "clock_y" are the coordinates of the centre of the clock, in pixels, from the top left of the Conky window.

clock_x=220
clock_y=220

-- Colour & alpha of the clock hands

minute_colour=0xCD00CD
minute_alpha=1

hour_colour=0xCD00CD
hour_alpha=1

-- Do you want to show the seconds hand?

show_seconds=false
seconds_colour=0xFF0000
seconds_alpha=1

--==========================================================================================================================

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
	local w,h=conky_window.width,conky_window.height

	local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
	local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

	local angle_0=sa*(2*math.pi/360)-math.pi/2
	local angle_f=ea*(2*math.pi/360)-math.pi/2
	local t_arc=t*(angle_f-angle_0)

	-- Draw background ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
	cairo_set_line_width(cr,ring_w)
	cairo_stroke(cr)

	-- Draw indicator ring

	cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
	cairo_stroke(cr)
end

function draw_clock_hands(cr,xc,yc)
	local secs,mins,hours,secs_arc,mins_arc,hours_arc
	local xh,yh,xm,ym,xs,ys

	secs=os.date("%S")
	mins=os.date("%M")
	hours=os.date("%I")

	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins+secs_arc/60
	hours_arc=(2*math.pi/12)*hours+mins_arc/12

	-- Draw hour hand

	xh=xc+0.7*clock_r*math.sin(hours_arc)
	yh=yc-0.7*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)

	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,3)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(hour_colour,hour_alpha))
	cairo_stroke(cr)

	-- Draw minute hand

	xm=xc+clock_r*math.sin(mins_arc)
	ym=yc-clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)

	cairo_set_line_width(cr,3)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(minute_colour,minute_alpha))
	cairo_stroke(cr)

	-- Draw seconds hand

	if show_seconds then
		xs=xc+clock_r*math.sin(secs_arc)
		ys=yc-clock_r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)
	cairo_set_source_rgba(cr,rgb_to_r_g_b(seconds_colour,seconds_alpha))
		cairo_set_line_width(cr,2)
		cairo_stroke(cr)
	end
end

function conky_clock_rings()
	local function setup_rings(cr,pt)
		local str=''
		local value=0

		str=string.format('${%s %s}',pt['name'],pt['arg'])
		str=conky_parse(str)

		value=tonumber(str)
		if value == nil then value = 0 end
		pct=value/pt['max']

		draw_ring(cr,pct,pt)
	end

	-- Check that Conky has been running for at least 5s

	if conky_window==nil then return end
	local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)

	local cr=cairo_create(cs)	

	local updates=conky_parse('${updates}')
	update_num=tonumber(updates)

	if update_num>5 then
		for i in pairs(settings_table) do
			setup_rings(cr,settings_table[i])
		end
	end

	draw_clock_hands(cr,clock_x,clock_y)
end
