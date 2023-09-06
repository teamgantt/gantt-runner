function i_player()
	gravity=0.5
	fall_gravity=1.3
	friction=.75
	run_anim={
		f=1,
		timing=.4
	}
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
		tile=0,
		flip_x=false,
		h=16,
		w=12,
		x=40,
		y=30,
		coyote_time=0,
		feet_x=8,
		feet_y=0,
		on_platform=false,
		jumping=false,
		falling=false,
		will_jump=false,
		move='idle', -- idle, run, sprint, duck

		-- functions
		jump=function()
			if player.move== 'duck' then
				player.dy=-player.boost*1.25
				sfx(player.sfx_jump2)
			else
				player.dy=-player.boost
				sfx(player.sfx_jump)
				player.on_platform=false
			end

			player.coyote_time=0
			dust(player.feet_x-4,player.feet_y,2,5,{5,6,7},4)
		end,

		-- sfx
		sfx_jump=0,
		sfx_jump2=4,
		sfx_land=1,
		sfx_step=3,

		-- sprites
		--player anims
			john={
				cur_s=32,
				idle_s=32,
				falling_s=38,
				jumping_s=40,
				duck_s=10,
				run_frames={34,36,34},
				sprint_frames={34,36,34},
			},
			nathan={
				cur_s=64,
				idle_s=64,
				falling_s=72,
				jumping_s=70,
				duck_s=74,
				run_frames={66,68,66},
				sprint_frames={96,98,100}
			}

	}
	run_sfx={
		elapsed=0,
		step=function(timing)
			run_sfx.elapsed+=timing
			if (run_sfx.elapsed >= 1) then
				run_sfx.elapsed=0
				sfx(player.sfx_step)
			end
		end
	}
end

function u_player()
	player.move='idle'
	player.dx*=friction

	--controls
	if (btn(⬅️)) then
		player.dx-=player.acc
		player.flip_x=true
		if (player.on_platform) then
			player.move='run'
		end
	end -- left

	if (btn(➡️)) then
		player.dx+=player.acc
		player.flip_x=false
		if (player.on_platform) then player.move='run' end
	end -- right

	if (btn(⬇️) and player.on_platform and not (btn(⬅️) or btn(➡️))) then
		player.move='duck'
	end

	if (btn(🅾️) and (player.move=='run' or player.on_platform==false)) then --speed boost
		player.dx*=2
		friction=.5
	else
		friction=.75 --reset friction
	end

	--jumping
	if btnp(❎) and (player.on_platform == true or player.coyote_time > 0) then --jump
		player.jump()
	end

	--player hit jump button before landing in grace zone
	if player.on_platform and player.will_jump then
		player.jump()
		player.will_jump=false
	end

	--sprinting
	if player.dx > 3.5 or player.dx < -3.5 then
		player.move='sprint'
	end

	--limit left/right speed
	player.dx=mid(-player.max_dx,player.dx,player.max_dx)

	--limit fall speed
	if (player.dy>0) then
		player.dy=mid(-player.max_dy,player.dy,player.max_dy)
	end

	--apply dx and dy to player position
	player.x+=player.dx
	player.y+=player.dy

	--coyote time
	if (player.on_platform) then
		player.coyote_time=8 --reset
	elseif (player.dy > 0 and player.coyote_time > 0) then
		player.coyote_time-=1
	elseif (player.dy < 0) then
		player.coyote_time=0 --remove during jump
	end


 --animate player run
  if run_anim.f >= count(player[g.character].run_frames) then
		run_anim.f = 1
	end

	--handle player sfx
	if (player.on_platform and player.move =='run') then
		run_sfx.step(.2)
	end

	--running animations
	if (player.move != 'idle') and player.on_platform then
		--handle run animation
		run_anim.f=run_anim.f+run_anim.timing

		if player.move == 'sprint' then
			dust(player.feet_x,player.feet_y,2,1,{5,6,7},4)
			run_sfx.step(.3)
		end
	else
		run_anim.f=1
	end

	--apply gravity based on if player is holding jump
	if btn(❎) then
		player.dy+=gravity
	else
		player.dy+=fall_gravity
	end

	--check for collision with platform
	if (player.dy > 0 and collide_map(player,"down",0)) then
		player.on_platform=true
		player.falling=false
		player.dy=0
		player.coyote_time=8
		player.y-=((player.y+player.h+1)%8)-1
	end


	--update feet pos
	player.feet_y=player.y+player.h
	player.feet_x=player.x+player.w/2

	-- player falls, reset
	if (player.y > 256) then
		extcmd("reset")
	end

end

function d_player()
	if debug then
		print("coyote_time: "..player.coyote_time, player.x, player.y-6, 1)
		print('status:'..player.move, player.x, player.y-12, 1)
		print("will jump:"..tostr(player.will_jump), player.x, player.y-18, 1)
		print("x:"..flr(player.x), player.x, player.y-30, 1)
		print("y:"..flr(player.y), player.x, player.y-36, 1)
		print("dy:"..tostr(player.dy),cam.x, cam.y+10,11)
		print("dx:"..tostr(player.dx),cam.x, cam.y+16,11)
		print("falling: "..tostr(player.falling),cam.x, cam.y+22,11)

	end

	--offset for player sprite
	local x_offset= 0
	if (player.dx < 0) then
		x_offset=player.x-2
	elseif player.dx > 0 then
		x_offset=player.x-1
	else
		x_offset=player.x
	end

	if (player.move=='run' and player.on_platform) then
		spr(player[g.character].run_frames[flr(run_anim.f)], x_offset, player.y, 2, 2, player.flip_x)
	elseif (player.move=='sprint' and player.on_platform) then
		spr(player[g.character].sprint_frames[flr(run_anim.f)], x_offset, player.y, 2, 2, player.flip_x)
	elseif (player.dy > 0) then
		spr(player[g.character].falling_s, x_offset, player.y, 2, 2, player.flip_x)
	elseif (player.dy < 0) then
		spr(player[g.character].jumping_s, x_offset, player.y, 2, 2, player.flip_x)
	elseif (player.move=='duck') then
		spr(player[g.character].duck_s, x_offset, player.y, 2, 2, player.flip_x)
	else --idle
		spr(flr(player[g.character].idle_s), x_offset, player.y, 2, 2, player.flip_x)
	end
end
