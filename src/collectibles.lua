function i_milestone_anims()
	mile_frames={18,18,18,18,18,18,18,18,18,18,18,18, 19, 20, 21, 22, 22}
	mile_timing=.3
	mile_delay=20
	mile_tick=0
	prev_milestone_x=128
	milestones={}

	add(milestones, {
		x=40,
		y=40,
		f=1,
		animate=tick_frames
	})

	add(milestones, {
		x=rnd_between(prev_milestone_x, prev_milestone_x + 256),
		y=mid(rnd(20),rnd(50),rnd(80)),
		f=1,
		animate=tick_frames
	})
end

function u_milestone_anims()
	--animate milestone
	for k,mile in ipairs(milestones) do
		mile:animate()
	end


	-- handle collisions
	milestone_collide()

	if (count(milestones) < 1) then
		add(milestones, {
			x=rnd_between(prev_milestone_x + 128, prev_milestone_x + 258),
			y=mid(rnd(30),rnd(50),rnd(80)),
			f=1,
			animate=tick_frames
		})
	end
end


function d_milestone_anims()
	for k,mile in ipairs(milestones) do
		print(flr(mile.f), mile.x, mile.y+8)
		spr(mile_frames[flr(mile.f)], mile.x, mile.y)
	end
end

function tick_frames(self)
	self.f += mile_timing
	if (self.f > #mile_frames) then
		self.f = 1
	end
end
