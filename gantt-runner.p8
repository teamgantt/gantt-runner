pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--gantt runner
--by tg devs

--pico imports (not lua syntax)
#include src/utils.lua
#include src/collectibles.lua
#include src/collision.lua
#include src/particles.lua
#include src/player.lua
#include src/camera.lua
#include src/game.lua
#include src/ui.lua

function _init()
	debug=false
	cam={x=0,y=0}
	i_player()
	i_gantt()
	i_milestone_anims()
	i_particles()
end

function _update()
	u_player()
	u_gantt()
	u_milestone_anims()
	u_fx()
end

function _draw()
	cls(12)
	d_fx()
	d_gantt()
	d_milestone_anims()
	d_camera_follow()
	d_player()
	d_ui()

	--debug stuff
	if (debug) then
		print("can jump: "..tostr(player.can_jump)..', status:'..player.move, cam.x, cam.y, 9)
		print("dy:"..tostr(player.dy)..' dx:'..tostr(player.dx),cam.x, cam.y+10,7)
		print("player.x:"..flr(player.x), cam.x, cam.y+20, 7)
		print("player.y:"..flr(player.y), cam.x, cam.y+30, 7)
	end
end


-->8
--john

-->8
--gantt bars


-->8
--collide check

-->8
--milestone

--TODO: put this somewhere else


-->8
--particles


__gfx__
00000000011650000116500001165000011650000116500000000000000000000000000000000000000011115550000000001111555000000000111155500000
00000000011560000115600001156000011560000115600000000000000000000000000000000000000111156565000000011115656500000001111565650000
00700700011111100111111001111110011111100111111000000000000000000000000000000000000111155655000000011115565500000001111556550000
0007700004fff00004fff00004fff00004fff00004fff00000000000000000000000000000000000000111155565000000011115556500000001111555650000
0007700000fff00000fff00000fff00000fff00000fff00000000000000000000000000000000000001111111111110000111111111111000011111111111100
0070070001111500001110000011100000111000001110000000000000000000000000000000000000055fffffff000000055fffffff000000055fffffff0000
000000000f555f0000f55000001f5000005f5000001f5000000000000000000000000000000000000005fff5ff5ff0000005fff5ff5ff0000005fff5ff5ff000
0000000000505000050005000050500000550000005050000000000000000000000000000000000000005fffffff000000005fffffff0000ff005fffffff0000
0000000001165000000af0000009700000097000000a90000009a00000099000000a7000000a9000000015fffff00000000015fffff00000ff1015fffff00000
000000000115600000aaaf000099a7000009a00000a99900009a9a0000aa9900000a9000007aa90000011111110000000001111111000000ff1111111ddff000
00000000011111100aaa7af0009aaa000009a000009a990009a999a000a99900000a900000aaa900001111111d100000ff1111111d1ff00000111111111ff000
0000000004fff000aaaaaaaf009aaa000009a00000a999009a9a999a00aa9900000a900000aaa9000011111111100000ff111111111ff0000000111111100000
0000000000fff0009aaaaaaa009aaa000009a000009a9900a9a9999900a99900000a900000aaa90000ffff111ff00000000011111000000011dd111111111000
00000000f1111f0009aaaaa0009aaa000009a00000a999000a9a999000aa9900000a900000aaa90000fffddddff00000001dddddd110000011ddddddddd11000
0000000000555000009aaa000099aa000009a000009a990000a9990000a99900000a900000aaa9000000dd0dd0000000001ddd0d111000001100000000110000
00000000050005000009a0000009a0000009a0000009a000000a9000000a9000000a9000000a9000000011011100000000110000110000000000000000000000
00001111555000000000111115500000000011111550000000001111555000000000001155500000000000000000000000000000000000000000000000000000
00011115656500000001111155650000000111115565000000011115656500000000011155650000000000000000000000000000000000000000000000000000
00011115565500000001111155560000000111115556000000011115565500000000111155560000077777777777777700000000000000000000000000000000
0001111555650000000111115565000000011111556500000001111555650000000011115511110007ccccccccccccc700000000000000000000000000000000
0011111111111100001111111111110000111111111111000011111111111100000011111111000007ccccccccccccc700000000000000000000000000000000
00055fffffff00000005555fffff00000005555fffff000000055fffffff00000fff111ff5f0000007ccccccccccccc700000000000000000000000000000000
0005fff5ff5ff000000555fff5f50000000555fff5f500000005fff5ff5ff0000fff15fffff00000077777777777777700000000000000000000000000000000
00005fffffff0000000055ffffff0000000055ffffff0000ff005fffffff00000ffff55ffff00000000007bbbbbbbbb700000000000000000000000000000000
000015fffff000000000155ffff000000000155ffff00000ff1015fffff00ff001110555ff0fff00000007bbbbbbbbb700000000000000000000000000000000
000111111100000000011111110000000000111111000000ff1111111dd11ff000111111111fff00000007bbbbbbbbb700000000000000000000000000000000
001111111d100000ff1111111d1ff000000111111d00000000111111111110000001111111100000000007777777777700000000000000000000000000000000
0011111111100000ff111111111ff0000001fff111f00000000011111110000000001111100000000000000007ddddd700000000000000000000000000000000
00ffff111ff0000000001111100000000000fff11ff00000011d11111111100000001111100000000000000007ddddd700000000000000000000000000000000
00fffddddff00000001dddddd110000000001dddd0000000011dddddddd110000000dd0dd00000000000000007ddddd700000000000000000000000000000000
0000dd0dd0000000001ddd0d1110000000001dd11000000001100000001100000001dd0dd1000000000000000777777700000000000000000000000000000000
00001101110000000011000011000000000000111000000000000000000000000001100011000000000000000000000000000000000000000000000000000000
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777777af777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777aaaf77777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777777aaa7af7777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777aaaaaaaf777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777779aaaaaaa777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777779aaaaa7777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777777777777777777777777777779aaa77777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777777777777777777777777777779a777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777111155577777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111565657777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111556557777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111555657777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777711111111111177777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777755fffffff7777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777775fff5ff5ff777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777775fffffff7777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777777715fffff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777771111111777777777777777777777777777777777777777777777777777777777777777777777777777777777777
7777777777777777777777777777777777771111111d177777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777711111111177777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777ffff111ff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
777777777777777777777777777777777777fffddddff77777777777777777777777777777777777777777777777777777777777777777777777777777777777
99999999999999999999999999999999999999dd9dd9999999999999999999999999999999999999999999999999999999999999999999999999999999999999
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa11a111aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
9aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777

__sfx__
000c05001951024511285002c5002f5002f5002250022500225000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
180800000906302003010030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003
000b00002f03034055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
540600000173300703017030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703007030070300703
