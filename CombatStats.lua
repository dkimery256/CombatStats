--[[ Code To Calculate Combat Stats ]]

-- TODO Add helpers to a module
--[[ Helpers ]]
-- x = value to round
-- n = decimal places
local function round(x, n)
	n = math.pow(10, n or 0)
	x = x * n
	if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
	return x / n
end

-- TODO add Crit Chance
--[[ Melee ]]

-- Access variables for melee data
local LOW_DAMAGE        = 'Main Hand Low Damage:  '
local HI_DAMAGE         = 'Main Hand High Damage:  '
local OFF_LOW_DAMAGE    = 'Off Hand Low Damage:  '
local OFF_HI_DAMAGE     = 'Off Hand High Damage:  '
--local POS_BUFF          = 'Positive Buff:           '
--local NEG_BUFF          = 'Negiative Buff:          '
--local PERCENT_MOD       = 'Percent Mod:             '
local MAIN_ATTACK_SPEED = 'Main Hand Attack Speed:  '
local OFF_ATTACK_SPEED  = 'Off Hand Attack Speed:  '
local DPS               = 'Main Hand DPS:  '
local OFF_DPS           = 'Low Hand DPS:  '
local TOTAL             = 'Total DPS:  '

-- this will have to do until I can figure out how to sort better
local melee_order = {LOW_DAMAGE,HI_DAMAGE,OFF_LOW_DAMAGE,OFF_HI_DAMAGE,MAIN_ATTACK_SPEED,OFF_ATTACK_SPEED,DPS,OFF_DPS,TOTAL}

local function printMelee(meleeData)
	print('|cff00ccffMelee Combat Stats:|r\n')
	for i,v in ipairs(melee_order) do
		-- get and print the label value
		k = melee_order[i]
		print('|cffffcc00'..k..'|r')
		
		-- get and print the data value
		v = meleeData[v]
		v = round(v, 2) -- round to the nearst 2 digit	
		-- add some color coding
		--[[if k == POS_BUFF then
			v = '|cff00ff00'..v..'|r'
		end
		if k == NEG_BUFF then
			v = '|cffff0000'..v..'|r'
		end ]]
		if k == TOTAL then -- color code the total
			v = '|cffADFF2F'..v..'|r'
		end
		print(v)
	end
end

local function melee()
	-- get the melee data needed to be useful
	local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player")
	local mainAtSp, offAtSp = UnitAttackSpeed("player")
	
	-- handle no off hand weapon
	if offlowDmg == nil then offlowDmg = 0 end
	if offhiDmg  == nil then offhiDmg  = 0 end
	if offAtSp   == nil then offAtSp   = 0 end

	-- melee data table
	local meleeData = {}
	meleeData[LOW_DAMAGE]         = lowDmg
	meleeData[HI_DAMAGE]          = hiDmg
	meleeData[OFF_LOW_DAMAGE]     = offlowDmg
	meleeData[OFF_HI_DAMAGE]      = offhiDmg
	-- meleeData[POS_BUFF]           = posBuff
	-- meleeData[NEG_BUFF]           = negBuff
	-- meleeData[PERCENT_MOD]        = percentmod
	meleeData[MAIN_ATTACK_SPEED]  = mainAtSp
	meleeData[OFF_ATTACK_SPEED]   = offAtSp
	
	-- Calculate DPS ((Min Weapon Damage + Max Weapon Damage) / 2) / Weapon Speed
	local maindps = ((lowDmg + hiDmg) / 2) / mainAtSp
	local offdps = 0
	if offAtSp ~= 0 then 
		offdps = ((offlowDmg + offhiDmg) / 2) / offAtSp
	end
	
	-- add dps to the data
	local totaldps = maindps + offdps
	meleeData[TOTAL]   = totaldps
	meleeData[DPS]     = maindps
	meleeData[OFF_DPS] = offdps
	
	-- Print out the melee data
	printMelee(meleeData)
end

local function combatStats(msg, editbox)
	if msg == '-m' or msg == 'melee' then
		melee()
	end
end

SLASH_CS1 = '/cs'

SlashCmdList["CS"] = combatStats