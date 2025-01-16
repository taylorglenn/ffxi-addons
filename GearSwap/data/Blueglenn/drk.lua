---------------------------------
-- includes
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
  set_lockstyle(02)

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
  set_macros(1, 1)
  
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

  end
  
  ---------------------------------
  -- user setup
  ---------------------------------
  function user_setup() 
    state.IdleMode:options('Normal')
    send_command('bind ^i gs c cycle IdleMode')
  
    state.OffenseMode:options('Normal')
    send_command('bind ^o gs c cycle OffenseMode')
  
    drawDisplay()
  end
  
  ---------------------------------
  -- user unload
  ---------------------------------
  function user_unload()
    -- unload keybinds
    send_command('unbind ^i') -- unbinds IdleMode from i key
    send_command('unbind ^o') -- unbinds OffenseMode from o key
  end
  
  ---------------------------------
  -- define gear sets
  ---------------------------------
  function init_gear_sets()
    ---------------------------------
    -- idle
    ---------------------------------
    sets.idle = { 
        
    }
    
    ---------------------------------
    -- Melee
    ---------------------------------
    sets.engaged = {  
      
    }

    ---------------------------------
    -- Spells
    ---------------------------------
    sets.midcast.DarkMagic = { 
     
    }
  
    ---------------------------------
    -- Job Abilities
    ---------------------------------
      
    ---------------------------------
    -- Weapon Skills
    ---------------------------------
    sets.precast.WS = { 

    }
  end
  
  ---------------------------------
  -- display stuff
  ---------------------------------
  function drawDisplay()
    local INDENT = ' ':rep(3)
    local displayLines = L{}
  
    -- Modes
    displayLines:append('[I]dle: '..state.IdleMode.value)
    displayLines:append('[O]ffense: '..state.OffenseMode.value)
  
    displayBox:text(displayLines:concat(' | '))
    displayBox:show()
  end
  
  ---------------------------------
  -- built-in gearswap functions
  ---------------------------------
  function job_buff_change(buff, gain) 
    -- Is triggered every time you either recieve a buff, or one wears off
    -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
    handleBuffGear(buff, gain)
  end 
  
  function job_update(cmdParams, eventArgs)
    
  end
  
  function job_precast(spell, action, spellMap, eventArgs)

  end
  
  function job_state_change(field, newValue, oldValue)
    -- any mode changed
    drawDisplay()
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
  