function i_game()
	--game object--
	 g={
		total_milestones=0,
		status="", --running, win, lose
		scene="menu", --menu, select, game, summary
		start_t=t(),
		cur_t=0,
		end_t=0,
		max_bars=4,
		max_day_lines=16,
		bars={},    --all bars
		day_lines={},
		line_color=6,
		character='nathan',

		-- methods
		start_level=function()
			if (g.status!="running") then
				setup_milestones()
			end
			player.milestones=0
			g.scene="game"
			g.status="running"
			player.x=40
			player.y=60
		end,

		end_level=function(type)
			if (type == "win") then
				g.status="win"
				sfx(8)
			else
				g.status="lose"
				sfx(6)
			end
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
 end



platforms={
	yellow={
		x0=0,
		y0=100,
		x1=128,
		y1=110,
	}
}
-- where moving bars can render
bar_areas={30, 40, 50, 60, 70, 80, 90}

function move_bar(bar)
	bar.x0-=bar.speed
	bar.x1-=bar.speed
end

function gen_bar()
	local plats={}
	local min_width=20
	local max_width=120
	local bar_height=8
	local bar_y0=rnd(bar_areas)
	local bar_y1=bar_y0+bar_height
	local colors={1,2,3,4,5,6}
	local x0=cam.x+rnd_between(128, 200)

	if count(g.bars) > 1 then
		local last_bar = g.bars[count(g.bars)]

		-- if new bar is in the same area
		if last_bar.y0 == bar_y0 then
			x0=last_bar.x1+rnd_between(50, 90)
		else
			x0=rnd_between(last_bar.x1-rnd(16), last_bar.x1+90)
		end
	end


	local x1=x0+rnd_between(min_width,max_width)
end

function gen_day_line()
	local x=g.day_lines[#g.day_lines].x+16
	local y0=-128
	local y1=256

	add(g.day_lines, {x=x, y0=y0, y1=y1})
end


function u_game()
	g.cur_t=t()-g.start_t
	-- move day lines
	for k,day_line in ipairs(g.day_lines) do
		-- day_line.x-=
		if day_line.x < cam.x - 128 then
			del(g.day_lines, day_line)
		end

		if count(g.day_lines) < g.max_day_lines then
			gen_day_line()
		end
	end
end

function d_game()
	for k,day_line in ipairs(g.day_lines) do
		line(day_line.x, day_line.y0, day_line.x, day_line.y1, g.line_color)
	end
end
