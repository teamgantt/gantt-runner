function i_stats()
  --these stats are ephemeral until saved to cartdata()
  stats={
    levels={
      {
        pts=0,
        time=0,
        miles=0,
        best_pts=0,
        best_time=0,
        best_miles=0
      },
      {
        pts=0,
        time=0,
        miles=0,
        best_pts=0,
        best_time=0,
        best_miles=0
      },
      {
        pts=0,
        time=0,
        miles=0,
        best_pts=0,
        best_time=0,
        best_miles=0
      },
      {
        pts=0,
        time=0,
        miles=0,
        best_pts=0,
        best_time=0,
        best_miles=0
      }
    },

    level_stat_addresses={
        {
          pts=0,
          time=1,
          miles=2,
          best_pts=3,
          best_time=4,
          best_miles=5
        },
        {
          pts=6,
          time=7,
          miles=8,
          best_pts=9,
          best_time=10,
          best_miles=11
        },
        {
          pts=12,
          time=13,
          miles=14,
          best_pts=15,
          best_time=16,
          best_miles=17
        },
        {
          pts=18,
          time=19,
          miles=20,
          best_pts=21,
          best_time=22,
          best_miles=23
        }
      },

    store_level_stat=function(self, level, stat_tbl)
      local pts=stat_tbl.pts
      local time=stat_tbl.time
      local miles=stat_tbl.miles

      self.levels[level].pts=pts
      self.levels[level].time=time
      self.levels[level].miles=miles

      -- if this is a new best pts, store it
      if pts>self.levels[level].best_pts then
        self.levels[level].best_pts=pts

        dset(self.level_stat_addresses[level].best_pts, pts)
        dset(self.level_stat_addresses[level].best_time, time)
        dset(self.level_stat_addresses[level].best_miles, miles)
      end

      -- store as previous
      dset(self.level_stat_addresses[level].pts, pts)
      dset(self.level_stat_addresses[level].time, time)
      dset(self.level_stat_addresses[level].miles, miles)
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
        local miles=dget(v.miles)
        local best_pts=dget(v.best_pts)
        local best_time=dget(v.best_time)
        local best_miles=dget(v.best_miles)

        log('loaded '..i..' p:'..pts..' t:'..time)
        self.levels[i].pts=pts
        self.levels[i].time=time
        self.levels[i].miles=miles
        self.levels[i].best_pts=best_pts
        self.levels[i].best_time=best_time
        self.levels[i].best_miles=best_miles
      end
    end,
  }
  -- attempt to load stats from cartdata
  stats:load_level_stats()
end
