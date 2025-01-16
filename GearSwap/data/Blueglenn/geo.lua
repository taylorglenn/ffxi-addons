---------------------------------
-- required includes
---------------------------------
function get_sets()
	-- Load and initialize the include file. 
	mote_include_version = 2
	include('Mote-Include.lua')
end

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
	send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(24)
  
---------------------------------
-- macros 
---------------------------------
function set_macros(sheet, book)
	if book then
		send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
		return
	end
	send_command('@input / macro set ' .. tostring(sheet))
end
set_macros(1, 20)

---------------------------------
-- define gearsets
---------------------------------
function init_gear_sets()
	----------------
	--  Idle
	----------------
	sets.idle = {	

	}

	-- .Pet sets are for when Luopan is present
	sets.idle.Pet = set_combine(sets.idle, {

	})

	----------------
	--  Engaged
	----------------
	sets.engaged = {

	}
			
	----------------
	--  Precast
	----------------
	-- job abilities 
	sets.precast.JA = {

	}
	-- weapon skills
	sets.precast.WS = {

	}
	-- spells
	sets.precast.FC = { 

	}
	
	sets.precast.FC.Cure = { 
		
	}
	
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	----------------
	--  Midcast
	----------------
	sets.midcast.Geomancy = {

	}

	sets.midcast.Geomancy.Indi = set_combine(sets.midcast.Geomancy, {

	})

	sets.midcast['Enhancing Magic'] = {

	}

	sets.midcast['Elemental Magic'] = {

	}

	sets.midcast['Dark Magic'] = {

	}

	sets.midcast.Cure = {
		
	}
	----------------------
	--  Duration of Buff
	----------------------
  	sets.buff["Doom"] = { ring1 = "Saida Ring" }
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_buff_change(buff, gain) 
	-- Is triggered every time you either recieve a buff, or one wears off
	-- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
	handleBuffGear(buff, gain)
end
  
function job_buff_refresh(name, buff_details)
end

function job_state_change(field, newValue, oldValue)
	-- any mode changed
end
  
function job_precast(spell, action, spellMap, eventArgs)
end
  
function job_midcast(spell, action, spellMap, eventArgs)
end
  
function job_aftercast(spell, action, spellMap, eventArgs) 
end

---------------------------------
-- user defined functions 
---------------------------------
function chat(message)
	add_to_chat(123, message)
end
  
function handleBuffGear(buffName, gain)
	local buffSet = sets.buff[buffName]
	if buffSet == nil then return end 

	for slot,_ in pairs(buffSet) do
		toggleSlotForBuff(buffName, gain, slot)
	end
end
  
function toggleSlotForBuff(buffName, gain, slot)
	if gain then
		equip(sets.buff[buffName])
		disable(slot)
		chat('Slot disabled: ' .. slot .. ' - because ' .. buffName .. ' was activated.')
	else
		enable(slot)
		chat('Slot enabled: ' .. slot .. ' - because ' .. buffName .. ' has worn.')
	end
end