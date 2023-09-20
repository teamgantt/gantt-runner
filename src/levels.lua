function i_levels()
  day_lines={}
  days={}
	week_days={"mon", "tue", "wed", "thu", "fri"}
	mile_frames={18,18,18,18,18,18,18,18,18,18,18,18, 19, 20, 21, 22, 22}
	mile_timing=.3
	mile_delay=20
	mile_tick=0
  tick_frames = function(self)
    self.f += mile_timing
    if (self.f > #mile_frames) then
      self.f = 1
    end
  end

  -- day lines
  for i=1,128 do
    local x=cam.x+16*i
    local y0=cam.y+0
    local y1=cam.y+128
    add(day_lines, {x=x, y0=y0, y1=y1})

    -- add days of week to the day lines
    local day=week_days[(i-1)%5+1]
    add(days, {x=x+3, y=cam.y+2, day=day})
  end

  level = class {
    start_cell_x=0;
    start_cell_y=0;
    level_w=0;
    level_h=0;
    player_x=10; -- player start position
    player_y=60;
    offset_y=0; -- collision offset for map
    milestones={};
    milestone_cache={};
    color_bg=0;
    chunks={};


    init = function(self, start_cell_x, start_cell_y, level_w, level_h, player_x, player_y, offset_y, color)
      self.start_cell_x = start_cell_x
      self.start_cell_y = start_cell_y
      self.level_w = level_w
      self.level_h = level_h
      self.player_x = cam.x+player_x
      self.player_y = cam.y+player_y
      self.offset_y = offset_y
      self.color_bg = color
    end;

    add_chunk = function(self)
      local prev_chunk = self.chunks[#self.chunks]
      local prev_chunk_offsetx = 0

      if (prev_chunk) then
        prev_chunk_offsetx = prev_chunk.x+128
      end


      local id = flr(rnd(#templates))+1

      -- 8th chunk should be a finish line
      if (#self.chunks == 7) then
        id = 0
      end

      -- printh('added chunk '..id, 'log')
      add(self.chunks, chunk(prev_chunk_offsetx, 0, id))
    end;

    update = function(self)
      if (g.scene == 'game') then
        for k,mile in pairs(self.milestones) do
          mile:animate()
          -- handle collisions
          milestone_collide(self)
        end
      elseif (g.scene == 'procedural') then
        for k,chunk in pairs(self.chunks) do
          -- if chunk is off screen left remove it
          -- if (chunk.x < cam.x-128) then
          --   self:add_chunk()
          -- end

          -- if chunk is on screen
          if (chunk.x > cam.x-128 and chunk.x < cam.x+128) then
            chunk:update()
            chunk:milestone_collide()
          end

          -- if days are off screen left remove them
          -- for k,day in pairs(chunk.days) do
          --   if (day.x < cam.x-128) then
          --     del(days, day)
          --   end
          -- end

        end
      end
    end;

    setup = function(self)
      if (g.scene == 'procedural') then
        -- add chunks every 128 pixels of level_w
        for i=1,flr(self.level_w*8/128) do
          self:add_chunk()
        end

        for k,chunk in pairs(self.chunks) do
          chunk:setup_milestones()
        end
      end
      if (g.scene == 'game') then
        self:setup_milestones()
      end
    end;

    draw = function(self)
      -- draw days
      if (g.scene == 'game') then
        self:draw_days()
        -- static level we use map
        map(self.start_cell_x,self.start_cell_y,0,0,self.level_w,self.level_h)

        -- draw milestones
        for k,mile in pairs(self.milestones) do
          spr(mile_frames[flr(mile.f)], mile.x, mile.y)
        end
      end

      -- procedural level we use generated chunks
      if g.scene == 'procedural' then
        self:draw_days()
        print('#chunks: '..#self.chunks, cam.x+20,20, 11)
        print('seed '..global_seed, cam.x+20,30, 11)
        print('days '..#days, cam.x+20,60, 11)
        print('day lines '..#day_lines, cam.x+20,70, 11)

        -- get string of chunk numbers
        local chunk_str = ''
        for k,chunk in pairs(self.chunks) do
          chunk_str = chunk_str..chunk.template_idx..','
        end

        print('chunk ids: '..chunk_str, cam.x+20,40, 11)

        for k,chunk in pairs(self.chunks) do
          chunk:draw()
        end

      end
    end;

    tear_down = function(self)
      self.milestones = {}
      self.milestone_cache = {}
      self.chunks = {}
    end;


    draw_days = function(self)
      for k,day_line in pairs(day_lines) do
        line(day_line.x, day_line.y0, day_line.x, day_line.y1, g.line_color)
      end

      -- draw days of week
      for k,day in pairs(days) do
        print(day.day, day.x, day.y, g.line_color)
      end

      -- day horizontal line
      line(cam.x, cam.y+8, cam.x+128, cam.y+8, g.line_color)
    end;


    --cell coordinates for replacing "m" with milestones
    setup_milestones = function(self)
      local cache = self.milestone_cache
      local cache_empty = count(cache) == 0
      local start_x = self.start_cell_x
      local start_y = self.start_cell_y
      local end_x = self.start_cell_x+self.level_w
      local end_y = self.start_cell_y+self.level_h
      local y_offset = self.offset_y

      if (g.scene == 'game') then
        -- if we have a cache we can use it
        if (count(cache) != 0) then
          self.milestones = {}

          for i=1,count(cache) do
            add(self.milestones, cache[i])
          end

          return
        end

        if (start_x == 0) then
          start_x = start_x+1
        end

        if (start_y == 0) then
          start_y = start_y+1
        end

        for x=start_x,end_x do
          for y=start_y,end_y do
            if (fget(mget(x,y), 1)) then
              local milestone = {
                x=x*8,
                y=y*8-y_offset,
                f=1,
                animate=tick_frames
              }

              add(self.milestones, milestone)
              if (cache_empty) add(cache, milestone)

              mset(x,y,0)
            end
          end
        end
      end
    end
  }

end



