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
    springs={};
    milestones={};
    milestone_cache={};
    milestone_pts={};
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
      for k,mile in pairs(self.milestones) do
        mile:animate()
      end

      -- animate springs
      for k,spring in pairs(self.springs) do
        spring:animate()
      end

      -- animate milestone pts
      for k,mile in ipairs(self.milestone_pts) do
        mile.y -= 1
        mile.f += 1
        if (mile.f > 10) then
          del(self.milestone_pts, mile)
        end
      end

      -- handle collisions
      milestone_collide(self)
      spring_collide(self)
    end;

    setup = function(self)
      self:setup_special_tiles()
    end;

    draw = function(self)
     map(self.start_cell_x,self.start_cell_y,0,0,self.level_w,self.level_h)

      -- draw milestones
      for k,mile in ipairs(self.milestones) do
        spr(mile_frames[flr(mile.f)], mile.x, mile.y)
      end

      -- draw milestone pts
      for k,mile in ipairs(self.milestone_pts) do
        print('100', mile.x, mile.y, 9)
      end

      -- draw springs
      for k,spring in ipairs(self.springs) do
        spr(spring.s, spring.x, spring.y)
      end
    end;


    --cell coordinates for replacing "m" with milestones
    setup_special_tiles = function(self)
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
          -- check for milestone and replace with empty
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

          -- check for springboard
          if (fget(mget(x,y), 3)) then
            local spring = {
              x=x*8,
              y=y*8-y_offset,
              t=0,
              up=0,
              s=122,
              animate=function(self)
                if (self.up==1) then
                  self.s=123
                  self.t += 1
                  if (self.t > 10) then
                    self.up = 0
                    self.t = 0
                    self.s=122
                  end
                end
              end
            }

            add(self.springs, spring)
            mset(x,y,0)
          end
        end
      end
    end

  }

end


function tick_frames(self)
	self.f += mile_timing
	if (self.f > #mile_frames) then
		self.f = 1
	end
end
