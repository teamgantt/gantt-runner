
function u_summary()
  if btnp(❎) then
    extcmd('reset')
  end


  if run_anim.f >= 3 then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end
end



function d_summary()
  local stat_offx = 2
  local stat_offy = 0
  -- g.end_t = 23.8
  -- player.milestones = 50
  -- g.total_milestones = 50

  if (g.status=='win') then
    cls(1)
    print('nice job!', cam.x+44, cam.y+72, 8)
  elseif (g.status=='lose') then
    cls(2)
    print('you fell', cam.x+44, cam.y+72, 9)
  end
  rect(cam.x+22, cam.y+12, cam.x+104, cam.y+65, 7)
  line(cam.x+22, cam.y+32, cam.x+104, cam.y+32, 7)

	spr(42, cam.x+24, 14, 2, 2) --tg logo
	print('gANTT rUNNER', cam.x+44, cam.y+18, 7)
	print('RUN SUMMARY', cam.x+44, cam.y+24, 7)

  spr(46, cam.x+44+stat_offx, cam.y+35+stat_offy) --time
	print(g.end_t, cam.x+56+stat_offx, cam.y+37+stat_offy, 7)

	spr(18, cam.x+44+stat_offx, cam.y+45+stat_offy) --milestones
  print(player.milestones..'/'..g.total_milestones, cam.x+56+stat_offx, cam.y+47+stat_offy, 7)


  spr(16, cam.x+44+stat_offx, cam.y+55+stat_offy) --score
  print(calculate_score(), cam.x+56+stat_offx, cam.y+56+stat_offy, 7)

  rectfill(cam.x+42, cam.y+34, cam.x+24, cam.y+63, 7)
  spr(player[g.character].run_frames[flr(run_anim.f)], cam.x+26, cam.y+40, 2, 2)

	print('❎ to run again', cam.x+32, cam.y+84, 7)
end

function calculate_score()
  -- local elapsed_time = g.end_t - g.start_t
  -- local time_taken = elapsed_time - player.milestones
  -- local score = (player.milestones + 1) / time_taken
  -- return ceil(score)
  local i = ceil(player.milestones * (1/g.end_t) * 1000)
  if (player.milestones > 0 and player.milestones==g.total_milestones) then
    i+=1000
  end

  if (g.status == 'lose') then
    i-=500
  end
  return i
end
