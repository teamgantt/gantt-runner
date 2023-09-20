
function i_particles()
  --particles
  effects = {}
  poof_life=10
end

function add_poof(x,y,dir)
  local fx={
      x=x,
      y=y,
      t=0,
      dx=2,
      dy=2,
      dir=dir,
  }
  if (dir=='l') fx.dx=1
  if (dir=='r') fx.dx=-1

  add(effects,fx)
end

function u_fx()
  for fx in all(effects) do
      --snap y value to ground 8px increments
      if fx.y%8!=0 then
        if fx.y%8==0 then fx.y=flr(fx.y/8)*8 end
      end

      --lifetime
      fx.t+=1
      if fx.t>poof_life then del(effects,fx) end

      --move
      fx.x+=fx.dx
  end
end

function d_fx()
  for fx in all(effects) do
    -- draw cloud sprites depending on fx time alive
    local flip=false
    if fx.dir=='l' then flip=true end

    -- change sprites to 1 of 3 sprites depending on lifetime
    local s=58
    if fx.t<poof_life/3 then s=58
    elseif fx.t<poof_life/3*2 then s=59
    else s=43 end

    spr(s,fx.x,fx.y,1,1,flip)
  end
end

