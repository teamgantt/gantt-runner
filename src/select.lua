function i_select()
  select_type='character' -- character, level
  selected_index=1
  max_choice=2
  level_choices=4
  is_seed_select=false
  char_choices=2
  lvl_code_x=-64
  lvl_code_input_x=128
  seed_index=1
  lvl_seed={
    {v=1,on=false},
    {v=2,on=false},
    {v=3,on=false},
    {v=4,on=false},
  }

  select_box_character={
    x=30,
    y=60,
    w=18,
    h=18
  }
  select_box_lvl={
    x=32,
    y=30,
    w=19,
    h=19
  }
end


function u_select()
  -- change selected index left
  if (btnp(⬅️)) then
    if not is_seed_select and selected_index > 1 then
      selected_index-=1
      sfx(5)
    end

    -- change which seed digit is selected
    if is_seed_select then
      if (seed_index > 1) then
        seed_index-=1
      else
        seed_index=4
      end
    end
  end

  -- change selected index right
  if (btnp(➡️)) then
    if not is_seed_select and selected_index < max_choice then
      selected_index+=1
      sfx(5)
    end

    -- change which seed digit is selected
    if is_seed_select then
      if (seed_index < 4) then
        seed_index+=1
      else
        seed_index=1
      end
    end
  end

  if (btnp(⬆️) and not is_seed_select) then
    if not is_seed_select and selected_index == 4 then
      selected_index=2
    end
    sfx(5)
  end

  if (btnp(⬇️) and not is_seed_select) then
    if selected_index < max_choice then
      selected_index=max_choice
    end

    sfx(5)
  end


  -- change seed digit up
  if (btnp(⬆️) and is_seed_select) then
    if (lvl_seed[seed_index].v < 9) then
      lvl_seed[seed_index].v+=1
    else
      lvl_seed[seed_index].v=1
    end
    sfx(5)
  end

  if (btnp(⬇️) and is_seed_select) then
    -- change seed digit down
      if (lvl_seed[seed_index].v > 1) then
        lvl_seed[seed_index].v-=1
      else
        lvl_seed[seed_index].v=1
      end
      sfx(5)
  end

  -- End of selection box movement

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
    if (selected_index == 4) then
      select_box_lvl.y = 70
      select_box_lvl.w = 51
      select_box_lvl.x = 38
    else
      select_box_lvl.w = 19
      select_box_lvl.y = 30
      select_box_lvl.x = 30 + (selected_index-1)*24
    end
  end

  if (btnp(❎)) then
    if (select_type == 'character') then
      select_type = 'level'
      selected_index = 1
      max_choice = level_choices
      select_box_character.x = 28 -- reset
      select_box_lvl.x = 38 -- reset
      sfx(4)
    elseif (select_type == 'level') then
      g.start_level(selected_index)
      max_choice = char_choices
      select_type = 'character'
      selected_index = 1
      seed_index=1

      -- use selected seed
      local seed = ''
      for i,v in pairs(lvl_seed) do
        seed = seed..v.v
        global_seed = tonum(seed)
      end
    end
    sfx(4)
  end

  if (btnp(🅾️) and select_type == 'level') then
    -- put into seed select mode
    if (selected_index == 4 and not is_seed_select) then
      is_seed_select=true
    elseif (selected_index == 4 and is_seed_select) then
      is_seed_select=false
    end
  end


  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end

  -- animate text
  if (selected_index == 4) then
    if (lvl_code_x < 12) then
      lvl_code_x+=5
    end
    if (lvl_code_input_x > 70) then
      lvl_code_input_x-=5
    end
  else
    if (lvl_code_x > -64) then
      lvl_code_x-=5
    end
    if (lvl_code_input_x < 128) then
      lvl_code_input_x+=5
    end
  end

  -- set seed digits to on or off
  if (is_seed_select) then
    for i,v in pairs(lvl_seed) do
      if (i == seed_index) then
        lvl_seed[i].on = true
      else
        lvl_seed[i].on = false
      end
    end
  else
    -- turn all off
    for i,v in pairs(lvl_seed) do
      lvl_seed[i].on = false
    end
  end
end

