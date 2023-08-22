pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--gantt runner
--by tg devs

function _init()
	debug=true
	cam={x=0,y=0}
	i_player()
	i_gantt()
	i_milestone_anims()
	i_particles()
end

function _update()
	u_player()
	u_gantt()
	u_milestone_anims()
	u_fx()
end

function _draw()
	cls(12)
	d_gantt()
	d_milestone_anims()
	camera_follow()
	d_fx()
	d_player()

	local screen_top=cam.y+128/2
	local screen_bottom=cam.y+128

	spr(42, cam.x+110, cam.y+2, 2,2) --tg logo


	--debug stuff
	if (debug) then
		print("on ground: "..tostr(player.on_platform)..' status:'..player.move, cam.x, cam.y, 9)
		print("dy:"..tostr(player.dy)..' dx:'..tostr(player.dx),cam.x, cam.y+10,7)
		print("player.x:"..flr(player.x), cam.x, cam.y+20, 7)
		print("player.y:"..flr(player.y), cam.x, cam.y+30, 7)
		-- print("bars: "..count(g.bars))
	end


end

function camera_follow()
	cam.x=player.x-60
 	cam.y=player.y-60

	cam.x=mid(0, cam.x, 896)
	cam.y=mid(0, cam.y, 128)

	camera(cam.x, cam.y)
end

-->8
--john
function i_player()
	gravity=0.5
	friction=.75
	player={
		-- player stats
		milestones=0,

		-- player physics
		boost=6,
		acc=0.5,
		dx=0,
		dy=0,
		max_dx=4,
		max_dy=4,

		-- player state
		flip_x=false,
		x=59,
		y=59,
		feet_x=0,
		feet_y=0,
		on_platform=false,
		move='idle', -- idle, run, sprint

		-- sfx
		sfx_jump=0,
		sfx_land=1,

		-- sprites
		idle_s=32,
		falling_s=38,
		jumping_s=40,
	}
	--player anims
	run_anim={
		f=1,
		frames={34,36,34},
		cur_s=34,
		timing=.4
	}
end

function u_player()
	player.move='idle'
	player.dx*=friction


	--controls
	if (btn(⬅️)) then
		player.dx-=player.acc
		player.flip_x=true
		-- player.move='run'
		player.feet_x=player.x+8
		if (player.on_platform) then player.move='run' end
	end -- left

	if (btn(➡️)) then
		player.dx+=player.acc
		player.flip_x=false
		-- player.move='run'
		player.feet_x=player.x
		if (player.on_platform) then player.move='run' end
	end -- right

	if (btn(🅾️) ) then --speed boost
		player.dx*=2
		player.move='sprint'
		friction=.5
	else
		friction=.75 --reset friction
	end

	if (btn(❎) and player.on_platform == true) then --jump
		player.dy-=player.boost
		sfx(player.sfx_jump)
	end -- X

	--limit left/right speed
	player.dx=mid(-player.max_dx,player.dx,player.max_dx)

	--limit fall speed
	if (player.dy>0) then
		player.dy=mid(-player.max_dy,player.dy,player.max_dy)
	end

	--apply dx and dy to player position
	player.x+=player.dx
	player.y+=player.dy


	--if run off screen warp to other side
	--temp feature
	if (player.x > 896) then player.x=-8 end
	if (player.x < -8) then player.x=128 end

	-- player falls, reset
	if (player.y > 120) then
		player.x=-8
		player.y=0
	end


 --animate player run
 if run_anim.f >= count(run_anim.frames) then
		run_anim.f = 1
	end

	--running animations
	if (player.move != 'idle') and player.on_platform then
		--handle run animation
		run_anim.f=run_anim.f+run_anim.timing

		if player.move == 'sprint' then
			dust(player.feet_x,player.feet_y,1,{6,7},4)
		end
	else
		run_anim.f=1
	end

	--check for collision with platform
	if (plat_collide(player)) then
		player.on_platform=true
		player.dy=0

	else
		player.on_platform=false
		player.dy+=gravity
	end

	--update feet pos
	player.feet_y=player.y+16
	player.feet_x=player.x+8
end

function d_player()
	if ((player.move=='run' or player.move=='sprint') and player.on_platform) then
		spr(run_anim.frames[flr(run_anim.f)], player.x, player.y, 2, 2, player.flip_x)
	elseif (player.dy > 0) then
		spr(player.falling_s, player.x, player.y, 2, 2, player.flip_x)
	elseif (player.dy < 0) then
		spr(player.jumping_s, player.x, player.y, 2, 2, player.flip_x)
	else --idle
		spr(flr(player.idle_s), player.x, player.y, 2, 2, player.flip_x)
	end
