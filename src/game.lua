function i_game()
	week_days={"mon", "tue", "wed", "thu", "fri"}
	--game object--
	 g={
    milestone_pts={};
		total_milestones=0,
		status="", --running, win, lose
		scene="menu", --menu, select, game, summary, procedural
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
		start_level=function(lvl)
			extcmd('rec')
			cam.x=0
			g.end_t=0
			g.cur_t=0
			g.level=lvl
			g.total_milestones=0

			if (lvl == 4) then
				g.scene="procedural"
        srand(global_seed)
				g.levels[4] = level(0,0,128,16,10,10,0,7)
				g.levels[lvl]:setup()
			else
			  g.scene="game"
				g.levels[1] = level(0,0,128,16,10,60,0,7)
				g.levels[2] = level(0,16,128,16,10,40,128,7)
				g.levels[3] = level(0,32,128,16,10,30,128*2,7)
				g.levels[lvl]:setup()
				g.total_milestones=count(g.levels[lvl].milestones)
			end

			player.milestones=0
			g.status="running"
			g.start_t=t()
			player.jumps=0
			player.x=g.levels[lvl].player_x
			player.y=g.levels[lvl].player_y

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
			player.dy=0
			g.end_t = g.cur_t
			player.score=g:calculate_score()
			g.scene="summary"
			g.levels[g.level]:tear_down()
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
 end

function u_game()
	g.cur_t=t()-g.start_t --elapsed time

	-- update the current level
	g.levels[g.level]:update()

	-- animate milestone pts
	for k,mile in pairs(g.milestone_pts) do
		mile.y -= 1
		mile.f += 1
		if (mile.f > 10) then
			del(g.milestone_pts, mile)
		end
	end
end

function d_game()
	-- draw bg
	cls()
	rectfill(cam.x,cam.y,cam.x+128, cam.y+128, g.levels[g.level].color_bg)

	g.levels[g.level]:draw()

	-- draw milestone pts
	for k,mile in ipairs(g.milestone_pts) do
		print('100', mile.x, mile.y, 9)
	end
end
