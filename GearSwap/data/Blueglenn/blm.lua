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
  set_lockstyle(2)
  
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
  set_macros(1, 39)
  
  ---------------------------------
  -- dislpay globals
  ---------------------------------
  displaySettings = 
  { 
    pos = 
    {
      x = 0,
      y = 0
    },
    text = 
    {
      font = 'Consolas',
      size = 10
    },
    bg = 
    {
      alpha = 255
    },
    flags = 
    {
      draggable = false
    }
  }
  displayBox = texts.new('${value}', displaySettings)
  
  ---------------------------------
  -- user globals
  ---------------------------------
  elemental = S{
    'Stone',    'Stone II',     'Stone III',    'Stone IV',     'Stone V',      'Stone VI',
    'Stonega',  'Stonega II',   'Stonega III',  'Stoneja',
    'Water',    'Water II',     'Water III',    'Water IV',     'Water V',      'Water VI', 
    'Waterga',  'Waterga II',   'Waterga III',  'Waterja',
    'Aero',     'Aero II',      'Aero III',     'Aero IV',      'Aero V',       'Aero VI',
    'Aeroga',   'Aeroga II',    'Aeroga III',   'Aeroja',
    'Fire',     'Fire II',      'Fire III',     'Fire IV',      'Fire V',       'Fire VI',
    'Firaga',   'Firaga II',    'Firaga III',   'Firaja',
    'Blizzard', 'Blizzard II',  'Blizzard III', 'Blizzard IV',  'Blizzard V',   'Blizzard VI',
    'Blizzaga', 'Blizzaga II',  'Blizzaga III', 'Blizzaja',
    'Thunder',  'Thunder II',   'Thunder III',  'Thunder IV',   'Thunder V',    'Thunder VI',
    'Thundaga', 'Thundaga II',  'Thundaga III', 'Thundaja',
    'Freeze', 'Freeze II', 'Tornado', 'Tornado II', 'Quake', 'Quake II', 'Burst', 'Burst II', 'Flood', 'Flood II', 'Flare', 'Flare II',
    'Meteor', 'Comet', 'Impact',
    debuffs = S{
        'Shock', 'Rasp', 'Choke', 'Frost', 'Burn', 'Drown'
    },
  }
  
  ---------------------------------
  -- job setup
  ---------------------------------
  function job_setup()

  end
  
  ---------------------------------
  -- user setup
  ---------------------------------
  function user_setup() 
    state.IdleMode:options('Normal')
    send_command('bind ^i gs c cycle IdleMode')
  
    state.OffenseMode:options('Normal', 'Melee')
    send_command('bind ^o gs c cycle OffenseMode')
  
    state.CastingMode:options('Free', 'Burst')
    send_command('bind ^c gs c cycle CastingMode')
  
    state.BurstingMode = M{ 'No Acc.', 'Low Acc.', 'Med. Acc.', 'High Acc.' }
    send_command('bind ^b gs c cycle BurstingMode')

    state.AfBody = M{ 'Off', 'On' }
  
    drawDisplay()
  
    windower.register_event('prerender', drawDisplay)
  end
  
  ---------------------------------
  -- user unload
  ---------------------------------
  function user_unload()
    -- unload keybinds
    send_command('unbind ^i') -- unbinds IdleMode from i key
    send_command('unbind ^o') -- unbinds OffenseMode from o key
    send_command('unbind ^c') -- unbinds CastingMode from c key
    send_command('unbind ^b') -- unbinds BurstingMode from b key
  end
  
  ---------------------------------
  -- define gearsets
  ---------------------------------
  function init_gear_sets()
    sets.idle = {
        waist = "Luminary Sash"
    }

    sets.idle.LatentRefresh = set_combine(sets.idle, {
        waist = "Sacro Cord"
    })

    sets['Melee'] = {

    }
  
    sets.precast.FC = { 
      
    }
  
    sets.midcast.Cure = { 
     
    }
  
    sets.midcast.Elemental = { 
     
    }
    sets.midcast.Elemental.Free = set_combine(sets.midcast.Elemental, {
  
    })
    sets.midcast.Elemental.Burst = set_combine(sets.midcast.Elemental, {
  
    })
    sets.midcast.Elemental.Burst['No Acc.'] = set_combine(sets.midcast.Burst, {

    })
    sets.midcast.Elemental.Burst['Low Acc.'] = set_combine(sets.midcast.Burst, {

    })
    sets.midcast.Elemental.Burst['Med. Acc.'] = set_combine(sets.midcast.Burst, {

    })
    sets.midcast.Elemental.Burst['High Acc.'] = set_combine(sets.midcast.Burst, {

    })
    sets.midcast.ElementalEnfeeble = {

    }

    sets.midcast.EnfeeblingMagic = {

    }

    sets.midcast.AspirDrain = {

    }

    sets.buff.ManaWall = { 

     }
  end 
  
  ---------------------------------
  -- display stuff
  ---------------------------------
  function drawDisplay()
    local displayLines = L{}
  
    -- Modes
    displayLines:append('[I]dle: '..state.IdleMode.value)
    displayLines:append('[O]ffense: '..state.OffenseMode.value)
    displayLines:append('[C]asting: '..state.CastingMode.value)
    displayLines:append('[B]ursting: '..state.BurstingMode.value)
    displayLines:append('Af Body: '..state.AfBody.value)
  
    if isSubSch() then
      local stratagemsAvailable = getStratagemsAvilable()
      displayLines:append(' - ')
      displayLines:append('Stratagems: '..tostring(stratagemsAvailable))
    end
  
    displayBox:text(displayLines:concat(' | '))
    displayBox:show()
  end
  
  ---------------------------------
  -- gearswap hooks
  ---------------------------------
  function job_buff_change(buff, gain) 
    -- Is triggered every time you either recieve a buff, or one wears off
    -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
    handleBuffGear(buff, gain)
    drawDisplay()
  end
  
  function job_buff_refresh(name, buff_details)
    drawDisplay()
  end
  
  function job_precast(spell, action, spellMap, eventArgs)
    
  end
  
  function job_midcast(spell, action, spellMap, eventArgs) 
    -----------------
    --  ELEMENTAL  --
    -----------------
    if (elemental:contains(spell.name)) then
        if (state.CastingMode.value == 'Burst') then 
            equip(sets.midcast.Elemental.Burst[state.BurstingMode.value])
            if (state.AfBody.value == 'On') then
                equip({ body = "Spaekona's Coat" })
            end
            return
        end

        equip(sets.midcast.Elemental.Free)
        return
    end

    ---------------------
    --  ASPIR / DRAIN  --
    ---------------------
    if (spell.name == 'Drain') then 
        equip(sets.AspirDrain)
        return
    end

    if (spell.name:startswith('Aspir')) then
        equip(sets.AspirDrain)
        local newSpell = spell.name
        local spell_recasts = windower.ffxi.get_spell_recasts()
        local aspirTable = {'Aspir','Aspir II','Aspir III'}
        if (spell_recasts[spell.recast_id] > 0 and table.contains(aspirTable, spell.name)) then
            spell_index = table.find(aspirTable, spell.name) -- TODO spell_index is returning null
            if (spell_index > 1) then
                newSpell = aspirTable[spell_index - 1]
                send_command('@input /ma '..newSpell..' '..tostring(spell.target.raw))
            end
        end
        return
    end

    -------------
    -- DEFAULT --
    ------------- 
    local skill = spell.skill
    if skill ~= nil and sets.midcast[skill] ~= nil then
      equip(sets.midcast[skill])
      return
    end
  end
  
  function job_aftercast(spell, action, spellMap, eventArgs) 
    drawDisplay()

    local player = windower.ffxi.get_player()

    if (player.status == 0 and player.vitals.mpp < 51) then
        equip(sets.idle.LatentRefresh)
        eventArgs.handled = true
        return
    end

    if (state.OffenseMode.value == 'Melee' and player.status == 1) then -- 1 is combat, 0 is idle
        equip(sets['Melee'])
        return
    end
  end
  
  function job_state_change(field, newValue, oldValue)
    -- any mode changed
    drawDisplay()
  end

function status_change(new, old)
    local player = windower.ffxi.get_player()
    if (player.status == 0) then 
        if (player.vitals.mpp < 51) then 
            equip(sets.idle.LatentRefresh)
        end
    end
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
  
  function getStratagemsAvilable() 
    if not isSubSch() then 
      return ''
    end
    -- get max possible
    local maxStrategems = 3 -- sch subjob 50
    -- returns recast in seconds
    local allRecasts = windower.ffxi.get_ability_recasts()
    local stratsRecast = allRecasts[231]
    if stratsRecast == nil then
      return maxStrategems
    end
    -- 3 strategems at 80s per recharge (because of M.Level 5)
    local fullRechargeTime = maxStrategems * 80
    local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)
  
    return currentCharges
  end

  function isSubSch()
    local player = windower.ffxi.get_player()
    if (player == nil) then return false end
    return player.sub_job == 'SCH'
  end
  