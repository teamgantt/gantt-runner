function d_summary()
	spr(42, cam.x+24, cam.y+14, 2, 2) --tg logo
	print('gANTT rUNNER', cam.x+44, cam.y+18, 7)
	print('RUN SUMMARY', cam.x+44, cam.y+24, 7)

  spr(46, cam.x+44, cam.y+34) --time
	print(g.end_t, cam.x+56, cam.y+36, 7)

	spr(18, cam.x+44, cam.y+44) --milestones
  print(player.milestones..'/'..g.total_milestones, cam.x+56, cam.y+46, 7)

  if (g.status=='win') then
    print('nice job!', cam.x+44, cam.y+56, 7)
  elseif (g.status=='lose') then
    print('you fell', cam.x+44, cam.y+56, 7)
  end


	print('❎ to run again', cam.x+32, cam.y+84, 7)
end

function u_summary()
  if btnp(❎) then
    extcmd('reset')
  end
end
