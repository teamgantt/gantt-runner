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

  secret_offset_x = 0
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
      max_choice = 4
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
  line(cam_x+0, 8, cam_x+128,8, 7)

  -- draw selection box
  if (select_type == 'character') then
    print('select character', cam_x+32, 2, 7)
    rect(select_box_character.x, select_box_character.y+char_offset_y, select_box_character.x+select_box_character.w+char_offset_x, select_box_character.y+select_box_character.h+char_offset_y, 7)

    if selected_index == 1 then
      print('lIL jOHN', cam_x+48+char_offset_x, 86+char_offset_y, 8)
    else
      print('bARREL nATHAN', cam_x+38+char_offset_x, 86+char_offset_y, 8)
    end

    line(cam_x+20, 94+char_offset_y, cam_x+100, 94+char_offset_y, 7)

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
    print('sprint:', cam_x+12+stats_offset_x, 16+stats_offset_y, 7)
    spr(103, cam_x+stats_offset_x, 15+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.speed do
      spr(18, cam_x+stats_offset_x+34+(i*9), 15+stats_offset_y, 1, 1)
    end


    print('jump:', cam_x+12+stats_offset_x, 28+stats_offset_y, 7)
    spr(102, cam_x+stats_offset_x, 27+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.jump do
      spr(18, cam_x+stats_offset_x+34+(i*9), 26+stats_offset_y, 1, 1)
    end

    print('grip:', cam_x+12+stats_offset_x, 40+stats_offset_y, 7)
    spr(104, cam_x+stats_offset_x, 39+stats_offset_y, 1, 1)
    for i=1,player[g.character].stats.grip do
      spr(18, cam_x+stats_offset_x+34+(i*9), 38+stats_offset_y, 1, 1)
    end

  -- level selection box and images
  elseif (select_type == 'level') then
    local stats_offset_x = 32
    local stats_offset_y = 64
    local project_name = selected_index

    if (project_name == 4) project_name = "dark mode"
    local title = 'project '..project_name
    print(title, cam_x+hcenter(title), 2, 7)

    -- slide over the level images
    if (selected_index == 4) then
      if (secret_offset_x > -14) then
        secret_offset_x -= 1
      end
    elseif (selected_index == 3) then
      if (secret_offset_x < 0) then
        secret_offset_x += 1
      end
    end

    local lvl_spr = {
      x=32+secret_offset_x,
      y=22,
    }

    rect(select_box_lvl.x+secret_offset_x, select_box_lvl.y, select_box_lvl.x+select_box_lvl.w+secret_offset_x, select_box_lvl.y+select_box_lvl.h, 7)
    spr(76, lvl_spr.x, lvl_spr.y, 2, 2)
    spr(78, lvl_spr.x+24, lvl_spr.y, 2, 2)
    spr(108,lvl_spr.x+48, lvl_spr.y, 2, 2)

    if (selected_index==4) then
      spr(110, lvl_spr.x+72, lvl_spr.y, 2, 2)
    end

    line(cam_x+14, 50, cam_x+110, 50, 7)

    local prev_time=stats.levels[selected_index].time
    local prev_pts=stats.levels[selected_index].pts
    local best_time=stats.levels[selected_index].best_time
    local best_pts=stats.levels[selected_index].best_pts
    local best_miles=stats.levels[selected_index].best_miles

    -- draw out level stats

    -- best pts
    print('BEST RUN', cam_x+stats_offset_x-8, stats_offset_y-8, 7)
    spr(16, cam_x-8+stats_offset_x, 2+stats_offset_y, 1, 1) --stopwatch
    print(best_pts, cam_x+4+stats_offset_x, 4+stats_offset_y, 11)

    -- best time
    spr(46, cam_x-8+stats_offset_x, 14+stats_offset_y, 1, 1) --trophy
    print(best_time, cam_x+4+stats_offset_x, 16+stats_offset_y, 11)


    -- best miles
    spr(18, cam_x-8+stats_offset_x, 26+stats_offset_y, 1, 1) --milestone
    print(best_miles, cam_x+4+stats_offset_x, 28+stats_offset_y, 11)

    -- prev run
    print('LAST RUN', cam_x+42+stats_offset_x, stats_offset_y-8, 7)

    -- prev pts
    spr(16, cam_x+stats_offset_x+40, 2+stats_offset_y, 1, 1) --stopwatch
    print(prev_pts, cam_x+stats_offset_x+52, 4+stats_offset_y, 6)

    -- prev time
    spr(46, cam_x+stats_offset_x+40, 14+stats_offset_y, 1, 1) --trophy
    print(prev_time, cam_x+stats_offset_x+52, 16+stats_offset_y, 6)

    -- prev miles
    spr(18, cam_x+stats_offset_x+40, 26+stats_offset_y, 1, 1) --milestone
    print(stats.levels[selected_index].miles, cam_x+stats_offset_x+52, 28+stats_offset_y, 6)

  end

  print('press ⬅️ or ➡️ to change', cam_x+16, cam_y+110, 6)
	print('❎ to confirm', cam_x+38, cam_y+120, 7)

end
