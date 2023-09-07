function i_camera_follow()
	cam={x=0,y=0}
end

function u_camera_follow()
	cam.x=player.x-60
 	cam.y=0

	cam.x=mid(0, cam.x, 896)
	cam.y=mid(0, cam.y, 64)

	camera(cam.x, cam.y)
end
