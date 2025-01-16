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
set_lockstyle(08)

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
set_macros(1, 2)

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
-- job setup
---------------------------------
--function job_setup()
  
--end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Two Hand', 'Sword & Board', 'Dual Wield')
  send_command('bind ^o gs c cycle OffenseMode')

  state.AccuracyMode = M{'None', 'Extra Acc.'}
  send_command('bind ^a gs c cycle AccuracyMode')

  drawDisplay()

  windower.register_event('prerender', drawDisplay)

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.war = 
  {
    capes = 
    { 
      tp = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+9','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
      ws_vit = { name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},
    },
    
    neck = "War. Beads +1",

    artifact = 
    {  
      head  = "Pumm. Mask +1",
      body  = "Pumm. Lorica +2",
      hands = "Pumm. Mufflers +1",
      legs  = "Pumm. Cuisses +2",
      feet  = "Pumm. Calligae +3" 
    },
  
    relic = 
    { 
      head  = "Agoge Mask +3",
      body  = "Agoge Lorica +1",
      hands = "Agoge Mufflers +3",
      legs  = "Agoge Cuisses +1",
      feet  = "Agoge Calligae +1" 
    },
  
    empyrean = 
    { 
      head  = "Boii Mask +2",
      body  = "Boii Lorica +1",
      hands = "Boii Mufflers +1",
      legs  = "Boii Cuisses +1",
      feet  = "Boii Calligae +1" 
    },
  }

end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds OffenseMode from o key
  send_command('unbind ^a') -- unbinds AccuracygMode from a key
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = 
  {
    ammo = "Staunch Tathlum",
    head = gear.globals.nyame.head,
    body = gear.globals.nyame.body,
    hands= gear.globals.nyame.hands,
    legs = gear.globals.nyame.legs, 
    feet = "Hermes' Sandals",
    neck = "Bathy Choker +1",
    waist= "Flume Belt",
    ear1 = "Infused Earring",
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Shneddick Ring",
    back = "Moonbeam Cape",
  }

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged =
  {
    ammo = "Coiste Bodhar",
    head = gear.globals.war.empyrean.head,
    body = "Dagon Breast.",
    hands= gear.globals.sakpata.hands,
    legs = gear.globals.war.artifact.legs,
    feet = gear.globals.war.artifact.feet,
    neck = gear.globals.war.neck,
    waist= "Ioskeha Belt",
    ear1 = "Telos Earring",
    ear2 = "Cessance Earring",
    ring1= "Chirich Ring +1",
    ring2= "Petrov Ring",
    back = gear.globals.war.capes.tp,
  }

  sets.engaged['Two Hand'] = set_combine(sets.engaged, {
    hands= gear.globals.sakpata.hands
  })

  sets.engaged['Sword & Board'] = set_combine(sets.engaged, {
      body = "Hjarrandi Breast.",
      hands= gear.globals.sakpata.hands,
      legs = gear.globals.war.artifact.legs,
      feet = gear.globals.war.artifact.feet,
      waist= "Sailfi Belt +1",
    }
  )

  sets.engaged['Dual Wield'] = set_combine(sets.engaged, {
    hands= gear.globals.war.relic.hands
  })

  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA["Berserk"] = 
  {
    body = gear.globals.war.artifact.body,
    feet = gear.globals.war.relic.feet,
    back = gear.globals.war.capes.tp
  }

  sets.precast.JA["Blood Rage"] = 
  {
    body = gear.globals.war.empyrean.body
  }

  sets.precast.JA["Restraint"] = 
  {
    hands= gear.globals.war.empyrean.hands
  }

  sets.precast.JA["Retaliation"] = 
  {
    hands= gear.globals.war.artifact.hands,
    feet = gear.globals.war.empyrean.feet
  }

  sets.precast.JA["Warcry"] = 
  {
    head = gear.globals.war.relic.head
  }

  ---------------------------------
  -- Buff Sets
  ---------------------------------
  --sets.buff.Retaliation = sets.precast.JA.Retaliation

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS = 
  {
    ammo = "Knobkierrie",
    head = gear.globals.war.relic.head,
    body = gear.globals.war.artifact.body,
    hands= gear.globals.valorous.hands.wsd,
    legs = gear.globals.war.artifact.legs,
    feet = gear.globals.sulevia.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = gear.globals.moonbeam,
    ear2 = "Ishvara Earring",
    ring1= "Epaminondas's Ring",
    back = gear.globals.war.capes.ws_vit
  } 

  -- Upheaval: 85% VIT - Dynamic fTP: 1.0 / 3.5 / 6.5
  sets.precast.WS["Upheaval"] = set_combine(sets.precast.WS, {
      legs = gear.globals.sakpata.legs,
      waist= "Sailfi Belt +1",
      ear2 = "Thrud Earring",
      ring1= "Supershear Ring",
      ring2= "Petrov Ring",
      back = gear.globals.war.capes.ws_vit
    }
  )

  sets.precast.WS["Full Break"] = set_combine(sets.precast.WS, {
      head = gear.globals.sakpata.head,
      body = gear.globals.sakpata.body,
      hands= gear.globals.sakpata.hands,
      legs = gear.globals.sakpata.legs,
      feet = gear.globals.sakpata.feet,
      neck = "Moonlight Necklace",
      ring1= "Stikini Ring +1",
      ring2= "Stikini Ring",
      ear2 = "Hermetic Earring",
      waist= "Eschan Stone"
    }
  )

  sets.precast.WS["Savage Blade"] = set_combine(sets.precast.WS, {
      
    }
  )

  sets.precast.WS["Black Halo"] = set_combine(sets.precast.WS, {
      neck = gear.globals.war.neck,
      waist= "Sailfi Belt +1"
    }
  )
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local displayLines = L{}

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[A]ccuracy: '..state.AccuracyMode.value)

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
  -- local status = getPlayerStatus()
  -- -- equip appropriate set absed on status
  -- if status ~= nil then 
  --   -- idle
  --   if status == 'idle' then 
  --     if state.IdleMode.value == 'Normal' then
  --       equip(sets.idle)
  --     end
  --   -- combat
  --   elseif status == 'combat' then
  --     handleOffenseSet()
  --   end
  --   eventArgs.handled = true;
  -- end
  drawDisplay()
end

function job_state_change(field, newValue, oldValue) -- any mode changed
  -- if newValue == oldValue then return end
  -- local status = getPlayerStatus()
  -- if field == 'Offense Mode' and status == 'combat' then
  --   handleOffenseSet()
  -- end

  drawDisplay()
end

---------------------------------
-- user defined functions 
---------------------------------
function getPlayerStatus() 
  local playerStatus = windower.ffxi.get_player().status
  local statusTable = {
    [0  ] = 'idle',
    [1  ] = 'combat',
    [33 ] = 'healing'
  }
  return statusTable[playerStatus]
end

function handleOffenseSet()
  local offenseMode = state.OffenseMode.value

  if sets.engaged[offenseMode] ~= nil then
    equip(sets.engaged[offenseMode])
  else
    equip(sets.engaged)
  end
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

---------------------------------
-- data
---------------------------------
