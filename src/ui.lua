function d_ui()
	local y_offset = 116
	spr(248, cam.x+119, cam.y+1, 1, 1) --tg logo

	spr(18, cam.x+2, cam.y+2+y_offset) --milestone
	print(player.milestones .."/"..g.total_milestones, cam.x+12, cam.y+4+y_offset, 0)

	-- score
	spr(16, cam.x+76, cam.y+2+y_offset) --score
	print(g:calculate_score(), cam.x+88, cam.y+4+y_offset, 0)

	spr(46, cam.x+36, cam.y+2+y_offset) --stopwatch
	print(g.cur_t, cam.x+46, cam.y+4+y_offset, 0)

	-- if sprint toggle is on add icon
	if player.sprint_on then
		spr(103, cam.x+118, cam.y+119)
	end
end


