function i_stats()
  --these stats are ephemeral until saved to cartdata()
  stats={
    levels={
      {
        pts=0,
        time=0,
      },
      {
        pts=0,
        time=0,
      },
      {
        pts=0,
        time=0,
      },
    },

    level_stat_addresses={
      {
        pts=0,
        time=1
      },
      {
        pts=2,
        time=3
      },
      {
        pts=4,
        time=5
      }
    },

    store_level_stat=function(self, level, stat, val)
      self.levels[level][stat]=val
      dset(self.level_stat_addresses[level][stat], val)
      -- log('stored '..stat..' for level '..level..' as '..val)
    end,

    load_level_stats=function(self)
      log('--')
      log('loading lvl 1 time'..' '..self.levels[1].time)
      log('loading lvl 1 pts'..' '..self.levels[1].pts)
      log('--')

      -- loop over addresses and load stats
      for i,v in pairs(self.level_stat_addresses) do
        local pts=dget(v.pts)
        local time=dget(v.time)
        log('loaded '..i..' p:'..pts..' t:'..time)
        self.levels[i].pts=pts
        self.levels[i].time=time
      end
    end,
  }
  -- attempt to load stats from cartdata
  stats:load_level_stats()
end
