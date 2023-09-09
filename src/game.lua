function i_game()
	--game object--
	 g={
		total_milestones=0,
		status="", --running, win, lose
		scene="menu", --menu, select, game, summary
		level=1,
		levels={},
		start_t=t(),
		cur_t=0,
		end_t=0,
		max_bars=4,
		max_day_lines=128,
		bars={},    --all bars
		day_lines={},
		line_color=6,
		character='john',

		-- methods
		start_level=function(level)
			g.level=level
			g.levels[level]:setup()
			g.total_milestones=count(g.levels[level].milestones)
			extcmd('rec')
			player.milestones=0
			g.scene="game"
			g.status="running"
			g.start_t=t()
			player.jumps=0
			player.x=g.levels[level].player_x
			player.y=g.levels[level].player_y

			menuitem(3, "save run as gif",
			function()
				extcmd("set_filename", "latest_ganttrunner_run.gif")
				extcmd("video")
			end
		)
		end,

		end_level=function(type)
			if (type == "win") then
				g.status="win"
				sfx(8)
			else
				g.status="lose"
				sfx(6)
			end
			player.dx=0 -- ensure player stops
			g.end_t = g.cur_t
			g.scene="summary"
		end,
	 }

	 -- day lines
	 for i=1,g.max_day_lines do
		 local x=cam.x+16*i
		 local y0=-128
		 local y1=256
		 add(g.day_lines, {x=x, y0=y0, y1=y1})
	 end

	 g.levels[1] = level(0,0,128,16,10,60,0,7)
	 g.levels[2] = level(0,16,128,16,10,40,128,7)
	 g.levels[3] = level(0,32,128,16,10,30,128*2,7)
 end

function gen_day_line()
	local x=g.day_lines[#g.day_lines].x+16
	local y0=-128
	local y1=256

	add(g.day_lines, {x=x, y0=y0, y1=y1})
end


function u_game()
	g.cur_t=t()-g.start_t --elapsed time

	-- update the current level
	g.levels[g.level]:update()
end

function d_game()
	 -- draw bg

	 rectfill(cam.x,cam.y,cam.x+128, cam.y+128, g.levels[g.level].color_bg)

	for k,day_line in ipairs(g.day_lines) do
		line(day_line.x, day_line.y0, day_line.x, day_line.y1, g.line_color)
	end

	g.levels[g.level]:draw()

	if debug then
		print("total milestones "..count(g.levels[g.level].milestones), cam.x, cam.y)
	end
end
