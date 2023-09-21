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
    y=20,
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
      stats:load_level_stats()
    elseif (select_type == 'level') then
      g.start_level(selected_index)
      max_choice = 2
    end
    sfx(20)
  end


  if run_anim.f >= count(player.nathan.run_frames) then
		run_anim.f = 1
  else
    run_anim.f+=run_anim.timing
	end
end

function d_select()
  local stats_offset_x = 28
  local stats_offset_y = 46
  local char_offset_x = 0
  local char_offset_y = -46

  -- draw divider line
  line(cam.x+0, 8, cam.x+128,8, 7)

  -- draw selection box
  if (select_type == 'character') then
    print('select character', cam.x+32, 2, 7)
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
    local stats_offset_x = 32
    local stats_offset_y = 64
    rect(select_box_lvl.x, select_box_lvl.y, select_box_lvl.x+select_box_lvl.w, select_box_lvl.y+select_box_lvl.h, 7)
    print('select project '..selected_index, cam.x+32, 2, 7)

    local lvl_spr = {
      x=32,
      y=22,
    }
    spr(76, lvl_spr.x, lvl_spr.y, 2, 2)
    spr(78, lvl_spr.x+24, lvl_spr.y, 2, 2)
    spr(108,lvl_spr.x+48, lvl_spr.y, 2, 2)

    line(cam.x+14, 50, cam.x+110, 50, 7)

    local prev_time=stats.levels[selected_index].time
    local prev_pts=stats.levels[selected_index].pts
    local best_time=stats.levels[selected_index].best_time
    local best_pts=stats.levels[selected_index].best_pts
    local best_miles=stats.levels[selected_index].best_miles

    -- draw out level stats

    -- best pts
    print('BEST RUN', cam.x+stats_offset_x-8, stats_offset_y-8, 7)
    spr(16, cam.x-8+stats_offset_x, 2+stats_offset_y, 1, 1) --stopwatch
    print(best_pts, cam.x+4+stats_offset_x, 4+stats_offset_y, 11)

    -- best time
    spr(46, cam.x-8+stats_offset_x, 14+stats_offset_y, 1, 1) --trophy
    print(best_time, cam.x+4+stats_offset_x, 16+stats_offset_y, 11)


    -- best miles
    spr(18, cam.x-8+stats_offset_x, 26+stats_offset_y, 1, 1) --milestone
    print(best_miles, cam.x+4+stats_offset_x, 28+stats_offset_y, 11)

    -- prev run
    print('LAST RUN', cam.x+42+stats_offset_x, stats_offset_y-8, 7)

    -- prev pts
    spr(16, cam.x+stats_offset_x+40, 2+stats_offset_y, 1, 1) --stopwatch
    print(prev_pts, cam.x+stats_offset_x+52, 4+stats_offset_y, 6)

    -- prev time
    spr(46, cam.x+stats_offset_x+40, 14+stats_offset_y, 1, 1) --trophy
    print(prev_time, cam.x+stats_offset_x+52, 16+stats_offset_y, 6)

    -- prev miles
    spr(18, cam.x+stats_offset_x+40, 26+stats_offset_y, 1, 1) --milestone
    print(stats.levels[selected_index].miles, cam.x+stats_offset_x+52, 28+stats_offset_y, 6)

  end

  print('press ⬅️ or ➡️ to change', cam.x+16, cam.y+110, 6)
	print('❎ to confirm', cam.x+38, cam.y+120, 7)

end
