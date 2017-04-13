require "Collision"
require "2DGeometry"

local Q1 = Collision:SetSpell(1100, 800, .25, 125, true)
local qb = 0;
local sPos = 0;
Callback.Add("Draw", function() Draw2() end);
local function IsReady(slot)
	return myHero:GetSpellData(slot).currentCd == 0 and myHero:GetSpellData(slot).level > 0
end
-- 2Lazy2Merge
local function VectorExtendA(v,t,d)
	return v + d * (t-v):Perpendicular2():Normalized() 
end
local function VectorExtendB(v,t,d)
	return v + d * (t-v):Perpendicular():Normalized() 
end

local function GetBall()
	if qb ~= 0 then qb = 0; sPos = 0; end
	for i=1,Game.MissileCount() do
		local o = Game.Missile(i);
		if o.missileData.name == "VelkozQMissile" then
			sPos = o.missileData.startPos;
			qb = o;
		end
	end
end

function Draw2() 
	local p = GOS:GetTarget(1100, "AP");
	GetBall();
	if p and GOS:GetMode() == "Combo" then
		local pp = p:GetPrediction(1100,.25);
		local block, list = Q1:__GetCollision(myHero, pp, 5);
		if not block then
			if IsReady(_Q) and myHero:GetSpellData(slot).name == "VelkozQ" then
				Control.CastSpell(HK_Q, pp);
			end
			else
			if IsReady(_Q) then
				Q2(pp);
			end
		end
	end
end

function Q2(pr)
	for i= -math.pi*.5 ,math.pi*.5 ,math.pi*.09 do
		local one = 25.79618 * math.pi/180
		local an = myHero.pos + Vector(Vector(pr)-myHero.pos):Rotated(0, i*one, 0);
		local block, list = Q1:__GetCollision(myHero, an, 5);
		if not block then
			--Draw.Circle(an); Debug for pos
			if myHero:GetSpellData(slot).name == "VelkozQ" then
				Control.CastSpell(HK_Q, an);
				else
				if qb ~= 0 then
					local TA = VectorExtendA(Vector(qb.pos.x, qb.pos.y,qb.pos.z), sPos, 1100);
					local TB = VectorExtendB(Vector(qb.pos.x, qb.pos.y,qb.pos.z), sPos, 1100);
					local TC = Line(Point(TA), Point(TB));
					if TC:__distance(Point(pr)) < 200 then
						Control.CastSpell(HK_Q);
					end
				end
			end
		end
	end
end