end
-->8
--gantt bars

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
	local x0=player.x+rnd_between(30, 50)
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


--game loop funcs
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

-->8
--collide check

function plat_collide(p)
	-- check for collision with platform
	if (p.dy < 0) then --moving upwards
		return false
	end

	for k,bar in ipairs(g.bars) do
		if player.x+8 >= bar.x0 and player.x <= bar.x1 then
			if player.feet_y >= bar.y0 and player.feet_y <= bar.y1 then
				p.y=bar.y0-16
				if (player.on_platform == false) then
					sfx(player.sfx_land)
					dust(player.feet_x,player.feet_y,2,{5,6,7},2)
				end

				p.on_platform=true
				-- keep player on platform
				if (bar.speed > 0) then
					p.x-=bar.speed
				end
				return true
			end
		end
	end
	return false
end
-->8
--milestone

--TODO: put this somewhere else
function i_milestone_anims()
	mile={
		cur_s=18,
		s_min=18, --start sprite
		s_max=25, --end sprite
		timing=.2,
		x=60,
		y=60
	}
end

function u_milestone_anims()
 --animate milestone
 mile.cur_s=mile.cur_s+mile.timing

 if mile.cur_s >= mile.s_max+1 then
 	mile.cur_s = mile.s_min
 end

end


function d_milestone_anims()
	spr(flr(mile.cur_s), mile.x, mile.y)
end

function rnd_between(min, max)
	return flr(rnd(max-min+1))+min
end

-->8
--particles

function i_particles()
    --particles
    effects = {}

    --effects settings
    explode_size = 5
    explode_colors = {8,9,6,5}
    explode_amount = 5

    --sfx
    -- trail_sfx = 0
    -- explode_sfx = 1
    -- fire_sfx = 2

end

function add_fx(x,y,die,dx,dy,grav,grow,shrink,r,c_table)
    local fx={
        x=x,
        y=y,
        t=0,
        die=die,
        dx=dx,
        dy=dy,
        grav=grav,
        grow=grow,
        shrink=shrink,
        r=r,
        c=0,
        c_table=c_table
    }
    add(effects,fx)
end

function u_fx()
    for fx in all(effects) do
        --lifetime
				fx.t+=1
				if fx.t>fx.die then del(effects,fx) end

        --color depends on lifetime
        if fx.t/fx.die < 1/#fx.c_table then
					fx.c=fx.c_table[1]
				elseif fx.t/fx.die < 2/#fx.c_table then
						fx.c=fx.c_table[2]
				elseif fx.t/fx.die < 3/#fx.c_table then
						fx.c=fx.c_table[3]
				else
						fx.c=fx.c_table[4]
				end

        --physics
				if fx.grav then fx.dy+=.25 end
				if fx.grow then fx.r+=.075 end
				if fx.shrink then fx.r-=.075 end

        --move
				fx.x+=fx.dx
				fx.y+=fx.dy
    end
end

function d_fx()
    for fx in all(effects) do
        --draw pixel for size 1, draw circle for larger
        if fx.r<=1 then
            pset(fx.x,fx.y,fx.c)
        else
            circfill(fx.x,fx.y,fx.r,fx.c)
        end
    end
end

-- poof effect
function dust(x,y,r,c_table,num)
	for i=0, num do
			--settings
			add_fx(
					x,         -- x
					y,         -- y
					2+rnd(2), -- die
					rnd(2)-1,  -- dx
					rnd(2)-2,  -- dy
					true,      -- gravity
					false,     -- grow
					true,      -- shrink
					r,         -- radius
					c_table    -- color_table
			)
	end
end

