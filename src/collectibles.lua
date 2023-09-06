function i_milestone_anims()
	mile_frames={18,18,18,18,18,18,18,18,18,18,18,18, 19, 20, 21, 22, 22}
	mile_timing=.3
	mile_delay=20
	mile_tick=0
	prev_milestone_x=128
	milestones={}

	for x=1,128 do
		for y=1,16 do
			if (fget(mget(x,y), 1)) then
				add(milestones, {
					x=x*8,
					y=y*8,
					f=1,
					animate=tick_frames
				})

				mset(x,y,0)
			end
		end
	end
end

function u_milestone_anims()
	--animate milestone
	for k,mile in ipairs(milestones) do
		mile:animate()
	end


	-- handle collisions
	milestone_collide()
end


function d_milestone_anims()
	for k,mile in ipairs(milestones) do
		if debug then print(flr(mile.f), mile.x, mile.y+8) end
		spr(mile_frames[flr(mile.f)], mile.x, mile.y)
	end
end

function tick_frames(self)
	self.f += mile_timing
	if (self.f > #mile_frames) then
		self.f = 1
	end
end
