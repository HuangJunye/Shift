pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- shift
--by kirais

function _init()
 t=0
 ship = {
  sp=1,
  x=60,
  y=100,
  h_max=4,
  h=4,
  p=0,
  t=0,
  inv=false, -- invincibility
  box={x1=0,y1=0,x2=6,y2=6}
 }
 bullets = {}
 enemies = {}
 -- genereate enemies
 for i=1,4 do
 	add(enemies, {
 		sp=33,
 	 m_x=i*16,
 		m_y=60-i*8,
 		x=-32,
 		y=-32,
 		r=10,
 		box={x1=0,y1=0,x2=7,y2=7}
 		})
 end
 
 start()
end

function start()
 _update = update_game
 _draw = draw_game
end

function game_over()
 _update = update_over
 _draw = draw_over
end

function update_over()
end

function draw_over()
 cls()
 print("game over",50,50,4)
end

function abs_box(s)
 local box = {}
 box.x1 = s.box.x1 + s.x
 box.y1 = s.box.y1 + s.y
 box.x2 = s.box.x2 + s.x
 box.y2 = s.box.y2 + s.y
 return box
end

function coll(a,e)
 local box_a = abs_box(a)
 local box_e = abs_box(e)
 
 if box_a.x1 > box_e.x2 or
    box_a.y1 > box_e.y2 or
    box_a.x2 < box_e.x1 or
    box_a.y2 < box_e.y1 then
  return false
 end
 
 return true
end

function fire()
 local b = {
  sp=3,
  x=ship.x,
  y=ship.y,
  dx=0,
  dy=-3,
  box={x1=2,y1=0,x2=4,y2=2}
 }
 add(bullets,b)
end

function update_game()
 t=t+1
 -- invincibility
 if ship.inv then
  ship.t += 1
  if ship.t > 30 then
   ship.inv = false
   ship.t = 0
  end
 end
 -- move enemies
 for e in all(enemies) do
  e.x = e.r*sin(t/40) + e.m_x
  e.y = e.r*cos(t/40) + e.m_y
  if coll(ship,e) and not ship.inv then
   ship.inv = true
   ship.h -= 1
   if ship.h <= 0 then
    game_over()
   end
  end
 end
 -- move bullets
 for b in all(bullets) do
  b.x+=b.dx
  b.y+=b.dy
  -- remove bullets out of screen
  if b.x < 0 or b.x > 128 or 
   b.y < 0 or b.y > 128 then
   del(bullets,b)
  end

  -- hit enemy and score
  for e in all(enemies) do
   if coll(b,e) then
    del(enemies,e)
    ship.p += 1
   end
  end
 end
 
 if(t%8<4) then
  ship.sp=1
 else
  ship.sp=2
 end
 
 if btn(0) then ship.x-=2 end
 if btn(1) then ship.x+=2 end
 if btn(2) then ship.y-=2 end
 if btn(3) then ship.y+=2 end
 if btnp(4) then fire() end
end


function draw_game()
 cls()
 -- display point
 print(ship.p,0,0)  
  
 -- draw health
 for i=1,ship.h_max do
  if i<=ship.h then
   spr(49,98+6*i,0)
  else
   spr(50,98+6*i,0)
  end
 end
 
 -- invincibility
 if not ship.inv or t%8<4 then
  -- draw ship
  spr(ship.sp,ship.x,ship.y)
 end
 -- draw bullets
 for b in all(bullets) do
  spr(b.sp,b.x,b.y)
 end
 -- draw enemies
 for e in all(enemies) do
  spr(e.sp,e.x,e.y)
 end
end
__gfx__
00000000000900000009000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000900000009000000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700006160000061600000c0c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000006660000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066666000666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700660a0660660a066000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000060a0a06060a0a06000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000a00000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000bbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b777b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b777b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000bb70b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b00b00b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000080800000606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888880006666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088800000666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000013130000121200140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000121212000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
