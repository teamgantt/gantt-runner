function i_camera_follow()
	cam_x=0
  cam_y=0
  --map limits
  map_start=0
  map_end=1024
end

function u_camera_follow()
	cam_x=player.x-64+(player.w/2)
  if cam_x<map_start then
     cam_x=map_start
  end
  if cam_x>map_end-128 then
     cam_x=map_end-128
  end
  camera(cam_x,0)
end
