function i_gantt()
	--game object--
	 g={
		 max_onscreen=3, --bars on screen
		 bars={},    --all bars
		 day_lines={}
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
bar_areas={50, 60, 70, 80}

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
	local x0=cam.x+rnd_between(128, 200)
	local x1=x0+rnd_between(min_width,max_width)
  local colors={1,2,3,4,5,6}

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


function u_gantt()
 	--move bars
	for idx,bar in ipairs(g.bars) do
		move_bar(bar)
		-- Cleanup
		if bar.speed != 0 and bar.x1 < player.x - 80 then
			del(g.bars, bar)
		end
	end

	local gap_limit=48
	for k,v in ipairs(g.bars) do
		if v.x1 > gap_limit and count(g.bars) < g.max_onscreen then
			gen_bar()
		end
	end
end

function d_gantt()
	for k,bar in ipairs(g.bars) do
		rectfill(bar.x0,bar.y0,bar.x1,bar.y1,bar.color)
		rect(bar.x0,bar.y0,bar.x1,bar.y1,bar.stroke)
	end
end
