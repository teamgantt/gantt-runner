
function rnd_between(min, max)
	return flr(rnd(max-min+1))+min
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
