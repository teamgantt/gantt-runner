function i_summary()
  top_banner={x=-128,y=0,w=128,h=7}
  bottom_banner={x=128,y=120,w=128,h=7}
  banners_top={}
  banners_bottom={}
  button_access_delay=24
  delay_instructions=button_access_delay

  -- add top banner
  for i=1,32 do
    -- add 8px sprites to the top banner
    add(banners_top, {x=-8+(i*8), y=0, w=8})
  end

  -- add bottom banner
  for i=1,32 do
    -- add 8px sprites to the bottom banner
    add(banners_bottom, {x=-24+(i*8), y=120, w=8})
  end

  animate_banners_left=function()
    for i,v in pairs(banners_top) do
      v.x-=1
      if (v.x < -16) then
        v.x = 128
      end
    end
  end

  animate_banners_right=function()
    for i,v in pairs(banners_bottom) do
      v.x+=1
      if (v.x > 128) then
        v.x = -16
      end
    end
  end
end

function u_summary()
  -- only allow button presses after delay
  if (delay_instructions > 0) then
    delay_instructions-=1
  else
    if btnp(❎) then
      g.start_level(g.level)
      delay_instructions = button_access_delay
    end

    if btnp(🅾️) then
      extcmd('reset')
    end
  end

  --animate banners
  if run_anim.f >= 3 then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end

  animate_banners_left()
  animate_banners_right()
end



function d_summary()
  local stat_offx = 2
  local stat_offy = 8
  -- g.end_t = 23.8
  -- player.milestones = 50
  -- g.total_milestones = 50

  if (g.status=='win') then
    rectfill(cam.x, cam.y, cam.x+127, cam.y+127, 1)

    for i,v in pairs(banners_top) do
      spr(29, cam.x+v.x, cam.y+v.y, 1, 1)
    end
    for i,v in pairs(banners_bottom) do
      spr(29, cam.x+v.x, cam.y+v.y, 1, 1)
    end

    print('nice job!', cam.x+44, cam.y+90, 8)
  elseif (g.status=='lose') then
    rectfill(cam.x, cam.y, cam.x+127, cam.y+127, 2)
    print('you fell', cam.x+48, cam.y+90, 9)
  end
  fillp(0)
  rect(cam.x+22, cam.y+12, cam.x+104, cam.y+83, 7)
  line(cam.x+22, cam.y+32, cam.x+104, cam.y+32, 7)
  line(cam.x+22, cam.y+40, cam.x+104, cam.y+40, 7)

	spr(248, cam.x+27, 19, 2, 2) --tg logo
	print('gANTT rUNNER', cam.x+40, cam.y+18, 7)
	print('RUN SUMMARY', cam.x+40, cam.y+24, 7)

  print('level '..g.level, cam.x+46+stat_offx, cam.y+26+stat_offy, 7)

  spr(46, cam.x+44+stat_offx, cam.y+35+stat_offy) --time
	print(g.end_t..' sec', cam.x+56+stat_offx, cam.y+37+stat_offy, 7)

	spr(18, cam.x+44+stat_offx, cam.y+45+stat_offy) --milestones
  print(player.milestones..'/'..g.total_milestones, cam.x+56+stat_offx, cam.y+47+stat_offy, 7)

  spr(102, cam.x+44+stat_offx, cam.y+55+stat_offy) --jumps
  print(player.jumps..' jumps', cam.x+56+stat_offx, cam.y+57+stat_offy, 7)

  spr(16, cam.x+44+stat_offx, cam.y+65+stat_offy) --score
  print(player.score..' pts', cam.x+56+stat_offx, cam.y+67+stat_offy, 7)

  -- player backing rect
  rectfill(cam.x+42, cam.y+42, cam.x+24, cam.y+81, 7)
  spr(player[g.character].run_frames[flr(run_anim.f)], cam.x+26, cam.y+64, 2, 2)

  --delay instructions
  if (delay_instructions == 0) then
    print('❎ to retry level', cam.x+28, cam.y+102, 7)
    print('🅾️ to quit', cam.x+42, cam.y+110, 6)
  end
end


