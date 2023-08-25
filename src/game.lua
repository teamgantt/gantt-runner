function i_game()
	--game object--
	 g={
		scene="select",
		max_bars=4,
		max_day_lines=16,
		bars={},    --all bars
		day_lines={},
		line_color=6,
		character='nathan'
	 }

	 -- stationary starting block, temp
	 add(g.bars, {
		 x0=0,
		 y0=100,
		 x1=128,
		 y1=110,
		 color=10,
		 stroke=9,
		 speed=0
	 })

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


	add(g.bars, {
		x0=x0,
		y0=bar_y0,
		x1=x1,
		y1=bar_y1,
		color=rnd(colors),
		stroke=9,
		speed=1
	})
end

function gen_day_line()
	local x=g.day_lines[#g.day_lines].x+16
	local y0=-128
	local y1=256

	add(g.day_lines, {x=x, y0=y0, y1=y1})
end


function u_game()
 	--move bars
	for idx,bar in ipairs(g.bars) do
		move_bar(bar)
		-- Cleanup
		if bar.speed != 0 and bar.x1 < cam.x - 80 then
			del(g.bars, bar)
		end
	end

	-- generate new bars
	local last_bar = g.bars[count(g.bars)]
	
	if count(g.bars) == 1 then
		gen_bar()
	end
	if last_bar.x1 < cam.x + 128 and count(g.bars) < g.max_bars then
		gen_bar()
	end

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

	for k,bar in ipairs(g.bars) do
		rectfill(bar.x0,bar.y0,bar.x1,bar.y1,bar.color)
		rect(bar.x0,bar.y0,bar.x1,bar.y1,bar.stroke)
	end
end
