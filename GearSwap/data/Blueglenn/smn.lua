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
set_lockstyle(9)
  
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
set_macros(1, 19)

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
    pos = { x = 0, y = 0 },
    text = { font = 'Consolas', size = 10 },
    bg = { alpha = 255 },
    flags = { draggable = false }
}
displayBox = texts.new('${value}', displaySettings)

---------------------------------
-- job setup
---------------------------------
function job_setup()
    bloodPactTables = loadBloodPactTables()
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
    state.IdleMode:options('Refresh', 'Low Perpetuation', 'MEVA', 'DT')
    send_command('bind ^i gs c cycle IdleMode')
  
    state.WeaponLock = M(false, 'Weapon Lock')
    send_command('bind ^w gs c cycle WeaponLock')

    drawDisplay()
  
    windower.register_event('prerender', drawDisplay)
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
    -- unload keybinds
    send_command('unbind ^i') -- unbinds IdleMode from i key
    send_command('unbind ^w') -- unbinds WeaponLock from w key
end

---------------------------------
-- define gearsets
---------------------------------
function init_gear_sets()
	----------------
	--  Idle
	----------------
	sets.idle = {	

	}

    sets.idle.Town = set_combine(sets.idle, {
        feet = "Hearld's Gaiters"
    })

    sets.idle.Refresh = set_combine(sets.idle, {

    })

    sets.idle['Low Perpetuation'] = set_combine(sets.idle, {

    })

    sets.idle.MEVA = set_combine(sets.idle, {

    })

    sets.idle.DT = set_combine(sets.idle, {

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
	sets.precast.JA['Elemental Siphon'] = {

    }
	-- weapon skills
	sets.precast.WS = {

	}
	-- spells
	sets.precast.FC = { 

	}

    sets.precast['Blood Pact'] = set_combine(sets.precast.FC, {

    })
	
	sets.precast.FC.Cure = set_combine(sets.precast.FC, { 
		
	})
	
	sets.precast.FC.Curaga = sets.precast.FC.Cure
	
	----------------
	--  Midcast
	----------------
    sets.midcast['Blood Pact'] = { }

	sets.midcast['Blood Pact'].Physical = {

    }

    sets.midcast['Blood Pact'].Magical = {
        
    }

    sets.midcast['Blood Pact'].Hybrid = {
        
    }

    sets.midcast['Blood Pact'].Buff = {
        
    }

    sets.midcast['Blood Pact'].Debuff = {
        
    }

    sets.midcast['Blood Pact'].Other = {
        
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
    drawDisplay()
end
  
function job_precast(spell, action, spellMap, eventArgs)
    -- handle bp spells
    if getBloodPactSpellType(spell.name) ~= '' then
        equip(sets.precast['Blood Pact'])
    end
end
  
function job_midcast(spell, action, spellMap, eventArgs)
    -- handle bp spells
    local bpSpellType = getBloodPactSpellType(spell.name)
    if bpSpellType ~= '' and sets.midcast['Blood Pact'][bpSpellType] ~= nil then
        equip(sets.midcast['Blood Pact'][bpSpellType])
    end
end
  
function job_aftercast(spell, action, spellMap, eventArgs) 
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
    local displayLines = L{}
  
    -- Modes
    displayLines:append('[I]dle: '..state.IdleMode.value)
    displayLines:append('[W]eapon Lock: '..tostring(state.WeaponLock.current))
  
    displayBox:text(displayLines:concat(' | '))
    displayBox:show()
end

---------------------------------
-- user defined functions 
---------------------------------
function getBloodPactSpellType(spellName) 
    for tableName, table in pairs(bloodPactTables) do 
        for tableSpell,_ in pairs(table) do
            if tostring(tableSpell):lower() == tostring(spellName):lower() then return tostring(tableName) end
        end
    end
    return ''
end

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

function loadBloodPactTables()
    return {
        Physical = S{
            'Punch',        'Rock Throw',       'Barracuda Dive',   'Claw',
            'Axe Kick',     'Shock Strike',     'Camisado',         'Regal Scratch',
            'Poison Nails', 'Moonlit Charge',   'Crescent Fang',    'Rock Buster',
            'Tail Whip',    'Double Punch',     'Megalith Throw',   'Double Slap',
            'Eclipse Bite', 'Mountain Buster',  'Spinning Dive',    'Predator Claws',
            'Rush',         'Chaotic Strike',   'Crag Throw',       'Volt Strike'
        },
        Magical = S{
            'Inferno',      'Earthen Fury',     'Tidal Wave',       'Aerial Blast',
            'Diamond Dust', 'Judgment Bolt',    'Searing Light',    'Howling Moon',
            'Ruinous Omen', 'Fire II',          'Stone II',         'Water II',
            'Aero II',      'Blizzard II',      'Thunder II',       'Thunderspark',
            'Somnolence',   'Meteorite',        'Fire IV',          'Stone IV',
            'Water IV',     'Aero IV',          'Blizzard IV',      'Thunder IV',
            'Nether Blast', 'Meteor Strike',    'Geocrush',         'Grand Fall',
            'Wind Blade',   'Heavenly Strike',  'Thunderstorm',     'Level ? Holy',
            'Holy Mist',    'Lunar Bay',        'Night Terror',     'Conflag Strike'
        },
        Hybrid = S{
            'Burning Strike',
            'Flaming Crush'
        },
        Buff = S{
            'Shining Ruby',     'Frost Armor',      'Rolling Thunder',  'Crimson Howl',
            'Lightning Armor',  'Ecliptic Growl',   'Hastega',          'Noctoshield',
            'Ecliptic Howl',    'Dream Shroud',     'Earthen Armor',    'Fleet Wind',
            'Inferno Howl',     'Soothing Ruby',    'Heavenward Howl',  'Soothing Current',
            'Hastega II',       'Crystal Blessing'
        },
        Debuff = S{
            'Lunar Cry',    'Mewing Lullaby',   'Nightmare',    'Lunar Roar',
            'Slowga',       'Ultimate Terror',  'Sleepga',      'Eerie Eye',
            'Tidal Roar',   'Diamond Storm',    'Shock Squall', 'Pavor Nocturnus'
        },
        Other = S{
            'Healing Ruby',     'Raise II',         'Aerial Armor', 'Reraise II',
            'Whispering Wind',  'Glittering Ruby',  'Earthen Ward', 'Spring Water',
            'Healing Ruby II'
        }
    }  
end 
