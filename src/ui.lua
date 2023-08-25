function d_ui()
	print("milestones: "..player.milestones, cam.x+2, cam.y+2, 0)
end

function d_ui_start()
	spr(42, cam.x+110, cam.y+2, 2, 2) --tg logo

	print('select character:', cam.x+20, 30, 0)
	print("z for lil' john", cam.x+20, 40, 0)
	print('x for barrel nathan', cam.x+20, 50, 0)
end

function u_ui_start()
	if (btn(🅾️)) then
		g.scene = 'game'
		g.character = 'john'
	end
	if (btn(❎)) then
		g.scene = 'game'
		g.character = 'nathan'
	end
end