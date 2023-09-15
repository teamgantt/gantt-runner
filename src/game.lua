function i_game()
	week_days={"mon", "tue", "wed", "thu", "fri"}
	--game object--
	 g={
		total_milestones=0,
		status="", --running, win, lose
		scene="menu", --menu, select, game, summary, stats
		level=1,
		levels={},
		start_t=t(),
		cur_t=0,
		end_t=0,
		max_bars=4,
		max_day_lines=128,
		bars={},    --all bars
		day_lines={},
		days={},
		line_color=6,
		character='nathan',

		-- methods
		start_level=function(level)
			g.end_t=0
			g.cur_t=0
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
				stats:update('total_wins', 1)
			else
				g.status="lose"
				sfx(6)
				stats:update('total_falls', 1)
			end
			player.dx=0 -- ensure player stops
			g.end_t = g.cur_t
			player.score=g:calculate_score()
			g.scene="summary"
			stats:update('total_points', player.score)
			stats:update('total_runs', 1)
			stats:update('total_jumps', player.jumps)
			stats:update('milestones', player.milestones)
			stats:update('total_time', g.cur_t)
			if (g.character == 'john') then
				stats:update('john_runs', 1)
			else
				stats:update('nathan_runs', 1)
			end
			stats:store_all()
		end,

		calculate_score=function(self)

			local i = ceil(player.milestones * (1/g.end_t) * 1000)

			if (player.milestones > 0 and player.milestones==g.total_milestones) then
				i+=3000 --milestone bonus for getting all milestones
			end

			-- subtract points per second
			i-=(self.cur_t*10)

			-- add points per milestone
			i+=(player.milestones*100)

			-- subtract points per jump
			i-=(player.jumps*10)

			if (i < 0) then
				i=0
			end

			return flr(i)
		end
	 }

	 -- day lines
	 for i=1,g.max_day_lines do
		 local x=cam.x+16*i
		 local y0=cam.y+0
		 local y1=cam.y+128
		 add(g.day_lines, {x=x, y0=y0, y1=y1})

		 -- add days of week to the day lines
		 local day=week_days[(i-1)%5+1]
		 add(g.days, {x=x+3, y=cam.y+2, day=day})
	 end

	 g.levels[1] = level(0,0,128,16,10,60,0,7)
	 g.levels[2] = level(0,16,128,16,10,40,128,7)
	 g.levels[3] = level(0,32,128,16,10,30,128*2,7)
 end

function u_game()
	g.cur_t=t()-g.start_t --elapsed time

	-- update the current level
	g.levels[g.level]:update()
end

function d_game()
	 -- draw bg
	 cls()
	 rectfill(cam.x,cam.y,cam.x+128, cam.y+128, g.levels[g.level].color_bg)

	for k,day_line in ipairs(g.day_lines) do
		line(day_line.x, day_line.y0, day_line.x, day_line.y1, g.line_color)
	end

	-- draw days of week
	for k,day in ipairs(g.days) do
		print(day.day, day.x, day.y, g.line_color)
	end

	-- day horizontal line
	line(cam.x, cam.y+8, cam.x+128, cam.y+8, g.line_color)

	g.levels[g.level]:draw()
end
