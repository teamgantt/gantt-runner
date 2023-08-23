
function i_particles()
  --particles
  effects = {}

  --effects settings
  explode_size = 5
  explode_colors = {8,9,6,5}
  explode_amount = 5

  --sfx
  -- trail_sfx = 0
  -- explode_sfx = 1
  -- fire_sfx = 2

end

function add_fx(x,y,die,dx,dy,grav,grow,shrink,r,c_table)
  local fx={
      x=x,
      y=y,
      t=0,
      die=die,
      dx=dx,
      dy=dy,
      grav=grav,
      grow=grow,
      shrink=shrink,
      r=r,
      c=0,
      c_table=c_table
  }
  add(effects,fx)
end

function u_fx()
  for fx in all(effects) do
      --lifetime
      fx.t+=1
      if fx.t>fx.die then del(effects,fx) end

      --color depends on lifetime
      if fx.t/fx.die < 1/#fx.c_table then
        fx.c=fx.c_table[1]
      elseif fx.t/fx.die < 2/#fx.c_table then
          fx.c=fx.c_table[2]
      elseif fx.t/fx.die < 3/#fx.c_table then
          fx.c=fx.c_table[3]
      else
          fx.c=fx.c_table[4]
      end

      --physics
      if fx.grav then fx.dy+=.25 end
      if fx.grow then fx.r+=.075 end
      if fx.shrink then fx.r-=.075 end

      --move
      fx.x+=fx.dx
      fx.y+=fx.dy
  end
end

function d_fx()
  for fx in all(effects) do
      --draw pixel for size 1, draw circle for larger
      if fx.r<=1 then
          pset(fx.x,fx.y,fx.c)
      else
          circfill(fx.x,fx.y,fx.r,fx.c)
      end
  end
end

-- poof effect
function dust(x,y,r,l,c_table,num)
for i=0, num do
    --settings
    add_fx(
        x,         -- x
        y,         -- y
        l+rnd(3), -- die
        rnd(2)-1,  -- dx
        rnd(2)-3,  -- dy
        true,      -- gravity
        false,     -- grow
        true,      -- shrink
        r,         -- radius
        c_table    -- color_table
    )
end
end
