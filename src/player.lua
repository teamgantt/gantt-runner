function i_player()
	gravity=0.25
	fall_gravity=.65
	jump_grace_frames=3
	current_friction=0.75

	run_anim={
		f=1,
		timing=.2
	}
	player={

		-- player stats
		score=0,
		milestones=0,
		jumps=0,

		-- player physics
		acc=0.25,
		dx=0,
		dy=0,
		max_dy=2.5,
		tile=0,
		jump_intent_t=0, -- 8 frames of allowance to accept a new jump
		flip_x=false,
		h=16,
		w=12,
		x=40,
		y=60,
		sprint_on=false,
		holding_jump=false,
		has_double=true,
		coyote_time=0,
		feet_x=8,
		feet_y=0,
		on_platform=false,
		jumping=false,
		falling=false,
		will_jump=false,
		move='idle', -- idle, run, sprint, duck

		-- functions
		handle_coyote_time=function(self)
			if (self.on_platform == true) then
				self.coyote_time=self[g.character].coyote_reset --reset
			end

			if (self.falling == true and self.coyote_time > 0) then
				self.coyote_time=self.coyote_time-1
			end
		end,

		jump=function(self)
			if self.move == 'duck' and self.on_platform == true then
				self.dy=-self[g.character].boost*1.25
				sfx(self.sfx_jump2)
			else
				self.dy=-self[g.character].boost
				sfx(self.sfx_jump)
			end
			self.on_platform=false
			self.coyote_time=0
			self.jumps+=1
			add_poof(self.feet_x-4,self.feet_y-8,'l')
			add_poof(self.feet_x+4,self.feet_y-8,'r')
		end,

		-- sfx
		sfx_jump=0,
		sfx_jump2=4,
		sfx_land=1,
		sfx_step=3,

		-- character props
		john={
			max_dx=2.45, --w sprint
			boost=4,
			can_double=true,
			run_friction=.75,
			mod_friction=1.10,
			cur_s=32,
			idle_s=32,
			falling_s=38,
			jumping_s=40,
			duck_s=10,
			coyote_reset=4,
			run_frames={34,36,34},
			sprint_frames={34,36,34},
			stats={
				speed=1,
				jump=3,
				grip=2,
			}
		},
		nathan={
			max_dx=2.75, --w sprint
			boost=4.25,
			can_double=false,
			run_friction=0.75,
			mod_friction=1.25,
			cur_s=64,
			idle_s=64,
			falling_s=72,
			jumping_s=70,
			duck_s=74,
			coyote_reset=20,
			run_frames={66,68,66},
			sprint_frames={96,98,100},
			stats={
				speed=3,
				jump=2,
				grip=1,
			}
		}

	}
	run_sfx={
		elapsed=0,
		step=function(timing)
			run_sfx.elapsed+=timing
			if (run_sfx.elapsed >= 1) then
				run_sfx.elapsed=0
				sfx(player.sfx_step)
				if player.dx>0 then
					add_poof(player.x-4+player.w/2,player.y+player.h/2,'r')
				else
					add_poof(player.x+player.w/2,player.y+player.h/2,'l')
				end
			end
		end
	}
end

