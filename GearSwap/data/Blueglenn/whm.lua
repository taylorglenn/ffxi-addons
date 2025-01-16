--------------------------------------------------------------------------
-----------------------     includes      --------------------------------
--------------------------------------------------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
end

---------------------------------
-- macros 
---------------------------------
function set_macros(book, sheet)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input / macro set ' .. tostring(sheet))
end
set_macros(13, 1)

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
  send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(13)

--------------------------------------------------------------------------
-----------------------     job setup      -------------------------------
--------------------------------------------------------------------------
function job_setup()
  state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
  state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
  state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false
end

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
  pos   = { x = 0, y = 0 },
  text  = { font = 'Consolas', size = 10 },
  bg    = { alpha = 255 },
  flags = { draggable = false }
}
displayBox = texts.new('${value}', displaySettings)

--------------------------------------------------------------------------
----------------------     user setup      -------------------------------
--------------------------------------------------------------------------
function user_setup() 
  state.IdleMode:options('Normal', 'Refresh', 'DT', 'MEva')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Acc')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'Resistant')
  send_command('bind ^c gs c cycle CastingMode')

  state.RegenMode = M{ 'Potency', 'Duration' }
  send_command('bind ^r gs c cycle RegenMode')

  state.WeaponLock = M(false, 'Weapon Lock')
  send_command('bind ^w gs c cycle WeaponLock')
  
  windower.register_event('prerender', drawDisplay)
  drawDisplay()

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.whm = {
    capes = { 
      fast_cast = { },
      cure    = { name="Alaunus's Cape", augments={'MND+20','MND+10','"Cure" potency +10%',} }, 
      nuking  = { name="Alaunus's Cape", augments={'MND+20','Mag. Acc+20 /Mag. Dmg.+20','Magic Damage +10','"Mag.Atk.Bns."+10',}}
    },
    
    neck = "Cleric's torque +1",

    artifact = {  
      head  = "Theo. cap +1",
      body  = "Theo. Bliaut +3",
      hands = "Theophany mitts +2",
      legs  = "Theo. pantaloons +1",
      feet  = "Theo. duckbills +1" 
    },
  
    relic = {     
      head  = "Piety cap +3",
      body  = "Piety Bliaut +3",
      hands = "Piety mitts +3",
      legs  = "Piety pantaloons +3",
      feet  = "Piety duckbills +3" 
    },
  
    empyrean = {  
      head  = "Ebers cap +1",
      body  = "Ebers Bliaut +1",
      hands = "Ebers mitts +1",
      legs  = "Ebers pantaloons +1",
      feet  = "Ebers duckbills +1" 
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
  send_command('unbind ^c') -- unbinds CastingMode from c key
  send_command('unbind ^w') -- unbinds WeaponLock from w key
end

--------------------------------------------------------------------------
--------------------     define gear sets      ---------------------------
--------------------------------------------------------------------------
function init_gear_sets()

  sets.idle = { 
    main = "Malignance Pole",
    sub  = "Mensch Strap +1",
    ammo = "Homiliary",
    head = gear.globals.inyanga.head,
    body = gear.globals.whm.artifact.body,
    hands= gear.globals.inyanga.hands,
    legs = gear.globals.inyanga.legs,
    feet = "Herald's gaiters",
    --neck = "Bathy choker +1",
    neck = gear.globals.whm.neck,
    ear1 = "Infused earring",
    ear2 = "Etiolation earring",
    ring1= "Defending ring",
    ring2= "Shneddick ring",
    back = "Moonbeam cape", -- get a pdt cape, you'll cap mdt with shell
    --back = "Aptitude Mantle +1",
    waist= "Hachirin-no-obi" 
  }

  sets.idle.Refresh = set_combine(sets.idle, { 
    ring1 = "Stikini Ring +1" 
  })

  sets.engaged = {
    ammo="Oshasha's Treatise",
    head="Aya. Zucchetto +2",
    body="Ayanmo Corazza +2",
    hands="Nyame Gauntlets",
    legs="Aya. Cosciales +2",
    feet="Aya. Gambieras +2",
    neck="Clotharius Torque",
    waist="Windbuffet Belt +1",
    left_ear="Brutal Earring",
    right_ear="Telos Earring",
    left_ring="Hetairoi Ring",
    right_ring="Petrov Ring",
    back="Moonbeam Cape",
  }

  sets.precast.WS = { }

  sets.precast.WS["Randgrith"] = set_combine(sets.precast.WS, {
    ammo="Oshasha's Treatise",
    head="Nyame Helm",
    body="Nyame Mail",
    hands="Nyame Gauntlets",
    legs="Nyame Flanchard",
    feet="Nyame Sollerets",
    neck={ name="Clr. Torque +1", augments={'Path: A',}},
    waist="Luminary Sash",
    left_ear="Glorious Earring",
    right_ear="Ishvara Earring",
    left_ring={ name="Metamor. Ring +1", augments={'Path: A',}},
    right_ring="Petrov Ring",
    back="Moonbeam Cape",
  })

  sets.precast.FC = { 
    main = gear.globals.grioavolr.fast_cast,
    sub  = "Thrace strap",
    ammo = "Hasty Pinion +1",
    head = gear.globals.inyanga.head,
    body = gear.globals.inyanga.body,
    hands= "Gendewitha Gages",
    legs = gear.globals.ayanmo.legs,
    feet = gear.globals.kaykaus.feet,
    neck = gear.globals.whm.neck,
    ear1 = "Loquac. Earring",
    ear2 = "Enchntr. Earring +1",
    ring1= "Prolix Ring",
    ring2= "Veneficium Ring",
    back = "Moonbeam cape", -- get a fc cape
    waist= "Witful belt" 
  }

  sets.precast.FC.Cure = set_combine(sets.precast.FC, { 
    ammo = "Impatiens",
    head = gear.globals.whm.artifact.head,
    ear1 = "Mendi. Earring"
  })

  sets.midcast.Cure = { 
    main = "Chatoyant staff",
    sub  = "Thrace strap",
    ammo = "Staunch Tathlum", -- replace with Pemphredo Tathlum from Sarsaok in Reisenjima
    head = gear.globals.kaykaus.head,
    body = gear.globals.whm.empyrean.body,
    hands= gear.globals.whm.artifact.hands,
    legs = gear.globals.whm.empyrean.legs,
    feet = gear.globals.kaykaus.feet,
    neck = gear.globals.whm.neck,
    ear1 = "Magnetic Earring",
    ear2 = "Glorious earring",
    ring1= "Lebeche Ring",
    ring2= "Mephitas's Ring +1",
    back = gear.globals.whm.capes.cure, -- get a cape like this: { MND +30, MEVA +20, CURE POT +10%, CASTING INTERRUPT -10% }
    waist= "Hachirin-no-obi" 
  }

  sets.midcast.Regen = set_combine(sets.midcast.cure, { 
    
  })
  sets.midcast.Regen.Potency = set_combine(sets.midcast.Regen, { 
    head = gear.globals.inyanga.head,
    body = gear.globals.whm.relic.body,	
    hands= gear.globals.telchine.hands.regen_pot, 	
    legs = gear.globals.telchine.legs.cure_regen_pot, 	
    feet = gear.globals.telchine.feet.regen_pot
  })
  sets.midcast.Regen.Duration = set_combine(sets.midcast.Regen, {
    head = gear.globals.telchine.head.enhancing_duration,
    body = gear.globals.telchine.body.enhancing_duration,	
    hands= gear.globals.telchine.hands.enhancing_duration_sird, 	
    legs = gear.globals.telchine.legs.enhancing_duration, 	
    feet = gear.globals.telchine.feet.enhancing_duration_sird
  })

  sets.midcast.Curaga = set_combine(sets.midcast.Cure, {  
    ammo = "Hydrocera",
    body = gear.globals.whm.artifact.body,
    back = "Twilight Cape" 
  }) -- get cape from Shinryu in Abyssea

  sets.midcast.Stoneskin  = { 
    neck = "Nodens Gorget", 
    waist = "Siegel Sash" 
  }

  sets.midcast.Cursna = { 
    head = gear.globals.kaykaus.head,
    body = gear.globals.whm.empyrean.body,
    hands= "Fanatic Golves",
    legs = gear.globals.ayanmo.legs,
    feet = gear.globals.kaykaus.feet,
    neck = "Debils Medallion",
    ring1= "Haoma's Ring",
    ring2= "Haoma's Ring",
    back = gear.globals.whm.capes.cure, 
  }

  sets.midcast['Divine Magic'] = {
    -- TODO
  }

  sets.midcast.Banish = set_combine(sets.midcast['Divine Magic'], {
    ammo  = "Ghastly Tathlum +1",
    head  = empty,
    body  = "Cohort Cloak +1",
    hands = "Fanatic Gloves",
    legs  = gear.globals.kaykaus.legs,
    feet  = "Theo. Duckbills +1",
    neck  = "Sanctity Necklace",
    waist = "Sacro Cord",
    ear1  = "Halasz Earring",
    ear2  = "Malignance Earring",
    ring1 = "Freke Ring",
    back  = gear.globals.whm.capes.nuking
  })

  sets.midcast.Holy = sets.midcast.Banish

end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local displayLines = L{}

  local afflatusStance = getAfflatusStance()
  local stratagemsAvailable = getStratagemsAvilable()

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[C]asting: '..state.CastingMode.value)
  displayLines:append('[R]egen: '..state.RegenMode.value)
  displayLines:append('[W]eapon Lock: '..tostring(state.WeaponLock.current))

  displayLines:append(' - ')
  displayLines:append('Stance: '..afflatusStance)

  if isSubSch() then
    displayLines:append(' - ')
    displayLines:append('Stratagems: '..tostring(stratagemsAvailable))
  end

  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end

--------------------------------------------------------------------------
---------------------     gearswap hooks      ----------------------------
--------------------------------------------------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  handleBuffGear(buff, gain)
  drawDisplay()
end

function job_precast(spell, action, spellMap, eventArgs)

end

function job_midcast(spell, action, spellMap, eventArgs)
  -----------------
  -- WHITE MAGIC --
  -----------------
  if (spell.type == 'WhiteMagic') then
    -- Regen 
    if (string.find(spell.name, 'Regen')) then 
      equip(sets.midcast.Regen[state.RegenMode.value])
      return
    end
  end
end

function job_post_precast(spell, spellMap, eventArgs)
  if string.find(spell.name, 'Cure') then
    if not buffactive['Afflatus Solace'] and not buffactive['Afflatus Misery'] then
      windower.add_to_chat(028, 'WARNING: Curing without Afflatus Solace active')
    end
    if isSubSch() and not buffactive['Aurorastorm'] then
      windower.add_to_chat(028, 'WARNING: Curing without Aurorastorm active')
    end
  end
end


function job_aftercast(spell, action, spellMap, eventArgs) 
  drawDisplay()
end

function job_state_change(field, newValue, oldValue)
  -- any mode changed
  if newValue == oldValue then
    drawDisplay()
    return
  end
  
  if field == state.WeaponLock.description and state.WeaponLock.value == true then
    disable('main', 'sub')
  else
    enable('main', 'sub')
  end

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

function getArtsState() 
  local self = windower.ffxi.get_player()
  for _,v in pairs(self.buffs) do
    if v == 359 then return arts.Dark end   --359 is Dark Arts
    if v == 358 then return arts.Light end  -- 358 is Light Arts
  end
end

function getAfflatusStance()
  local self = windower.ffxi.get_player()
  for _,v in pairs(self.buffs) do
    if v == 417 then return 'Afflatus Solace' end
    if v == 418 then return 'Afflatus Misery' end
  end
  return '--'
end

function isSubSch()
  local player = windower.ffxi.get_player()
  if (player == nil) then return false end
  return player.sub_job == 'SCH'
end
