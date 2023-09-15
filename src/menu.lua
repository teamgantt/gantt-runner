function i_menu()
	interval= rnd_between(40,80)
	menu_f=2
	def_j_dx=1.2
	def_n_dx=1.2
	menu_john = {
		dx = def_j_dx,
		x = 42,
		y = 84,
		w = 16,
		h = 16,
		flip_x = false,
		run_frames={34,36,34}
	}
	menu_nathan = {
		dx = def_n_dx,
		x = 64,
		y = 84,
		w = 16,
		h = 16,
		is_rolling = false,
		flip_x = false,
		run_frames={66,68,66},
		roll_frames={96,98,100}
	}
end

function u_menu()
	if (menu_f % interval == 0) then
		menu_nathan.is_rolling = not menu_nathan.is_rolling
		menu_f=0
	end


	if (btnp(❎)) then
		g.scene = 'select'
		stats:load_all()
    sfx(2)
	elseif (btnp(🅾️)) then
    sfx(1)
		g.scene = 'stats'
	end


  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing+.10
	end

	menu_john.x += menu_john.dx
	menu_nathan.x += menu_nathan.dx

	-- if either player hits the edge of the screen, flip them
	if (menu_john.x <= -30 or menu_john.x >= 148) then
		menu_john.flip_x = not menu_john.flip_x
		menu_john.dx *= -1
	end
	if (menu_nathan.x <= -32 or menu_nathan.x >= 148) then
		menu_nathan.flip_x = not menu_nathan.flip_x
		menu_nathan.dx *= -1
	end

	menu_f+=1
end

function d_menu()
	-- draw title logo
	spr(192,28,6,8,4)
	spr(200,28,38,8,3)

	spr(get_nathan_frames(menu_nathan.is_rolling), menu_nathan.x, menu_nathan.y, 2, 2, menu_nathan.flip_x)
	spr(menu_john.run_frames[flr(run_anim.f)], menu_john.x, menu_john.y, 2, 2, menu_john.flip_x)


  print('❎ to start', cam.x+40, 68, 7)
	print('🅾️ stats', cam.x+44, 76, 6)

	-- draw task bar
	rectfill(cam.x-1, cam.y+100, cam.x+129, cam.y+108, 10)
	rect(cam.x-1, cam.y+100, cam.x+129, cam.y+108, 9)

	spr(248, cam.x+8, cam.y+114, 1, 1) --tg logo
	print('copyright 2023 teamgantt', cam.x+19, 116, 6)
end

function get_nathan_frames(is_rolling)
	-- at random intervals, nathan will roll for 8 frames
	if (is_rolling) then
		menu_nathan.dx*=1.01
		return menu_nathan.roll_frames[flr(run_anim.f)]
	end

	-- if not rolling set back to default speed
	if (menu_nathan.dx > 0) then
		menu_nathan.dx = def_n_dx
	else
		menu_nathan.dx = -def_n_dx
	end

	return menu_nathan.run_frames[flr(run_anim.f)]
end
