function i_camera_follow()
	cam={x=0,y=0}
  --map limits
  map_start=0
  map_end=1024
end

function u_camera_follow()
	cam.x=player.x-64+(player.w/2)
  if cam.x<map_start then
     cam.x=map_start
  end
  if cam.x>map_end-128 then
     cam.x=map_end-128
  end
  camera(cam.x,0)
end
