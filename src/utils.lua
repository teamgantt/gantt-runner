
function rnd_between(min, max, seed)
	if (seed) then srand(seed) end
	-- return a random number between min and max
	return flr(rnd(max-min))+min
end

function delay_frames(frames, callback)
	local t = 0
	return function()
		t += 1
		if t >= frames then
			callback()
		end
	end
end

function hcenter(s, c)
  -- screen center minus the
  -- string length times the
  -- pixels in a char's width,
  -- cut in half
	if (c == nil) c = {x=0}
  return c.x+64-#s*2
end
