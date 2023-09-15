function i_stats()
  hold_reset=0
  is_resetting=false
  --these stats are ephemeral until saved to cartdata()
  stats={
    data={
      total_time=0,
      total_jumps=0,
      total_runs=0,
      total_wins=0,
      total_falls=0,
      milestones=0,
      john_runs=0,
      nathan_runs=0,
      total_points=0,
    },
    store_address={
      total_time=0,
      total_jumps=1,
      total_runs=2,
      total_wins=3,
      total_falls=4,
      milestones=5,
      john_runs=6,
      nathan_runs=7,
      total_points=8,
    },

    update=function(self, stat, val)
      if stat=='total_time' then
        self.data.total_time+=val
      elseif stat=='total_jumps' then
        self.data.total_jumps+=val
      elseif stat=='total_runs' then
        self.data.total_runs+=val
      elseif stat=='total_falls' then
        self.data.total_falls+=val
      elseif stat=='milestones' then
        self.data.milestones+=val
      elseif stat=='john_runs' then
        self.data.john_runs+=val
      elseif stat=='nathan_runs' then
        self.data.nathan_runs+=val
      elseif stat=='total_points' then
        self.data.total_points+=val
      elseif stat=='total_wins' then
        self.data.total_wins+=val
      end
    end,

    load_all=function(self)
      log('loading stats'..' '..self.data.total_time)
      for k,v in pairs(self.data) do
        self.data[k]=dget(self.store_address[k])
      end
    end,

    reset_all=function(self)
      log('resetting stats')
      for k,v in pairs(self.data) do
        self.data[k]=0
      end
    end,

    store_all=function(self)
      log('saving stats'..' '..self.data.total_time)
      for k,v in pairs(self.data) do
        log('saving '..k..': '..v)
        if (v) then
          dset(self.store_address[k], v)
        end
      end
    end
  }
  -- attempt to load stats from cartdata
  stats:load_all()
end

function u_stats()
  if (btnp(🅾️)) then
    sfx(1)
    extcmd('reset')
  end

  if (btn(❎)) then
    hold_reset+=1
    is_resetting=true
    if (hold_reset>180) then
      stats:reset_all()
      stats:store_all()
      sfx(2)
      hold_reset=0
      is_resetting=false
    end
  else
    hold_reset=0
    is_resetting=false
  end
end

function d_stats()
  local stat_offx = -40
  local stat_offy = -20
  -- jump sprite
  cls()

	spr(248, cam.x+2, 2, 2, 2) --tg logo
  print('SUPER GANTT RUNNER STATS', cam.x+16, cam.y+4, 7)

  line(cam.x+2, cam.y+12, cam.x+126, cam.y+12, 7) --line

  spr(46, cam.x+44+stat_offx, cam.y+35+stat_offy) --time
	print('total time: ', cam.x+56+stat_offx, cam.y+37+stat_offy, 6)
  print((stats.data.total_time / 60 / 60)..' hrs', cam.x+110+stat_offx, cam.y+37+stat_offy, 7)


	spr(18, cam.x+44+stat_offx, cam.y+45+stat_offy) --milestones
  print('milestones: ', cam.x+56+stat_offx, cam.y+47+stat_offy, 6)
  print(stats.data.milestones, cam.x+110+stat_offx, cam.y+47+stat_offy, 7)

  spr(102, cam.x+44+stat_offx, cam.y+55+stat_offy) --jumps
  print('total jumps: ', cam.x+56+stat_offx, cam.y+57+stat_offy, 6)
  print(stats.data.total_jumps, cam.x+110+stat_offx, cam.y+57+stat_offy, 7)

  spr(16, cam.x+44+stat_offx, cam.y+65+stat_offy) --score
  print('total pts: ', cam.x+56+stat_offx, cam.y+67+stat_offy, 6)
  print(stats.data.total_points, cam.x+110+stat_offx, cam.y+67+stat_offy, 7)

  -- runs
  spr(71, cam.x+44+stat_offx, cam.y+75+stat_offy) --runs
  print('nathan runs: ', cam.x+56+stat_offx, cam.y+77+stat_offy, 6)
  print(stats.data.nathan_runs, cam.x+110+stat_offx, cam.y+77+stat_offy, 7)

  spr(35, cam.x+44+stat_offx, cam.y+85+stat_offy) --john runs
  print('john runs: ', cam.x+56+stat_offx, cam.y+87+stat_offy, 6)
  print(stats.data.john_runs, cam.x+110+stat_offx, cam.y+87+stat_offy, 7)

  spr(103, cam.x+44+stat_offx, cam.y+96+stat_offy) --total runs
  print('total runs: ', cam.x+56+stat_offx, cam.y+97+stat_offy, 6)
  print(stats.data.total_runs, cam.x+110+stat_offx, cam.y+97+stat_offy, 7)

  -- wins
  spr(29, cam.x+44+stat_offx, cam.y+106+stat_offy) --wins
  print('total wins: ', cam.x+56+stat_offx, cam.y+107+stat_offy, 6)
  print(stats.data.total_wins, cam.x+110+stat_offx, cam.y+107+stat_offy, 7)

  spr(119, cam.x+44+stat_offx, cam.y+116+stat_offy) --falls
  print('total falls: ', cam.x+56+stat_offx, cam.y+117+stat_offy, 6)
  print(stats.data.total_falls, cam.x+110+stat_offx, cam.y+117+stat_offy, 7)


  print('🅾️ back to menu', cam.x+10, cam.y+121, 6)

  if (is_resetting) then
    rectfill(cam.x+2, cam.y+127, cam.x+hold_reset, cam.y+128, 8)
    print('resetting...', cam.x+84, cam.y+121, 8)
  else
    print('❎ reset', cam.x+84, cam.y+121, 8)
  end
end
