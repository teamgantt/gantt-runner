function i_select()
  select_type='character' -- character, level
  selected_index=1
  max_choice=2
  select_box_character={
    x=30,
    y=60,
    w=18,
    h=18
  }
  select_box_lvl={
    x=32,
    y=60,
    w=19,
    h=19
  }
end


function u_select()
  -- change selected index left
  if (btnp(⬅️)) then
    if selected_index > 1 then
      selected_index-=1
      sfx(5)
    end
  end

  -- change selected index right
  if (btnp(➡️)) then
    if selected_index < max_choice then
      selected_index+=1
      sfx(5)
    end
  end

  -- set character
  if (select_type == 'character') then
    if (selected_index == 1) then
      g.character = 'john'
    else
      g.character = 'nathan'
    end
  end

  -- set selection box based on index
  if (select_type == 'character') then
    select_box_character.x = 40 + (selected_index-1)*26
  elseif (select_type == 'level') then
    select_box_lvl.x = 30 + (selected_index-1)*24
  end

  if (btnp(❎)) then
    if (select_type == 'character') then
      select_type = 'level'
      selected_index = 1
      max_choice = 3
      select_box_character.x = 28 -- reset
      select_box_lvl.x = 38 -- reset
      sfx(4)
    elseif (select_type == 'level') then
      g.start_level(selected_index)
      max_choice = 2
    end
    sfx(4)
  end


  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end
end

function d_select()

  -- draw divider line
  line(cam.x+0, 48, cam.x+128, 48, 7)

  -- draw selection box
  if (select_type == 'character') then
    print('select character', cam.x+32, 40, 7)
    rect(select_box_character.x, select_box_character.y, select_box_character.x+select_box_character.w, select_box_character.y+select_box_character.h, 7)

    if selected_index == 1 then
      print('lIL jOHN', cam.x+48, 86, 7)
    else
      print('bARREL nATHAN', cam.x+38, 86, 7)
    end

    if (g.character == 'john') then
      spr(player.john.run_frames[flr(run_anim.f)], 42, 60, 2, 2, player.flip_x)
    else
      spr(player.john.run_frames[1], 42, 60, 2, 2, player.flip_x)
    end

    if (g.character == 'nathan') then
      spr(player.nathan.run_frames[flr(run_anim.f)], 68, 60, 2, 2, player.flip_x)
    else
      spr(player.nathan.run_frames[1], 68, 60, 2, 2, player.flip_x)
    end
  -- level selection box and images
  elseif (select_type == 'level') then
    rect(select_box_lvl.x, select_box_lvl.y, select_box_lvl.x+select_box_lvl.w, select_box_lvl.y+select_box_lvl.h, 7)
    print('select project '..selected_index, cam.x+32, 40, 7)

    local lvl_spr = {
      x=32,
      y=62,
    }
    spr(76, lvl_spr.x, lvl_spr.y, 2, 2)
    spr(78, lvl_spr.x+24, lvl_spr.y, 2, 2)
    spr(108,lvl_spr.x+48, lvl_spr.y, 2, 2)
  end

  print('press ⬅️ or ➡️ to change', cam.x+16, cam.y+110, 7)
	print('❎ to confirm', cam.x+38, cam.y+120, 7)

end
