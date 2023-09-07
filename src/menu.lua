function d_menu()
  map(112,48,0,0,128,128)

	spr(42, cam.x+24, cam.y+14, 2, 2) --tg logo
	print('gANTT rUNNER', cam.x+44, cam.y+18, 7)


  print('❎ to begin', cam.x+40, 66, 7)
	print('copyright 2023 teamgantt', cam.x+16, 114, 3)
end

function u_menu()
	if (btnp(❎)) then
		g.scene = 'select'
    sfx(2)
	end
end
