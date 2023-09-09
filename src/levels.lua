function i_levels()
	mile_frames={18,18,18,18,18,18,18,18,18,18,18,18, 19, 20, 21, 22, 22}
	mile_timing=.3
	mile_delay=20
	mile_tick=0

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

    update = function(self)
      	--animate milestone
      for k,mile in ipairs(self.milestones) do
        mile:animate()
      end
      -- handle collisions
      milestone_collide(self)
    end;

    setup = function(self)
      self:setup_milestones()
      --   self.start_cell_x, -- start x
      --   self.start_cell_x+self.level_w, -- end x
      --   self.start_cell_y, -- start y
      --   self.start_cell_y+self.level_h, -- end y,
      --   self.offset_y,
      --   self.milestone_cache,
      --   self.milestones
      -- )
    end;

    draw = function(self)
     map(self.start_cell_x,self.start_cell_y,0,0,self.level_w,self.level_h)

      -- draw milestones
      for k,mile in ipairs(self.milestones) do
        spr(mile_frames[flr(mile.f)], mile.x, mile.y)
      end
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

      -- if we have a cache we can use it
      if (count(cache) != 0) then
        log("using cache "..count(cache))
        self.milestones = {}

        for i=1,count(cache) do
          add(self.milestones, cache[i])
        end

          log("final self.milestones from cache: "..count(self.milestones))
          log("first milestone from cache: "..self.milestones[1].x..","..self.milestones[1].y)
        return
      end

      log("not using cache. initial self.milestones: "..count(self.milestones))

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
      log("final milestones: "..count(self.milestones))
    end

  }

end


function tick_frames(self)
	self.f += mile_timing
	if (self.f > #mile_frames) then
		self.f = 1
	end
end