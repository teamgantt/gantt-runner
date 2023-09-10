function d_ui()
	spr(42, cam.x+110, cam.y+2, 2, 2) --tg logo
	spr(18, cam.x+2, cam.y+2) --milestone
	print(player.milestones .."/"..g.total_milestones, cam.x+12, cam.y+4, 0)
	spr(46, cam.x+2, cam.y+12) --stopwatch
	print(g.cur_t, cam.x+12, cam.y+14, 0)
end


