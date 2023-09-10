function i_menu()
	interval= rnd_between(40,80)
	menu_f=2
	menu_john = {
		dx = 2,
		x = 42,
		y = 84,
		w = 16,
		h = 16,
		flip_x = false,
		run_frames={34,36,34}
	}
	menu_nathan = {
		dx = 1.6,
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
    sfx(2)
	end


  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing+.1
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
	spr(192,28,10,8,4)
	spr(200,28,42,8,4)

	spr(get_nathan_frames(menu_nathan.is_rolling), menu_nathan.x, menu_nathan.y, 2, 2, menu_nathan.flip_x)
	spr(menu_john.run_frames[flr(run_anim.f)], menu_john.x, menu_john.y, 2, 2, menu_john.flip_x)



	-- draw task bar
	rectfill(cam.x-1, cam.y+100, cam.x+129, cam.y+108, 10)
	rect(cam.x-1, cam.y+100, cam.x+129, cam.y+108, 9)

	spr(42, cam.x+30, cam.y+110, 2, 2) --tg logo
  print('❎ to begin', cam.x+40, 68, 7)
	print('teamgantt', cam.x+48, 116, 7)
end

function get_nathan_frames(is_rolling)
	-- at random intervals, nathan will roll for 8 frames
	if (is_rolling) then
		return menu_nathan.roll_frames[flr(run_anim.f)]
	end

	return menu_nathan.run_frames[flr(run_anim.f)]
end
