function i_milestone_anims()
	frames={18,19,20,21,22,23,24,25}
	timing=.3
	prev_milestone_x=0
	milestones={}

	add(milestones, {
		x=rnd_between(prev_milestone_x, prev_milestone_x + 256),
		y=mid(rnd(20),rnd(50),rnd(80)),
		f=frames[1]
	})
end

function u_milestone_anims()
 --animate milestone
 for k,mile in ipairs(milestones) do
	mile.f=mile.f+timing

	if mile.f >= frames[8] then
		mile.f = frames[1]
	end
 end
 -- handle collisions
 milestone_collide()

 if (count(milestones) < 1) then
	 add(milestones, {
		x=rnd_between(prev_milestone_x + 128, prev_milestone_x + 258),
		y=mid(rnd(30),rnd(50),rnd(80)),
		f=frames[1]
	 })
 end
end


function d_milestone_anims()
	for k,mile in ipairs(milestones) do
		spr(flr(mile.f), mile.x, mile.y)
	end
end