__gfx__
00000000011650000116500001165000011650000116500000000000000000000000000000000000000011115550000000001111555000000000111155500000
00000000011560000115600001156000011560000115600000000000000000000000000000000000000111156565000000011115656500000001111565650000
00700700011111100111111001111110011111100111111000000000000000000000000000000000000111155655000000011115565500000001111556550000
0007700004fff00004fff00004fff00004fff00004fff00000000000000000000000000000000000000111155565000000011115556500000001111555650000
0007700000fff00000fff00000fff00000fff00000fff00000000000000000000000000000000000001111111111110000111111111111000011111111111100
0070070001111500001110000011100000111000001110000000000000000000000000000000000000055fffffff000000055fffffff000000055fffffff0000
000000000f555f0000f55000001f5000005f5000001f5000000000000000000000000000000000000005fff5ff5ff0000005fff5ff5ff0000005fff5ff5ff000
0000000000505000050005000050500000550000005050000000000000000000000000000000000000005fffffff000000005fffffff0000ff005fffffff0000
0000000001165000000af0000009700000097000000a90000009a00000099000000a7000000a9000000015fffff00000000015fffff00000ff1015fffff00000
000000000115600000aaaf000099a7000009a00000a99900009a9a0000aa9900000a9000007aa90000011111110000000001111111000000ff1111111ddff000
00000000011111100aaa7af0009aaa000009a000009a990009a999a000a99900000a900000aaa900001111111d100000ff1111111d1ff00000111111111ff000
0000000004fff000aaaaaaaf009aaa000009a00000a999009a9a999a00aa9900000a900000aaa9000011111111100000ff111111111ff0000000111111100000
0000000000fff0009aaaaaaa009aaa000009a000009a9900a9a9999900a99900000a900000aaa90000ffff111ff00000000011111000000011dd111111111000
00000000f1111f0009aaaaa0009aaa000009a00000a999000a9a999000aa9900000a900000aaa90000fffddddff00000001dddddd110000011ddddddddd11000
0000000000555000009aaa000099aa000009a000009a990000a9990000a99900000a900000aaa9000000dd0dd0000000001ddd0d111000001100000000110000
00000000050005000009a0000009a0000009a0000009a000000a9000000a9000000a9000000a9000000011011100000000110000110000000000000000000000
00001111555000000000111115500000000011111550000000001111555000000000001155500000000000000000000000000000000000000000000000000000
00011115656500000001111155650000000111115565000000011115656500000000011155650000000000000000000000000000000000000000000000000000
00011115565500000001111155560000000111115556000000011115565500000000111155560000077777777777777700000000000000000000000000000000
0001111555650000000111115565000000011111556500000001111555650000000011115511110007ccccccccccccc700000000000000000000000000000000
0011111111111100001111111111110000111111111111000011111111111100000011111111000007ccccccccccccc700000000000000000000000000000000
00055fffffff00000005555fffff00000005555fffff000000055fffffff00000fff111ff5f0000007ccccccccccccc700000000000000000000000000000000
0005fff5ff5ff000000555fff5f50000000555fff5f500000005fff5ff5ff0000fff15fffff00000077777777777777700000000000000000000000000000000
00005fffffff0000000055ffffff0000000055ffffff0000ff005fffffff00000ffff55ffff00000000007bbbbbbbbb700000000000000000000000000000000
000015fffff000000000155ffff000000000155ffff00000ff1015fffff00ff001110555ff0fff00000007bbbbbbbbb700000000000000000000000000000000
000111111100000000011111110000000000111111000000ff1111111dd11ff000111111111fff00000007bbbbbbbbb700000000000000000000000000000000
001111111d100000ff1111111d1ff000000111111d00000000111111111110000001111111100000000007777777777700000000000000000000000000000000
0011111111100000ff111111111ff0000001fff111f00000000011111110000000001111100000000000000007ddddd700000000000000000000000000000000
00ffff111ff0000000001111100000000000fff11ff00000011d11111111100000001111100000000000000007ddddd700000000000000000000000000000000
00fffddddff00000001dddddd110000000001dddd0000000011dddddddd110000000dd0dd00000000000000007ddddd700000000000000000000000000000000
0000dd0dd0000000001ddd0d1110000000001dd11000000001100000001100000001dd0dd1000000000000000777777700000000000000000000000000000000
00001101110000000011000011000000000000111000000000000000000000000001100011000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777777af777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777aaaf77777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777777aaa7af7777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777aaaaaaaf777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777779aaaaaaa777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777779aaaaa7777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777779aaa77777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777777779a777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777111155577777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111565657777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111556557777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111555657777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777711111111111177777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777755fffffff7777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777775fff5ff5ff777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777775fffffff7777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777715fffff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111111777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777771111111d177777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777711111111177777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777ffff111ff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777fffddddff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
99999999999999999999999999999999999999dd9dd9999999999999999999999999999999999999999999999999999999999999999999999999999999999999
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11a111aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__sfx__
000c05001902024031280002c0002f0002f0002200022000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
180800000906302003010030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
