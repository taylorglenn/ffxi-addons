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
set_lockstyle(15)

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
set_macros(1, 10)

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
  state.IdleMode:options('Regular', 'Def/Vit', 'Refresh')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Hybrid', 'Tanking', 'All out DPS')
  send_command('bind ^o gs c cycle OffenseMode')

  drawDisplay()
  windower.register_event('prerender', drawDisplay)

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.run = {
    capes = { 
      tp         = { name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10',}},
      parry_tank = { name="Ogma's Cape", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Enmity+10','Parrying rate+4%',}},
    },
    
    neck = "Futhark Torque +1",

    artifact = {  
      head  = "Rune. Bandeau +1",
      body  = "Runeist Coat +1",
      hands = "Runeist Mitons +1",
      legs  = "Rune. Trousers +1",
      feet  = "Runeist Bottes +1" 
    },
  
    relic = {     
      head  = "Fu. Bandeau +3",
      body  = "Futhark Coat +3",
      hands = "Futhark Mitons +3",
      legs  = "Fu. Trousers +3",
      feet  = "Futhark Boots +3" 
    },
  
    empyrean = {  
      head  = "Erilaz Galea +1",
      body  = "Erilaz Surcoat +1",
      hands = "Erilaz Gauntlets +1",
      legs  = "Eri. Leg Guards +1",
      feet  = "Erilaz Greaves +1" 
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
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = {  
    ammo  = "Staunch Tathlum",
    head  = gear.globals.nyame.head,
    body  = gear.globals.run.artifact.body,
    hands = gear.globals.nyame.hands,
    legs  = gear.globals.carmine.legs,
    feet  = "Hermes' sandals",
    ring1 = "Defending Ring",
    ring2 = "Shneddick Ring",
    back  = "Moonbeam Cape",
  }

  sets.idle.Regular = set_combine(sets.idle, {
    neck  = gear.globals.run.neck,
    ear1  = "Etiolation Earring",
    ear2  = "Erilaz Earring",
    waist = "Engraved Belt",
  })

  sets.idle['Def/Vit'] = set_combine(sets.idle, {
    body  = gear.globals.nyame.body,
    legs  = gear.globals.nyame.legs,
    feet  = gear.globals.nyame.feet,
    neck  = "Elite Royal Collar",
    waist = "Engraved Belt",
    ear1  = "Tuisto Earring",
    ear2  = "Genmei Earring",
    ring2 = "Gelatinous Ring +1",
  })

  sets.idle.Refresh = set_combine(sets.idle, {
    ammo  = "Homiliary",
    head  = "Rawhide Mask",
    --hands = "Regal Gauntlets",
    neck  = "Bathy Choker +1",
    waist = "Flume Belt",
    ear2  = "Tuisto Earring",
    ear1  = "Etiolation Earring",
    ring1 = "Stikini Ring +1",
  })

  ---------------------------------
  -- engaged
  ---------------------------------
  sets.engaged = {  
    ammo  = "Staunch Tathlum",
  }

  sets.engaged.Hybrid = set_combine(sets.engaged, {  
    head  = gear.globals.adhemar.head,
    body  = "Ashera Harness",
    hands = gear.globals.adhemar.hands,
    legs  = gear.globals.nyame.legs,
    feet  = gear.globals.nyame.feet,
    neck  = gear.globals.run.neck,
    waist = "Windbuffet Belt +1",
    ear1  = "Sherida Earring",
    ear2  = "Telos Earring",
    ring1 = "Moonlight Ring",
    ring2 = "Moonlight Ring",
    back  = gear.globals.run.capes.parry_tank,
  }) 

  sets.engaged.Tanking = set_combine(sets.engaged, {  
    head  = gear.globals.run.relic.head,
    body  = gear.globals.run.artifact.body,
    hands = "Turms Mittens +1",
    legs  = gear.globals.run.empyrean.legs,
    feet  = "Turms Leggings +1",
    neck  = gear.globals.run.neck,
    waist = "Engraved Belt",
    ear1  = "Tuisto Earring",
    ear2  = "Eabani Earring",
    ring1 = "Defending Ring",
    ring2 = "Gelatinous Ring +1",
    back  = gear.globals.run.capes.parry_tank,
  }) 

  sets.engaged['All out DPS'] = set_combine(sets.engaged, {  
    ammo  = "Aurgelmir Orb",
    head  = gear.globals.adhemar.head,
    body  = gear.globals.adhemar.body,
    hands = gear.globals.adhemar.hands,
    legs  = "Samnuha Tights",
    feet  = gear.globals.herculean.feet.ta_att,
    neck  = "Anu Torque",
    waist = "Windbuffet Belt +1",
    ear1  = "Telos Earring",
    ear2  = "Cessance Earring",
    ring1 = "Ilabrat Ring",
    ring2 = "Epona's Ring",
    back  = gear.globals.run.capes.tp,
  }) 

  ---------------------------------
  -- Job Abilities
  ---------------------------------
	
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS = {
    ear1 = "Sherida Earring",
    ear2 = gear.globals.moonshade,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
  }

  sets.precast.WS["Dimidiation"] = set_combine(sets.precast.WS, { 
    ammo = "Knobkierrie",
    head = gear.globals.lustratio.head,
    body = gear.globals.adhemar.body,
    hands= gear.globals.meghanada.hands,
    legs = gear.globals.lustratio.legs,
    feet = gear.globals.lustratio.feet,
    ring2= "Chirich Ring +1",
    ring1= "Ilabrat Ring",
  })

  sets.precast.WS["Resolution"] = set_combine(sets.precast.WS, { 
    ammo = "Seeth. Bomblet +1",
    head = gear.globals.lustratio.head,
    body = gear.globals.adhemar.body,
    hands= gear.globals.herculean.hands.waltz,
    legs = gear.globals.meghanada.legs,
    feet = gear.globals.lustratio.feet,
    ring2= "Chirich Ring +1",
    ring1= "Epona's Ring",
  })

  ---------------------------------
  -- Magic Precast
  ---------------------------------
  sets.precast.FC = {
    ammo  = "Staunch Tathlum",
    head  = gear.globals.nyame.head,
    body  = gear.globals.adhemar.body,
    hands = "Leyline gloves",
    legs  = gear.globals.ayanmo.legs,
    feet  = gear.globals.carmine.feet,
    ear1  = "Etiolation Earring",
    ear1  = "Loquac. Earring",
    ring1 = "Kishar Ring",
    ring2 = "Gelatinous Ring +1",
    waist = "Siegel Sash"
  }

  ---------------------------------
  -- Magic Midcast
  ---------------------------------
  sets.midcast["Enhancing Magic"] = {
    head = gear.globals.carmine.head,
    legs = gear.globals.carmine.legs,
    ear1 = "Andoaa Earring",
    ring1= "Stikini Ring +1",
    ring2= "Stikini Ring",
    waist= "Olympus Sash",
  }

  sets.midcast.Cure = {

  }

  sets.midcast.Regen = {
    
  }
end

---------------------------------
-- built-in gearswap functions
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

function job_aftercast(spell, action, spellMap, eventArgs) 
  drawDisplay()
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

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local displayLines = L{}

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)

  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end