function d_select()
  local stats_offset_x = 28
  local stats_offset_y = 46
  local char_offset_x = 0
  local char_offset_y = -46

  -- draw divider lines
  line(cam.x+0, 8, cam.x+128,8, 7)

  -- draw selection box
  if (select_type == 'character') then
    print('select character', cam.x+32, 1, 7)
    rect(select_box_character.x, select_box_character.y+char_offset_y, select_box_character.x+select_box_character.w+char_offset_x, select_box_character.y+select_box_character.h+char_offset_y, 7)

    if selected_index == 1 then
      print('lIL jOHN', cam.x+48+char_offset_x, 86+char_offset_y, 8)
    else
      print('bARREL nATHAN', cam.x+38+char_offset_x, 86+char_offset_y, 8)
    end

    line(cam.x+20, 94+char_offset_y, cam.x+100, 94+char_offset_y, 7)

    if (g.character == 'john') then
      spr(player.john.run_frames[flr(run_anim.f)], 42+char_offset_x, 60+char_offset_y, 2, 2, player.flip_x)
    else
      spr(player.john.run_frames[1], 42+char_offset_x, 60+char_offset_y, 2, 2, player.flip_x)
    end

    if (g.character == 'nathan') then
      spr(player.nathan.run_frames[flr(run_anim.f)], 68+char_offset_x, 60+char_offset_y, 2, 2, player.flip_x)
    else
      spr(player.nathan.run_frames[1], 68+char_offset_x, 60+char_offset_y, 2, 2, player.flip_x)
    end

    -- draw out player ability stats
    print('sprint:', cam.x+12+stats_offset_x, 16+stats_offset_y, 7)
    spr(103, cam.x+stats_offset_x, 15+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.speed do
      spr(18, cam.x+stats_offset_x+34+(i*9), 15+stats_offset_y, 1, 1)
    end


    print('jump:', cam.x+12+stats_offset_x, 28+stats_offset_y, 7)
    spr(102, cam.x+stats_offset_x, 27+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.jump do
      spr(18, cam.x+stats_offset_x+34+(i*9), 26+stats_offset_y, 1, 1)
    end

    print('grip:', cam.x+12+stats_offset_x, 40+stats_offset_y, 7)
    spr(104, cam.x+stats_offset_x, 39+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.grip do
      spr(18, cam.x+stats_offset_x+34+(i*9), 38+stats_offset_y, 1, 1)
    end

  -- level selection box and images
  elseif (select_type == 'level') then
    rect(select_box_lvl.x, select_box_lvl.y, select_box_lvl.x+select_box_lvl.w, select_box_lvl.y+select_box_lvl.h, 7)
    print('select project '..selected_index, cam.x+32, 1, 7)
    line(cam.x+0, 106, cam.x+128, 106, 7)

    local lvl_spr = {
      x=32,
      y=32,
    }

    local qr_color = 6
    local er_color = 6

    if (selected_index < 4) then
      qr_color = 11
    else
      er_color = 11
    end

    print('quick runs', hcenter('quick runs',cam), 20, qr_color)

    spr(76, lvl_spr.x, lvl_spr.y, 2, 2)
    spr(78, lvl_spr.x+24, lvl_spr.y, 2, 2)
    spr(110,lvl_spr.x+48, lvl_spr.y, 2, 2)

    print('random run', hcenter('random run',cam), 60, er_color)
    spr(106, lvl_spr.x+8, lvl_spr.y+40, 2, 2)
    spr(108, lvl_spr.x+24, lvl_spr.y+40, 2, 2)
    spr(106, lvl_spr.x+40, lvl_spr.y+40, 2, 2, true, true)


    print('🅾️ enter code:', lvl_code_x, 95, 6)
    for i,v in pairs(lvl_seed) do
      -- draw out all digits of seed
      local col = 6 --gray
      if (v.on) then
        col=9 --green
      end

      print(lvl_seed[i].v, lvl_code_input_x+(i*8), 95, col)
    end

  end

  print('⬅️ or ➡️ to choose', cam.x+26, cam.y+112, 6)
	print('❎ to confirm', cam.x+38, cam.y+120, 7)

end
