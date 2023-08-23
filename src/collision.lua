
function plat_collide(p)
	-- check for collision with platform
	if (p.dy < 0) then --moving upwards
		return false
	end

	for k,bar in ipairs(g.bars) do
		if player.x+8 >= bar.x0 and player.x <= bar.x1 then
			--early jump allowance 4px
			if player.feet_y+6 >= bar.y0 and player.feet_y <= bar.y1 then
				player.can_jump=true
			end

			--check if player is within platform y range
			if player.feet_y >= bar.y0 and player.feet_y <= bar.y1 then
				p.y=bar.y0-16 --ensure player is on top of platform

				if (player.on_platform == false) then
					sfx(player.sfx_land)
					dust(player.feet_x,player.feet_y+2,2,4,{5,6,7},3)
				end

				p.on_platform=true

				-- keep player on platform
				if (bar.speed > 0) then
					p.x-=bar.speed
				end
				return true
			end
		end
	end
	return false
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
