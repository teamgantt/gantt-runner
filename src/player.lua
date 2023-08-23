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
		can_jump=false,
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

	if (btn(🅾️) and (player.move=='run' or player.on_platform==false)) then --speed boost
		player.dx*=2
		player.move='sprint'
		friction=.5
	else
		friction=.75 --reset friction
	end

	--jumping
	if btnp(❎) and player.on_platform == true then --jump
		player.dy-=player.boost
		player.can_jump=false
		sfx(player.sfx_jump)
	elseif btnp(❎) and player.can_jump == true then --early jump
		player.dy=-player.boost
		player.can_jump=false
		sfx(player.sfx_jump)
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
			dust(player.feet_x,player.feet_y,2,1,{6,7},4)
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
		player.dy+=gravity --apply gravity
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