function u_player()
	player.move='idle'
	player.dx*=current_friction*player[g.character].mod_friction

	if (player.jump_intent_t > 0) then
		player.jump_intent_t-=1
	end

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


	--record jump intent via timer
	if btnp(❎) and player.dy>0 and player.jump_intent_t == 0 then
		--restart jump intent timer, if timeleft when they hit the ground, they jump
		player.jump_intent_t=jump_grace_frames
	end

	--jumping
	if btnp(❎) and (
		player.on_platform == true or
		player.coyote_time > 0
	) then --jump
		player:jump()
	elseif (
		btnp(❎) and
		player.falling and --
		(player[g.character].can_double == true
		 and player.has_double == true)
		 and not player.holding_jump) then
			player:jump()
			player.has_double=false
	end

	--sprinting

	if (sprint_hold) then
		if (btnp(🅾️)) then
			player.sprint_on=not player.sprint_on
		end
	else
		if (btn(🅾️)) then
			player.sprint_on=true
		else
			player.sprint_on=false
		end
	end

	if (player.sprint_on) and ((player.dx<0 and btn(⬅️))  or (player.dx>0 and btn(➡️))) then
		current_friction=player[g.character].run_friction*player[g.character].mod_friction
		player.move='sprint'
		player.dx = limit_speed(player.dx,player[g.character].max_dx)
	else
		current_friction=player[g.character].run_friction --reset friction
		player.dx = limit_speed(player.dx,player[g.character].max_dx-0.5) -- lower max speed if not sprinting
	end

	--limit fall speed
	if (player.dy>0) then
		player.dy=limit_speed(player.dy,player.max_dy)
	end

	--apply dx and dy to player position
	player.x+=player.dx
	player.y+=player.dy

 --animate player run
  if run_anim.f >= count(player[g.character].run_frames) then
		run_anim.f = 1
	end

	--handle player sfx
	if (player.on_platform and player.move =='run') then
		run_sfx.step(.1)
	end

	--running animations
	if (player.move != 'idle') and player.on_platform then
		--handle run animation
		run_anim.f=run_anim.f+run_anim.timing

		if player.move == 'sprint' then
			run_sfx.step(.15)
		end
	else
		run_anim.f=1
	end

	--apply gravity based on if player is holding jump
	if btn(❎) then
		player.dy+=gravity
		player.holding_jump=true
	else
		sfx(player.sfx_jump, -2)
		player.holding_jump=false
		player.dy+=fall_gravity
	end


	--coyote time
	player:handle_coyote_time()

	--check for collision with platform
	if (player.dy > 0 and collide_map(player,"down",0)) then
		--player hit jump button before landing while close to platform
		if player.jump_intent_t > 0 and not collide_map(player, "down", 2) then
			player:jump()
			player.jump_intent_t=0
			return
		end

		if (not player.on_platform) then
			add_poof(player.x+player.w/2,player.y+player.h/2,'l')
			add_poof(player.x+player.w/2,player.y+player.h/2,'r')
		end

		player.on_platform=true
		player.has_double=true
		player.falling=false
		player.dy=0
		player.y-=((player.y+player.h+1)%8)-1 --reposition player to be on platform
	elseif (player.dy > 0 and not collide_map(player,"down",0)) then
		player.on_platform=false
		player.falling=true
	end

	--update feet pos
	player.feet_y=player.y+player.h
	player.feet_x=player.x+player.w/2

	-- player falls, reset
	if (player.y > cam.y+128) then
		g.end_level('lose')
	end

	--check for finish (flag2)
	if (collide_map(player, "down", 2)) then
		--TODO: add finish particles and timer to next scene
		g.end_level('win')
	end
end

function d_player()
	if debug then
		print("coyote_time: "..player.coyote_time, player.x, player.y-6, 1)
		print('status:'..player.move, player.x, player.y-12, 1)
		print("intent_timer:"..tostr(player.jump_intent_t), player.x, player.y-18, 1)
		print("x:"..flr(player.x), player.x, player.y-30, 1)
		print("y:"..flr(player.y), player.x, player.y-36, 1)
		print("has_double:"..tostr(player.has_double), player.x, player.y-46, 1)
		print("dy:"..tostr(player.dy),cam.x, cam.y+10,11)
		print("dx:"..tostr(player.dx),cam.x, cam.y+16,11)
		print("falling: "..tostr(player.falling),cam.x, cam.y+22,11)
		print("friction: "..tostr(current_friction),cam.x, cam.y+28,11)
	end

	--offset for player sprite/hitbox
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

function limit_speed(num,maximum)
  return mid(-maximum,num,maximum)
end
