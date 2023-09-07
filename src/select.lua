function i_select()
  g.character = 'john'
  select_box1 = {
    x = 38,
    y = 60,
    w = 16,
    h = 16
  }
  select_box2 = {
    x = 64,
    y = 60,
    w = 16,
    h = 16
  }
end


function u_select()
  if (btnp(➡️)) then
    g.character = 'nathan'
    sfx(5)
  end

	if (btnp(⬅️)) then
    g.character = 'john'
    sfx(5)
  end

  if (btnp(❎)) then
    g.start_level()
    sfx(4)
  end

  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end
end

function d_select()
	print('select character:', cam.x+28, 40, 7)
	print('❎ to confirm', cam.x+32, 84, 7)

  if g.character == 'john' then
    rect(select_box1.x, select_box1.y, select_box1.x+select_box1.w, select_box1.y+select_box1.h, 7)
  else
    rect(select_box2.x, select_box2.y, select_box2.x+select_box2.w, select_box2.y+select_box2.h, 7)
  end

  if (g.character == 'john') then
    spr(player.john.run_frames[flr(run_anim.f)], 40, 60, 2, 2, player.flip_x)
  else
    spr(player.john.run_frames[1], 40, 60, 2, 2, player.flip_x)
  end

  if (g.character == 'nathan') then
    spr(player.nathan.run_frames[flr(run_anim.f)], 64, 60, 2, 2, player.flip_x)
  else
    spr(player.nathan.run_frames[1], 64, 60, 2, 2, player.flip_x)
  end

end
