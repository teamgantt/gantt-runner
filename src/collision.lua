
function collide_map(obj,dir,flag)
	 local x=obj.x  local y=obj.y
	 local w=obj.w  local h=obj.h

	 local x1=0	 local y1=0
	 local x2=0  local y2=0

	 if dir=="left" then
		 x1=x-1  y1=y
		 x2=x    y2=y+h-1

	 elseif dir=="right" then
		 x1=x+w-1    y1=y
		 x2=x+w  y2=y+h-1

	 elseif dir=="up" then
		 x1=x+2    y1=y-1
		 x2=x+w-3  y2=y

	 elseif dir=="down" then
		 x1=x+2      y1=y+h
		 x2=x+w-3    y2=y+h
	 end

	 --pixels to tiles
	 x1/=8    y1/=8
	 x2/=8    y2/=8

	 if fget(mget(x1,y1), flag)
	 or fget(mget(x1,y2), flag)
	 or fget(mget(x2,y1), flag)
	 or fget(mget(x2,y2), flag) then
		 return true
	 else
		 return false
	 end

end

function milestone_collide()
	-- check for collision with milestone
	for k,mile in ipairs(milestones) do
		if (check_collision(player.x, player.y, 16, 16, mile.x, mile.y, 8, 8)) then
			prev_milestone_x = mile.x
			del(milestones, mile)
			player.milestones+=1
			sfx(2)
		end
	end
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end


function d_debug_hitboxes()
	if (debug) then
		rect(player.x, player.y, player.x+player.w, player.y+player.h, 8)
	end
end
