function d_ui()
	local y_offset = 116
	spr(106, cam_x+119, cam_y+1, 1, 1) --tg logo

	spr(18, cam_x+2, cam_y+2+y_offset) --milestone
	print(player.milestones .."/"..g.total_milestones, cam_x+12, cam_y+4+y_offset, g.text_color)

	-- score
	spr(16, cam_x+76, cam_y+2+y_offset) --score
	print(g:calculate_score(), cam_x+88, cam_y+4+y_offset, g.text_color)

	spr(46, cam_x+36, cam_y+2+y_offset) --stopwatch
	print(g.cur_t, cam_x+46, cam_y+4+y_offset, g.text_color)

	-- if sprint toggle is on add icon
	if player.sprint_on then
		spr(103, cam_x+118, cam_y+119)
	end
end


